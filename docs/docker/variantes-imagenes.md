# Variantes de imágenes

En este archivo podremos encontrar las posibles imágenes que se pueden usar en nuestro contenedor de ruby. La lista la he obtenido de la documentación de las imágenes oficiales de ruby en docker hub, puede consultarse [aquí](https://hub.docker.com/_/ruby). He consultado la lista oficial ya que estas van a estar mantenidas por la organización y además dispone de varios sistemas operativos a elegir.

## ruby:\<version\>

Se considera la imagen por defecto como contenedor ruby. Se recomienda su uso cuando no están claras las necesidades en el proyecto. Además, esta diseñado para usarse tanto como un contenedor desechable como la base para construir otras imágenes. En esta distinguimos dos etiquetas, buster y stretch, indicando en que versión de Debian se basan. Esta basada en *buildpack-deps*, diseñada para el usuario medio de Docker, por lo que tiene muchos paquetes Debian extremadamente comunes.

## ruby:\<version\>-slim

En esta imagen no están los paquetes comunes contenidos en la versión anterior, pues contiene los paquetes mínimos para ejecutar ruby. Se recomienda su uso cuando hay limitaciones de espacio o en proyectos en los que solo se necesita ruby.

## ruby:\<version\>-alpine

Basada en la famosa distribución de [Alpine](https://alpinelinux.org/), cuya principal ventaja es el poco peso que tiene dicha distribución, por lo que genera imágenes con muy pequeñas. Por ello, en el caso de que usemos esta imagen deberemos agregar nosotros las herramientas adicionales, ya que no es común que se incluyan. Como advertencia, esta imagen usa musl libc en vez de glibc and friends, por lo que podría provocar problemas dependiendo de los requisitos libc, aunque la mayoría del software no tiene problemas con ello.