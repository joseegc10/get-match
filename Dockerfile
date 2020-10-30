# Elegimos la imagen base y su versión
FROM ruby:2.7.2-alpine3.12 as base

# Definimos versión y persona encargada de mantener el Dockerfile
LABEL version="1.0" maintainer="José Alberto García <joseegc10@gmail.com>"

ARG GEM_HOME=/usr/local/bundle

FROM base as builder

ENV USER_NAME depuser
# Creamos un nuevo usuario
RUN adduser -D depuser

# Para poder instalar dependencias sin privilegios de super usuario
ENV GEM_HOME $GEM_HOME
ENV BUNDLE_APP_CONFIG="$GEM_HOME"

ENV USER_HOME /home/$USER_NAME/

USER $USER_NAME

# Copiamos archivos de dependencias
COPY Gemfile Gemfile.lock $USER_HOME

WORKDIR $USER_HOME

# las instalamos y los borramos
RUN bundle install

FROM base as final

# Creamos un nuevo usuario
RUN adduser -D testuser

USER testuser

ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

COPY --from=builder $GEM_HOME $GEM_HOME

# Definimos directorio de trabajo y volumen para tests
WORKDIR /test
VOLUME /test

# Se establece la ejecución de los tests
CMD ["rake", "test"]