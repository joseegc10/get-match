# Framework

En este punto de la aplicación, necesitamos un framework que nos permita exponer las operaciones para que mediante una interfaz REST se puedan acceder a ellas.

Existen numerosos framework que nos van a permitir conseguir esto en ruby. Tras buscar información sobre los posibles frameworks, pienso que los siguientes son interesantes para ser considerados:

- Rails: proporciona el mayor soporte al ser el más utilizado.
- Sinatra: es considerado un Rails más ligero y sencillo.
- Roda: dispone de una gran cantidad de plugins.
- Hanami: asegura que usa un 60% menos de memoria que otros frameworks.
- Grape: hace más sencilla la sintaxis de la API.

## Rails

En primer lugar, **directamente he decidido descartar Rails**. A pesar de ser el framework más conocido para ruby, pienso que este tiene una excesiva complejidad para ser mi primera API REST. Una parte de esto es debido a que Rails "obliga" a hacer la app como él quiere, estableciendo unas pautas demasiado marcadas para mi gusto. Además, el hecho de ser un Framework muy "potente" hace que tenga muchas componentes incluídas (las cuales no se van a usar para esta API), provocando un aumento del tiempo de carga.

## Resto de frameworks

Para elegir un framework entre los restantes, voy a tener en cuenta una serie de características que he considerado importantes.

### Tiempo creado

La primera variable que he considerado para la elección del framework ha sido el tiempo desde que fue creado, pues esto nos va a indicar que tiene un buen soporte detrás. Los framework anteriores son todos relativamente nuevos, pero en este aspecto **destaca Sinatra**, pues fue creado en 2008 y ha estado recibiendo actualizaciones desde entonces. Hanami y Roda fueron creados en 2014 y, aunque no son demasiado "jóvenes", Sinatra tiene el doble de tiempo que ellos, por lo que creo que podemos asegurar que tiene un gran soporte. Grape en este aspecto también considero que podemos asegurar que tiene un buen soporte, pues lleva recibiendo actualizaciones desde su creación en 2010.

### Aprovechamiento de la interfaz rack

[Rack](https://github.com/rack/rack), como ellos mismos dicen, "proporciona una interfaz mínima, modular y adaptable para desarrollar aplicaciones web en Ruby. Al empaquetar las solicitudes y respuestas HTTP de la manera más simple posible, unifica y destila la API para servidores web, marcos web y software intermedio (el llamado middleware) en una única llamada a método."

En mi caso, he considerado elegir Rack para la construcción de los middlewares de mi aplicación por la sencillez que aporta. Por ello, es importante saber con cuáles de los framework anteriores rack está soportado. Si nos vamos a la [página oficial](https://github.com/rack/rack) de rack, **vemos que Grape no está soportado, por lo que es el siguiente framework que queda descartado**.

### Documentación

Aunque pueda parecer que la documentación no pudiera ser muy determinante, en mi caso al ser la primera API REST que construyo, requiero de un framework que esté lo suficientemente documentado. En este caso, me he encontrado que roda tenía bastante poca documentación por parte de la comunidad y pienso que me iba a ser más complicado poder hacer lo mismo que en Sinatra o Hanami. Este último cuenta con una amplia [documentación](https://guides.hanamirb.org/introduction/getting-started/) por parte de los creadores, disponiendo incluso de tutoriales para el aprendizaje, mientras que Sinatra cuenta con una mayor documentación por parte de la comunidad.

### Sistema de enrutado

Roda tiene un sistema de enrutado "en árbol", que pienso que lo único que proporciona es complejidad. Aquí podemos ver un ejemplo de este sistema:

```ruby
r.on "a" do           # /a branch
  r.on "b" do         # /a/b branch
    r.is "c" do       # /a/b/c request
      r.get do end    # GET  /a/b/c request
      r.post do end   # POST /a/b/c request
    end
    r.get "d" do end  # GET  /a/b/d request
    r.post "e" do end # POST /a/b/e request
  end
end
```

Mediante el comando `on` divide una rama del arbol y usa `is` para indicar que la ruta finaliza. Todo esto pienso que proporciona una excesiva complejidad en comparación a Sinatra o Hanami. Por ejemplo, en Hanami podemos conseguir una ruta con el siguiente código, a mi parecer más sencillo:

```ruby
get '/hello', to: ->(env) { [200, {}, ['Hello from Hanami!']] }
```

Además, con sinatra se haría así:

```ruby
get '/' do
  'Hello world!'
end
```

Por esta razón y por lo explicado en el apartado de documentación, **he decidido descartar Roda**.

### Otros motivos

Una vez **tenemos descartados Roda, Rails y Grape, nos quedan Hanami y Sinatra**. Pienso que cualquiera de los dos hubiera sido muy adecuado en mi proyecto. Sin embargo, hay algunos aspectos que hacen que me decante por uno de ellos.

El primero es **la existencia del framework Padrino**, un framework construido sobre Sinatra. Este agrega elementos adicionales como el almacenamiento en caché, mailers, etc. Debido a la existencia de Padrino, pienso que es adecuado elegir Sinatra, pues en caso de que la complejidad de mi aplicación crezca demasiado, me va a permitir pasar directamente mi aplicación hecha con Sinatra a este framework, aumentando las posibilidades a realizar.

Otra razón es que considero que el lenguaje DSL proporcionado por Sinatra es más sencillo que el proporcionado por Hanami, pudiéndose ver un ejemplo en el apartado anterior.

Por último, otra razón más a favor de Sinatra es que **permite realizar los tests del código mediante Rspec (lo que uso en mi proyecto) y Rack, con la biblioteca rack/test**, por lo que no necesito ninguna otra biblioteca más.

## Conclusión

Por todos los motivos anteriores, he decidido **hacer uso del framework Sinatra** pues, en resumen, me proporciona un DSL sencillo, un tiempo de carga aceptable, una alta compatibilidad con Rack y un gran soporte.