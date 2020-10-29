# Test

Como he explicado en el apartado de herramientas, como herramienta de construcción uso Rake. En ella, he creado una tarea que automatiza el test de las clases creadas. Para realizar el test de todas las clases, hay que hacer lo siguiente:

`rake test`

Sin embargo, he creado tareas para hacer los test de forma particular para cada clase.

Para la clase Partido:

`rake partido`

Para la clase Equipo:

`rake equipo`

Para la clase Jugador:

`rake jugador`

Para la clase Jornada:

`rake jornada`

Además, aqui se puede ver una muestra de ejecución de los test, comprobando la inexistencia de errores:

![ejemplo rake](https://github.com/joseegc10/get-match/blob/master/docs/img/rake.png)