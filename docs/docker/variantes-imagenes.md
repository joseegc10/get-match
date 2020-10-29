# Variantes de imágenes

En este archivo podremos encontrar las posibles imágenes que se pueden usar en nuestro contenedor de ruby. La lista la he obtenido de la documentación de las imágenes oficiales de ruby en docker hub, puede consultarse [aquí](https://hub.docker.com/_/ruby). 

**En primer lugar, he consultado la lista oficial ya que estas van a estar mantenidas por la organización y además dispone de varios sistemas operativos a elegir. Existen las siguientes tres versiones:**

## ruby:\<version\>

Se considera la imagen por defecto como contenedor ruby. Se recomienda su uso cuando no están claras las necesidades en el proyecto. En esta distinguimos dos etiquetas, buster y stretch, indicando en que versión de Debian se basan. Posee una gran cantidad de paquetes comunes de Debian, por lo que esto hace que aumente su peso.

## ruby:\<version\>-slim

En esta imagen no están los paquetes comunes contenidos en la versión anterior, pues contiene los paquetes mínimos para ejecutar ruby. Se recomienda su uso cuando hay limitaciones de espacio o en proyectos en los que solo se necesita ruby.

## ruby:\<version\>-alpine

Basada en la distribución de [Alpine](https://alpinelinux.org/), cuya principal ventaja es el poco peso que tiene dicha distribución, por lo que genera imágenes muy pequeñas. Por ello, en el caso de que usemos esta imagen deberemos agregar nosotros las herramientas adicionales, ya que no es común que se incluyan.

## Imagen base Alpine sin ruby

Posteriormente, podemos pensar en usar como imagen base un sistema operativo que no traiga ruby por defecto. Por la fama que he visto que tiene, he decidido usar la imagen base de Alpine, pues esta nos va a permitir tener un tamaño de la imagen base muy pequeño, pudiendo instalar los paquetes que sean estrictamente necesarios.

Para ve