# Get-Match
> Proyecto de la asignatura IV 

![logo-get-match](https://github.com/joseegc10/get-match/blob/master/docs/img/logo.png)

## Problema a resolver :soccer:

Con get-match se pretende ofrecer la posibilidad al usuario de saber el resultado y goleadores de un partido de fútbol. La motivación de get-match viene dada porque es un problema que hemos tenido en mi grupo de amigos y para solucionarlo hemos tenido que recurrir a aplicaciones que realicen lo mismo, por lo que quiero desarrollar una API propia que lo resuelva. Además, al ser mi primer proyecto de este estilo, pienso que no tiene una excesiva dificultad y lo veo como una buena opción de empezar. Como conclusión, lo que quiero desarrollar es una API REST que, mediante peticiones HTTP, proporcione todo lo relacionado con el problema a resolver.

## Integración continua

### Travis-CI

- La documentación sobre el proceso seguido en la configuración de Travis se puede ver en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/travis/config_travis.md).
- Para consultar una explicación de Travis-CI, incluyendo sus ventajas, como se ha hecho la construcción del fichero .travis.yml y otras posibilidades que nos ofrece, seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/travis/travis.md).

### Circle-CI

- La documentación sobre el proceso seguido en la configuración de CircleCI se puede ver en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/circleci/config_circleci.md).
- Para consultar una explicación de CircleCI, incluyendo sus ventajas, como se ha construido el fichero config.yml y una comparación con Travis, consultar el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/circleci/circleci.md).

## Contenedor para pruebas

### Docker

- En primer lugar, he explicado las posibles imágenes oficiales a elegir de ruby y se pueden encontrar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/variantes-imagenes.md).
- La justificación y elección de la imagen de ruby se puede encontrar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/pruebas-imagenes.md).
- Para consultar la optimización de la imagen que he elegido, consultar el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/optimizacion.md).
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

- El test de la clase principal jornada se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/spec/jornada_spec.rb).
- Otros tests:
    - [Clase partido](https://github.com/joseegc10/get-match/blob/master/spec/partido_spec.rb)
    - [Clase jugador](https://github.com/joseegc10/get-match/blob/master/spec/jugador_spec.rb)
    - [Clase equipo](https://github.com/joseegc10/get-match/blob/master/spec/equipo_spec.rb)

## Historias de usuario :walking:

Las historias de usuario del proyecto se pueden consultar [aquí](https://github.com/joseegc10/get-match/issues?q=is%3Aissue+is%3Aopen+label%3Auser-stories).

## Dependencias

Para consultar la información acerca de como se administran las depedencias, seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/dependencias.md).

## Test

La información acerca de los test de las clases se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/docs/test.md).

## Enlaces adicionales :clipboard:

- Los **pasos a seguir** en el desarrollo del proyecto se pueden consultar [aquí](https://github.com/joseegc10/get-match/blob/master/docs/Pasos-a-seguir.md).
- Las **tareas (issues) completadas** se pueden consultar [aquí](https://github.com/joseegc10/get-match/issues?q=is%3Aissue+is%3Aclosed).
- El **fichero iv.yaml** se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/iv.yaml).
- [Otros enlaces adicionales](https://github.com/joseegc10/get-match/blob/master/docs/enlaces_adicionales.md).

## Autor :man:

[José Alberto García Collado](https://github.com/joseegc10)
