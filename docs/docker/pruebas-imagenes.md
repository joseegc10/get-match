# Pruebas para imágenes de ruby

En este fichero se va a realizar una comparación en tamaño y velocidad de ejecución de tests entre las diferentes imágenes oficiales de ruby, pudiéndose consultar estas en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/variantes-imagenes.md). Tras analizar dicha comparación, elegiré la imagen que se usará en mi contenedor.

Comentar que he tenido en cuenta las imágenes oficiales de ruby, ya que en primer lugar, descarté elegir como imagen base un sistema operativo sin ruby puesto que a dichas imágenes se le deberían instalar los paquetes necesarios para trabajar con ruby, cosa que en las imágenes oficiales de este lenguaje vienen instalados y optimizados, por lo que pienso que a la larga va a resultar mejor partir de una imagen oficial de ruby. Podría pensarse que las imagenes oficiales de ruby tendrán un gran tamaño ya que vienen con dichos paquetes instalados, pero pudiendo elegir ruby con sistemas operativos como alpine hace que podamos elegir imágenes bastante ligeras.

**Se hará uso de las versiones 2.7.2 de las imágenes, pues esta es la última versión final disponible en este momento (también existe una preview de la 3.0.0).**

## Peso de la imagen

### ruby:\<2.7.2\>

![buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/buster.png)

### ruby:\<2.7.2\>-slim

![slim-buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/slim-buster.png)

### ruby:\<2.7.2\>-alpine

![alpine](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/alpine.png)


## Tiempo de construcción

### ruby:\<2.7.2\>

![buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/buster-tiempo.png)

### ruby:\<2.7.2\>-slim

![slim-buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/slim-buster-tiempo.png)

### ruby:\<2.7.2\>-alpine

![alpine](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/alpine-tiempo.png)


## Análisis de resultados

### Pesos

En primer lugar, realizamos la comparación a partir del peso de las imágenes. Para ello, realizo una gráfica de comparación:

![grafica-pesos](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/grafica-peso.png)

Como podemos ver, hay una gran diferencia entre la versión "estándar" y el resto de imágenes. Entre la slim y la alpine hay más similitud, aunque vemos que slim pesa más de 2 veces lo que pesa alpine.

### Tiempo de tests

Posteriormente, comparamos el tiempo de ejecución de los test, es decir, el tiempo que tardan en ejecutar el siguiente comando.

`docker run -t -v `pwd`:/test id`

donde id es el id de la imagen, el cual podemos obtener con la orden `docker images`

La gráfica de tiempos la he obtenido con el comando **time** y es la siguiente:

![grafica-tiempos](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/grafica-tiempo.png)

En esta gráfica, podemos apreciar que los tiempos son muy parecidos, pues están todos recogidos entre 1,05 y 1,1. A pesar de ello, vemos que el menor tiempo se da con la versión slim (la segunda menos pesada) y el segundo mejor tiempo con alpine, por lo que la versión estandar queda totalmente descartada al ser la más pesada y la que más tarda.

### Conclusión

Como conclusión, **he optado por elegir la versión alpine**, pues es 2,4 veces menos pesada que la versión slim y a pesar de ser más rapida la versión slim, veo que esta diferencia es muy pequeña (en términos de milisegundos), por lo que merece más la pena elegir en función del peso y por tanto elijo alpine. Además, esta versión viene con los paquetes necesarios para la ejecución de mi proyecto, como son Bundler y Rake, no teniendo paquetes extras que aumenten demasiado el tamaño de la imagen base.