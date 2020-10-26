# Dockerfile

En este documento se recogerán los distintos pasos que se llevan a cabo en el dockerfile. Para ello, se ha seguido las buenas prácticas para su desarrollo, que se pueden encontrar en el siguiente [enlace](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).

**De forma general, se han seguido las siguientes buenas prácticas:**
- Organizar los comandos en orden de importancia, ya que Docker usa caché para la construcción de la imagen y es capaz de reusar resultados para hacerlo más rapido, pero si uno de los comandos cambia, los que le suceden van a tener que volver a ejecutarse.
- Elegir bien la imagen base, para ello se ha hecho un estudio de comparación entre las distintas imágenes oficiales de ruby que se puede consultar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/pruebas-imagenes.md).
- Elegir la versión de una imagen base, puesto que si no la elegimos se usará la última y puede que el entorno no sea reproducible.
- Copiar solo los archivos que sean estrictamente necesarios.


**En el Dockerfile podremos distinguir:**
1. Elección de la imagen base y versión.

`FROM ruby:2.7.2-buster`

2. Definimos las etiquetas de versión y persona encargada del Dockerfile.

`LABEL version="1.0" maintainer="José Alberto García <joseegc10@gmail.com>"`

3. Creamos un grupo de usuario para los test y creamos un usuario en dicho grupo.

`RUN groupadd -r testgroup && useradd -r -g testuser testgroup`

4. Ejecutamos prueba para ver si son compatible Gemfile y Gemfile.lock.

`RUN bundle config --global frozen 1`

5. Copiamos fichero Gemfile y Gemfile.lock, instalamos dependencias y borramos los ficheros que habíamos añadido.

`COPY Gemfile Gemfile.lock ./`

`RUN bundle install`

`RUN rm Gemfile Gemfile.lock`

6. Pasamos al usuario sin privilegios de root.

`USER testuser`

7. Definimos directorio de trabajo y creamos un volumen para realizar los test.

`WORKDIR /test`

`VOLUME /test`

8. Se establece la ejecución de los tests.

`CMD ["rake", "test"]`