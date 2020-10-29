# Pruebas para imágenes de ruby

En este fichero se va a realizar una comparación en tamaño y velocidad de ejecución de tests entre las diferentes imágenes oficiales de ruby, pudiéndose consultar estas en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/variantes-imagenes.md). Tras analizar dicha comparación, elegiré la imagen que se usará en mi contenedor.

**Se hará uso de las versiones 2.7.2 de las imágenes oficiales de ruby, pues esta es la última versión final disponible en este momento (también existe una preview de la 3.0.0).**

## Peso de la imagen

### ruby:\<2.7.2\>

![buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/buster.png)

### ruby:\<2.7.2\>-slim

![slim-buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/slim-buster.png)

### ruby:\<2.7.2\>-alpine

![alpine](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/alpine.png)

### alpine:3.12.1

![alpine-base](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/alpine-base.png)

## Tiempo de construcción

### ruby:\<2.7.2\>

![buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/buster-tiempo.png)

### ruby:\<2.7.2\>-slim

![slim-buster](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/slim-buster-tiempo.png)

### ruby:\<2.7.2\>-alpine

![alpine](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/alpine-tiempo.png)

### alpine:3.12.1

![alpine-base](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/alpine-base-tiempo.png)

## Análisis de resultados

### Pesos

En primer lugar, realizamos la comparación a partir del peso de las imágenes. Para ello, realizo una gráfica de comparación:

![grafica-pesos](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/grafica-peso.png)

Como podemos ver, hay una gran diferencia entre la versión "estándar" y el resto de imágenes. Entre la slim y la alpine de ruby hay más similitud, aunque vemos que slim pesa más de 2 veces lo que pesa alpine de ruby. Entre la alpine de ruby y la alpine que he creado yo vemos que no existe demasiada diferencia de peso, pues se diferencian en unos 30MB. Esta disminución de mi imagen con respecto a la oficial de ruby es porque he instalado solo lo necesario para la ejecución.

### Tiempo de tests

Posteriormente, comparamos el tiempo de ejecución de los test, es decir, el tiempo que tardan en ejecutar el siguiente comando.

`docker run -t -v pwd:/test id`

donde id es el id de la imagen, el cual podemos obtener con la orden `docker images`

**Comentar que para obtener la gráfica de tiempos se han realizado 5 ejecuciones de cada imagen y se ha realizado la media, por el hecho de existir poca diferencia entre todos.**

La gráfica de tiempos la he obtenido con el comando **time** y es la siguiente:

![grafica-tiempos](https://github.com/joseegc10/get-match/blob/master/docs/img/contenedores/grafica-tiempo.png)

En esta gráfica, podemos apreciar que los tiempos son muy parecidos, pues están todos recogidos entre 1 y 1,5. A pesar de ello, vemos que el menor tiempo se da con la versión slim (la segunda menos pesada) y el segundo mejor tiempo con alpine de ruby, por lo que la versión estandar queda totalmente descartada al ser la más pesada y la que más tarda.

### Conclusión

Como conclusión, **he optado por elegir la versión oficial de ruby de alpine**, pues es 2,4 veces menos pesada que la versión slim y a pesar de ser más rapida la versión slim, veo que esta diferencia es muy pequeña (en términos de milisegundos), por lo que merece más la pena elegir en función del peso y por tanto elijo alpine. Además, esta versión viene con los paquetes necesarios para la ejecución de mi proyecto, como son Bundler y Rake, no teniendo paquetes extras que aumenten demasiado el tamaño de la imagen base.

En cuanto a la diferencia con mi imagen base de alpine, pienso que existe muy poca diferencia en peso, mientras que en ejecución mi versión de alpine es la que más tarde, por lo que pienso que en el momento que mi proyecto vaya cogiendo más tamaño se aumentará la diferencia de tiempos y prefiero optar por una imagen que es casi igual de pesada pero que tarda menos, como es la versión oficial de alpine de ruby.