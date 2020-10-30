# Elegimos la imagen base y su versión
FROM ruby:2.7.2-alpine3.12

# Definimos versión y persona encargada de mantener el Dockerfile
LABEL version="1.0" maintainer="José Alberto García <joseegc10@gmail.com>"

# Creamos un nuevo usuario
RUN adduser -D testuser

# Para poder instalar dependencias sin privilegios de super usuario
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$PATH
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

USER testuser

# Copiamos archivos de dependencias
COPY Gemfile Gemfile.lock /home/testuser/

WORKDIR /home/testuser/

# las instalamos y los borramos
RUN bundle install
RUN rm /home/testuser/Gemfile /home/testuser/Gemfile.lock

# Definimos directorio de trabajo y volumen para tests
WORKDIR /test
VOLUME /test

# Se establece la ejecución de los tests
CMD ["rake", "test"]