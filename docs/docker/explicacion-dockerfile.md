# Dockerfile

En este documento se recogerán los distintos pasos que se llevan a cabo en el dockerfile. Para ello, se ha seguido las buenas prácticas para su desarrollo, que se pueden encontrar en el siguiente [enlace](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).

**De forma general, se han seguido las siguientes buenas prácticas:**
- Organizar los comandos en orden de importancia, ya que Docker usa caché para la construcción de la imagen y es capaz de reusar resultados para hacerlo más rapido, pero si uno de los comandos cambia, los que le suceden van a tener que volver a ejecutarse.
- Elegir bien la imagen base, para ello se ha hecho un estudio de comparación entre las distintas imágenes oficiales de ruby que se puede consultar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/pruebas-imagenes.md).
- Elegir la versión de una imagen base, puesto que si no la elegimos se usará la última y puede que el entorno no sea reproducible.
- Copiar solo los archivos que sean estrictamente necesarios.
- Ejecutar con privilegios de super usuario lo estrictamente necesario.


**En el Dockerfile podremos distinguir:**

Elegimos la imagen base y su versión:

`FROM ruby:2.7.2-alpine3.12 as base`

Definimos versión y persona encargada de mantener el Dockerfile

`LABEL version="1.0" maintainer="José Alberto García <joseegc10@gmail.com>"`

Declaramos variable global

`ARG GEM_HOME=/usr/local/bundle`

Añadimos una nueva imagen para las dependencias

`FROM base as builder`

Creamos una variable para el usuario

`ENV USER_NAME depuser`

Creamos un nuevo usuario

`RUN adduser -D depuser`

Definimos donde se van a instalar las dependencias

`ENV GEM_HOME $GEM_HOME`

`ENV BUNDLE_APP_CONFIG="$GEM_HOME"`

Definimos nueva variable

`ENV USER_HOME /home/$USER_NAME/`

Pasamos al usuario sin privilegios

`USER $USER_NAME`

Copiamos archivos de dependencias

`COPY Gemfile Gemfile.lock $USER_HOME`

Pasamos al directorio de trabajo de usuario

`WORKDIR $USER_HOME`

Instalamos dependencias

`RUN bundle install`

Añadimos la imagen final

`FROM base as final`

Creamos un nuevo usuario

`RUN adduser -D testuser`

Pasamos al usuario de test

`USER testuser`

Definimos variable donde se encuentras las dependencias

`ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH`

Copiamos las dependencias de la imagen anterior a la final

`COPY --from=builder $GEM_HOME $GEM_HOME`

Definimos directorio de trabajo y volumen para tests

`WORKDIR /test`

`VOLUME /test`

Se establece la ejecución de los tests

`CMD ["rake", "test"]`