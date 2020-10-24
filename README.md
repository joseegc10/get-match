# Get-Match
> Proyecto de la asignatura IV 

![logo-get-match](https://github.com/joseegc10/get-match/blob/master/docs/img/logo.png)

## Problema a resolver :soccer:

Con get-match se pretende ofrecer la posibilidad al usuario de saber el resultado y goleadores de un partido de fútbol. La motivación de get-match viene dada porque es un problema que hemos tenido en mi grupo de amigos y para solucionarlo hemos tenido que recurrir a aplicaciones que realicen lo mismo, por lo que quiero desarrollar una API propia que lo resuelva. Además, al ser mi primer proyecto de este estilo, pienso que no tiene una excesiva dificultad y lo veo como una buena opción de empezar. Como conclusión, lo que quiero desarrollar es una API REST que, mediante peticiones HTTP, proporcione todo lo relacionado con el problema a resolver.

## Herramientas y justificación :hammer:

- Como **lenguaje de programación** he elegido [Ruby](https://www.ruby-lang.org/es/), ya que es un lenguaje no demasiado difícil y con el cual no he realizado ningún proyecto. Esto me motiva a elegirlo, para poder aprender a realizar proyectos en este lenguaje.
- Como **gestor de versiones** de ruby he elegido **RVM**, cuya información puede encontrarse en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/rvm.md).
- Como **herramienta de gestión de dependencias** se hace uso de **bundler**. La información acerca de esta herramienta se puede consultar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/bundler.md).
- Como **herramienta para testear el código** uso **RSpec**, documentada en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/rspec.md).
- Como **gestor de tareas** uso **Rake**, documentada en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/rake.md).
- El planteamiento del **resto de herramientas** que se van a usar en el desarrollo del proyecto se puede consultar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/herramientas.md).

## Enlaces adicionales :clipboard:

- El proceso seguido para la **configuración de git** se puede consultar [aquí](https://github.com/joseegc10/ejercicios-IV/blob/master/configuracion-git/Pasos-seguidos.md).
- Los **pasos a seguir** en el desarrollo del proyecto se pueden consultar [aquí](https://github.com/joseegc10/get-match/blob/master/docs/Pasos-a-seguir.md).
- Las **tareas (issues) completadas** se pueden consultar [aquí](https://github.com/joseegc10/get-match/issues?q=is%3Aissue+is%3Aclosed).
- El **fichero iv.yaml** se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/iv.yaml).
- El **fichero Rakefile**, donde se automatizan las tareas, se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/Rakefile).

## Código principal :page_facing_up:

- La **clase principal** del proyecto es la clase partido. Esta clase se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/src/partido.rb). Una explicación de esta clase y de las posibles clases futuras viene dada en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/Clase-Partido.md).
- Además, otras **clases auxiliares** son la clase [jugador](https://github.com/joseegc10/get-match/blob/master/src/jugador.rb) y la clase [equipo](https://github.com/joseegc10/get-match/blob/master/src/equipo.rb).

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

## Contenedor para pruebas

### Docker

- En primer lugar, he explicado las posibles imágenes oficiales a elegir de ruby y se pueden encontrar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/variantes-imagenes.md).
- La justificación y elección de la imagen de ruby se puede encontrar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/pruebas-imagenes.md).
- El fichero Dockerfile se puede encontrar [aquí](https://github.com/joseegc10/get-match/blob/master/Dockerfile).
- Para consultar las buenas prácticas seguidas y la explicación del fichero Dockerfile, se pueden seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/docker/explicacion-dockerfile.md).

### Registro de contenedores

- He usado Docker Hub para almacenar el contenedor creado, el repositorio donde se ha subido el contenedor se puede consultar [aquí](https://hub.docker.com/repository/docker/joseegc10/get-match).
- Además, he hecho uso de GitHub Container Registry como registro alternativo, puediendo consultarse [aquí]().

Para más información sobre los registros de contenedores, consultar el siguiente [enlace]().

## Dependencias

Como he explicado en el apartado de herramientas, como gestor de dependencias uso bundler. Para instalar las dependencias podemos usar:

`bundle install`

Además, he creado una tarea en rake para poder realizar lo mismo, se haría de la siguiente forma:

`rake install`

Comentar que para poder realizar esto, es necesario tener instaladas las dos gemas:

`gem install bundler`

`gem install rake`

La documentación que he creado sobre bundler y rake se puede consultar en el apartado de herramientas.

Por último, el fichero Gemfile, donde se declaran las gemas a instalar, se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/Gemfile).

## Test

Como he explicado en el apartado de herramientas, como herramienta de construcción uso Rake. En ella, he creado una tarea que automatiza el test de las clases creadas. Para realizar el test de todas las clases, hay que hacer lo siguiente:

`rake test`

Para más información sobre el test (como ejecutar test para una clase particular), consultar el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/test.md).

## Autor :man:

[José Alberto García Collado](https://github.com/joseegc10)
