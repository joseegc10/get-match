# Optimización de la imagen

En primer lugar, la optimización ha consistido en la elección de una imagen base que fuera poco pesada como es el caso de alpine y tal y como se pudo ver en el archivo de comparación de las imágenes. Esta imagen contiene los paquetes necesarios para la ejecución, no sobrecargando de paquetes innecesarios.

**Para consultar el dockerfile del que partí para realizar la optimización, seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/Dockerfile-inicial).**

Además, para conseguir reducir el tamaño de la imagen, he seguido el concepto de "multi-stage builds". Con este concepto, se pueden definir varias imágenes, realizando en cada una de ellas lo necesario, copiando de una a otra lo que sea necesario y dejar atrás todo lo que no lo sea. En mi caso, hago uso de dos imágenes:

- La primera me sirve para instalar las dependencias, pasando a la imagen final los archivos necesarios para que se enlacen en la ejecución de los tests.
- La segunda es mi imagen final. Esta recibe de la primera imagen las dependencias y ejecuta los tests.

Para conseguir que funcione, he visitado la documentación oficial de bundler para docker, pudiendo consultarse [aquí](https://bundler.io/v2.1/guides/bundler_docker_guide.html).

Esencialmente lo que tuve que hacer fue definir dos variables de entorno, para que bundler instale todas las gemas en la misma ubicación. Estas variables son las siguientes:

`ARG GEM_HOME=/usr/local/bundle`

`ENV GEM_HOME $GEM_HOME`

`ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH`

Posteriormente, copio las depedencias desde la imagen primera hasta la imagen final.

`COPY --from=builder $GEM_HOME $GEM_HOME`

Gracias a lo anterior, pude reducir el tamaño de la imagen considerablemente. El tamaño final ha sido el siguiente:

![finalimage](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/final-image.png)

Como vimos en el fichero de comparación, el tamaño inicial era de 69.3MB. Ahora, como vemos, hemos conseguido reducirlo a 53.7MB.