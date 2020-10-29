# Get-Match
> Proyecto de la asignatura IV 

![logo-get-match](https://github.com/joseegc10/get-match/blob/master/docs/img/logo.png)

## Problema a resolver :soccer:

Con get-match se pretende ofrecer la posibilidad al usuario de saber el resultado y goleadores de un partido de fútbol. La motivación de get-match viene dada porque es un problema que hemos tenido en mi grupo de amigos y para solucionarlo hemos tenido que recurrir a aplicaciones que realicen lo mismo, por lo que quiero desarrollar una API propia que lo resuelva. Además, al ser mi primer proyecto de este estilo, pienso que no tiene una excesiva dificultad y lo veo como una buena opción de empezar. Como conclusión, lo que quiero desarrollar es una API REST que, mediante peticiones HTTP, proporcione todo lo relacionado con el problema a resolver.

## Contenedor para pruebas

### Docker

- En primer lugar, he explicado las posibles imágenes oficiales a elegir de ruby y se pueden encontrar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/variantes-imagenes.md).
- La justificación y elección de la imagen de ruby se puede encontrar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/pruebas-imagenes.md).
- El fichero Dockerfile se puede encontrar [aquí](https://github.com/joseegc10/get-match/blob/master/Dockerfile).
- Para consultar las buenas prácticas seguidas y la explicación del fichero Dockerfile, se pueden seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/explicacion-dockerfile.md).

### Registro de contenedores

- He usado Docker Hub para almacenar el contenedor creado, el repositorio donde se ha subido el contenedor se puede consultar [aquí](https://hub.docker.com/r/joseegc10/get-match). Para ver más información sobre la configuración de Docker Hub, consultar el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/docker-hub.md).
- Además, he hecho uso de GitHub Container Registry como registro alternativo, puediendo consultarse [aquí](https://github.com/users/joseegc10/packages/container/package/env-get-match). Para ver más información sobre la configuración de GitHub Container Registry, consultar el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/git-hub-container.md).

### Github Action

He creado una github action para que cuando hagamos push al repositorio de github, haga un build de nuevo de la imagen, ejecute los tests y si no fallan estos, haga push automáticamente a Github Container Registry. Esta Github Action se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/.github/workflows/contenedor.yml).

## Herramientas y justificación :hammer:

Para consultar las herramientas que se usan en el proyecto seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/herramientas.md).

## Código principal :page_facing_up:

- La **clase principal** del proyecto es la clase jornada. Esta clase se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/src/jornada.rb). Una explicación de esta clase y de las posibles clases futuras viene dada en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/Clase-Jornada.md).
- Además, otras **clases auxiliares** son la clase [partido](https://github.com/joseegc10/get-match/blob/master/src/partido.rb), [jugador](https://github.com/joseegc10/get-match/blob/master/src/jugador.rb) y la clase [equipo](https://github.com/joseegc10/get-match/blob/master/src/equipo.rb).

## Código de test

- El test de la clase principal partido se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/spec/partido_spec.rb).
- Otros tests:
    - [Clase jugador](https://github.com/joseegc10/get-match/blob/master/spec/jugador_spec.rb)
    - [Clase equipo](https://github.com/joseegc10/get-match/blob/master/spec/equipo_spec.rb)

## Historias de usuario :walking:

- [HU1](https://github.com/joseegc10/get-match/issues/1): Como usuario, quiero poder consultar el resultado de un partido.
- [HU2](https://github.com/joseegc10/get-match/issues/2): Como usuario, me gustaría poder consultar los goleadores de un partido.
- [HU3](https://github.com/joseegc10/get-match/issues/32): Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue.
- [HU4](https://github.com/joseegc10/get-match/issues/35): Como usuario, debo poder consultar el máximo goleador de un partido.

## Dependencias

Para consultar la información acerca de como se administran las depedencias, seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/dependencias.md).

## Test

La información acerca de los test de las clases se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/docs/test.md).

## Enlaces adicionales :clipboard:

- El proceso seguido para la **configuración de git** se puede consultar [aquí](https://github.com/joseegc10/ejercicios-IV/blob/master/configuracion-git/Pasos-seguidos.md).
- Los **pasos a seguir** en el desarrollo del proyecto se pueden consultar [aquí](https://github.com/joseegc10/get-match/blob/master/docs/Pasos-a-seguir.md).
- Las **tareas (issues) completadas** se pueden consultar [aquí](https://github.com/joseegc10/get-match/issues?q=is%3Aissue+is%3Aclosed).
- El **fichero iv.yaml** se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/iv.yaml).
- El **fichero Rakefile**, donde se automatizan las tareas, se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/Rakefile).

## Autor :man:

[José Alberto García Collado](https://github.com/joseegc10)
