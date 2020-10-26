# Registro de contenedores

## Docker Hub

En primer lugar he usado Docker Hub. Para ello, tras crearme la cuenta, he creado el repositorio y lo he conectado con mi repositorio de GitHub. El repositorio se puede encontrar en el siguiente [enlace](https://hub.docker.com/r/joseegc10/get-match), mostrándose a continuación una prueba de su creación:

![docker-hub](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/docker-hub.png)

Además, el tiempo de construcción que se requiere en Docker Hub es de 1 minuto, tal y como se muestra en la siguiente imagen:

![tiempo-docker-hub](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/tiempo-docker-hub.png)

Además, para demostrar la correcta configuración de docker hub para que se realice un build automáticamente tras hacer push a nuestro repositorio de github, podemos ver la siguiente imagen:

![dh](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/docker-hub-auto-build.png)

Para conseguir esto, tuve que crear un repo en docker hub, configurándolo de la siguiente forma:

![dh2](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/config-dh.png)