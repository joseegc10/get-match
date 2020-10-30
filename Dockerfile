# Elegimos la imagen base y su versión
FROM ruby:2.7.2-alpine3.12 as base

# Definimos versión y persona encargada de mantener el Dockerfile
LABEL version="1.0" maintainer="José Alberto García <joseegc10@gmail.com>"

# Declaramos variable global
ARG GEM_HOME=/usr/local/bundle

# Añadimos una nueva imagen para las dependencias
FROM base as builder

# Creamos una variable para el usuario
ENV USER_NAME depuser

# Creamos un nuevo usuario
RUN adduser -D depuser

# Definimos donde se van a instalar las dependencias
ENV GEM_HOME $GEM_HOME
ENV BUNDLE_APP_CONFIG="$GEM_HOME"

# Definimos nueva variable
ENV USER_HOME /home/$USER_NAME/

# Pasamos al usuario sin privilegios
USER $USER_NAME

# Copiamos archivos de dependencias
COPY Gemfile Gemfile.lock $USER_HOME

# Pasamos al directorio de trabajo de usuario
WORKDIR $USER_HOME

# Instalamos dependencias
RUN bundle install

# Añadimos la imagen final
FROM base as final

# Creamos un nuevo usuario
RUN adduser -D testuser

# Pasamos al usuario de test
USER testuser

# Definimos variable donde se encuentras las dependencias
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# Copiamos las dependencias de la imagen anterior a la final
COPY --from=builder $GEM_HOME $GEM_HOME

# Definimos directorio de trabajo y volumen para tests
WORKDIR /test
VOLUME /test

# Se establece la ejecución de los tests
CMD ["rake", "test"]