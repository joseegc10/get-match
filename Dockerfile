# Elegimos la imagen base y su versión
FROM ruby:2.7.2-buster

# Definimos version y persona encargada de mantener el Dockerfile
LABEL version="1.0" maintainer="José Alberto García <joseegc10@gmail.com>"

# Lanza error si el Gemfile no es compatible con Gemfile.lock
RUN bundle config --global frozen 1

# Copiamos archivos de dependencias, las instalamos y los borramos
COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN rm Gemfile Gemfile.lock

# Definimos directorio de trabajo y volumen para tests
WORKDIR /test
VOLUME /test

# Se establece la ejecución de los tests
CMD ["rake", "test"]