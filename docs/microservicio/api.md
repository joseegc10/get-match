# Diseño del API

## Aspectos generales

Sinatra nos permite el diseño del API mediante una clase que herede de la clase Sinatra::Base. Dentro de esta clase, voy a usar tres variables de clase que me van a permitir realizar todas las operaciones:

- manejador: esta variable va a hacer las peticiones del método correspondiente a la clase manejadora que se explicará posteriormente.
- jsonify: esta variable contendrá el objeto de la clase Jsonify (explicada posteriormente) que nos permitirá hacer la "traducción" de los objetos recibidos en el post en formato JSON a objetos de mis clases.
- logger: esta variable va a contener el objeto logger que me va a permitir sacar información a la salida correspondiente.

Para la creación de estas variables, Sinatra proporciona el bloque configure do, que permite realizar el código incluido en este bloque una única vez, es decir, solo al arrancar la aplicación. Este bloque es el siguiente:

```ruby
configure do
    dator = MyDator.new()
    @@manejador = ManejaLiga.new(dator)
    @@jsonify = Jsonify.new()
end
```

## Modos de ejecución

He considerado adecuado establecer ya los dos modos de ejecución disponibles para mi aplicación, pues tal y como se explicará en el archivo de logs, se va a hacer una cosa u otra en función del modo.

Para ello, en Sinatra podemos establecer el modo con lo siguiente:

```ruby
set :environment, configuracion()["APP_ENV"]
```

Como vemos, se hace uso de la función configuración. Está será explicada en la documentación sobre configuración distribuida.

Una vez hemos establecido el modo, Sinatra permite realizar una cosa u otra en función del modo con el bloque configure do, pero aplicándolo ahora de esta forma:

```ruby
configure :production do
    myLogger = MyLogger.new('output.log')
    @@logger = myLogger._logger
    set :logger, @@logger
end

configure :development do
    myLogger = MyLogger.new()
    @@logger = myLogger._logger
    set :logger, @@logger
end
```

Como vemos, lo que se hace es crear el objeto de la clase myLogger que se explicará en el documento sobre los logs. Esta creación se hace de forma distinta, pues en producción queremos que los logs se saquen a un archivo, mientras que en desarollo queremos que se saquen por consola. Por último, indicamos a sinatra cual va a ser nuestro logger. De nuevo, todo lo referente a los logs será explicado en el archivo sobre logs y configuración distribuida.

## Diseño de las rutas

En primer lugar, me tomé un tiempo para pensar el diseño de las rutas de mi programa. Esto es importante, pues tienen que ser rutas identificativas que sea intuitivas para el usuario. Mi aplicación tiene actualmente 15 HUs enfocadas al usuario, y por como están pensadas dichas HUs se van a corresponder cada una con una ruta.

Para el diseño de las rutas, he intentado seguir algunas buenas prácticas que he encontrado en páginas como [esta](https://stackoverflow.blog/2020/03/02/best-practices-for-rest-api-design/), como por ejemplo el uso de sustantivos en lugar de verbos.

Como he dicho antes, en mi caso cada HU coincide con una ruta, teniendo las siguientes:

```ruby
# HU1: Como usuario, quiero poder consultar el resultado de un partido
get '/partido/resultado/:equipo/:jornada'
# HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
get '/partido/goleadores/:equipo/:jornada'
# HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
get '/partido/dias/:equipo/:jornada'
# HU4: Como usuario, debo poder consultar el máximo goleador de un partido
get '/partido/maximo-goleador/:equipo/:jornada'
# HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
get '/jornada/partidos/:jornada'
# HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
get '/jornada/dias/:jornada'
# HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
get '/jornada/maximo-goleador/:jornada'
# HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
get '/jornada/equipo/maximo-goleador/:jornada'
# HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
get '/equipos'
# HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
get '/ranking/goleadores'
# HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
get '/ranking/clasificacion'
# HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
get '/equipo/goles/:equipo'
# HU14: Como usuario, quiero poder añadir un equipo a una ligaanejadoranejador
post '/add/equipo'
# HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
post '/add/partido'
# HU16: Como usuario, quiero poder añadir una jornada a una liga 
post '/add/jornada'
```

En cada ruta de las anteriores, las variables se marcan con :NOMBRE_VARIABLE. Además, se ha intentado mantener una especie de jerarquía, para que las rutas estén relacionadas y no sean 15 nombres de rutas independientes. Por ejemplo, podemos observar que los métodos post empiezan por /add/ y siguen con el nombre de la entidad que quieren añadir a la liga. Posteriormente, en los métodos de consultas, empezamos con el nombre de la entidad de la que queremos consultar algo, siguiendo con lo que queremos consultar y terminando con la variable o variables que identifican al objeto buscado.

En cuanto al tipo de método HTTP usado, en el caso de las rutas de consultas está bastante claro, pues se corresponden con el método get. En cuanto a las tres últimas HUs, podríamos usar post o put en función de lo que busquemos. En mi caso, he elegido post ya que solo quiero que el objeto se cree cuando no exista. En el caso que exista, devuelvo el error correspondiente.

## Tipos devueltos y estados

En mi caso, he visto adecuado la devolución de un JSON, pues me parece que funciona muy bien para representar las entidades en las que se basa mi aplicación. Para ello, he creado una función a la cual llaman todas las rutas para la devolución de las peticiones. La función es la siguiente:

```ruby
def json(data_object)
    content_type :json
    data_object.to_json
end
```

Con ella definimos el tipo del objeto que devolvemos y el objeto en sí.

Un ejemplo de su uso podría darse en la ruta referente a la HU1, aprovechando también para ver la estructura seguida en Sinatra para la creación de una ruta:

```ruby
# HU1: Como usuario, quiero poder consultar el resultado de un partido
get '/partido/resultado/:equipo/:jornada' do
    numJornada = params['jornada'].to_i
    nombreEquipo = params['equipo']

    begin
        resultado = @@manejador.resultadoPartido(numJornada, nombreEquipo)

        status 200
        json(
            {
                :Local => resultado.equipoLocal, 
                :Visitante => resultado.equipoVisitante, 
                :resultado => {
                    :golesLocal => resultado.golesLocal,
                    :golesVisitante => resultado.golesVisitante
                }
            }
        )
    rescue => $error
        status 404
        json({:status => $error.message})
    end
end
```

Como vemos, si tras la llamada al método correspondiente del manejador no obtenemos una excepción, devolvemos el código 200 (OK) y respondemos con el objeto json del partido. En el caso de que surja algún error, devolvemos un json con el mensaje de por qué se ha producido dicho error y el código 404 (not found). Además, vemos que el error se almacena en la variable $error que posteriormente será usada por el logger.

**La estructura que he explicado para la HU1 se mantiene para el resto de HUs.** Es decir, en todas ellas devuelvo el objeto correspondiente en caso de ningún error y devuelvo el mensaje del error en caso de que salte alguna excepción. Por tanto, el código se ha desarrollado teniendo en cuenta esto, es decir, tras llamar al método correspondiente del manejador, se harán todas las comprobaciones en los sucesivos métodos que se llamen internamente, y si no obtenemos ninguna excepción significa que la operación se ha realizado correctamente.

Por último, podemos devolver el error 404 (not found), en el caso de que se introduzca una ruta que no coincida con ninguna de las anteriores. Para poder introducir un mensaje, podemos hacerlo en sinatra de la siguiente forma:

```ruby
error 404 do
    @@logger.info("La ruta introducida no ha sido encontrada")
    json({:status => 'Error: la ruta introducida no ha sido encontrada'})
end
```

Como vemos, además de devolver un json con el mensaje de error, sacamos este mensaje también con el logger. La documentación sobre el logger está en el archivo de documentación de configuración distribuida, logs y middleware, pudiendo consultarse [aquí](./conf_logs).

## Diseño por capas

- **Capa de persistencia**. En este momento de desarrollo del proyecto, no he implementado una persistencia ante reinicios, ya que no almaceno los nuevos datos en un archivo concreto o una base de datos. Sin embargo, en este momento estoy leyendo unos datos desde un archivo json de ejemplo para crear la liga, por lo que es necesaria la separación de esta capa.

  En este caso, he creado una clase [Dator](../../src/dator.rb), la cual no es instanciable y contiene los métodos que se corresponden con cada una de las HUs pero sin implementar.

  Además, para poder leer los datos de un archivo JSON, he creado la clase [MyDator](../../src/myDator.rb). Esta clase hace uso de una clase auxiliar que he creado, [Jsonify](../../src/jsonify.rb), la cual me permite pasar de las instancias liga, jornada, partido o equipo en formato JSON, a instancias de mis propias clases. Esta clase también será usada por la capa de la aplicación para pasar a instancias de mis clases los objetos recibidos por post en las 3 últimas rutas.

  Esta capa se ha diseñado siguiente los principios de inyección de dependencias y "single source of truth". Esto será explicado en la siguiente capa, cuando explique la clase manejadora.

- **Capa de la lógica**. En esta están todas las entidades que he ido creando a lo largo del proyecto, aunque he tenido que hacer reestructuraciones en algunas clases al pensar en su unión con el resto de capas. Por ejemplo, en la clase Partido, ahora el resultado es una variable más de la clase y no se calcula a partir del array de goleadores. Este cambio concreto lo he hecho porque no tiene mucho sentido añadir un partido a una jornada sin indicar su resultado, además de que en ligas comarcales por ejemplo puede que no se almacenen los goleadores y si únicamente los resultados. Las entidades que se recogen, ordenadas de forma jerárquica, son:

  `jugador < equipo < partido < jornada < liga`

  Cada una de las entidades usa a su vez las entidades que se encuentran a su izquierda, es decir, si por ejemplo se solicita a la clase Liga el resultado de un determinado partido, esta clase hará una llamada a la clase jornada, que a su vez hará una llamada a la clase partido, devolviendo el resultado de dicho partido.

  Además, en esta capa encontramos la clase que nos permite la conexión con la capa de persistencia, la clase manejadora. En mi caso, esta es la clase [ManejaLiga](../../src/manejaLiga.rb) y se ha diseñado siguiente los dos principios explicados en la capa de persistencia:

  - Inyección de dependencias: Esto se ha hecho, ya que cuando creamos un objeto de la clase manejadora, en el constructor se requiere pasarle (inyectarle) el objeto de la clase Dator que accede a nuestros datos.
  - Single source of truth: Esto también se hace, pues el objeto de la clase Dator que hemos recibido como parámetro en el constructor de la clase manejadora es el único que accede a los datos.

  La clase ManejaLiga nos permite separar las funciones propias del API de las funciones propias de la lógica de negocio, pues está contendrá todos los métodos necesarios para cubrir todas las HUs y permiten que en el API solo se requiera hacer una llamada al objeto de esta clase para realizar la operación solicitada por el usuario.

- **Capa de aplicación**. Esta capa se recoge en la clase [MyApp](../../src/app.rb) y se encarga de recibir las peticiones a través de las diferentes rutas, hacer la llamada al método correspondiente de la clase manejadora, construir el objeto devuelto junto con el código http a devolver y devolver todo.

  En esta capa también estaría recogida la clase [MyLogger](../../src/myLogger.rb) que será explicada en el archivo sobre logs y configuración distribuida.

## Test del código creado y test de integración

En primer lugar, tal y como hemos venido haciendo a lo largo del proyecto, hemos realizado los test del código que íbamos creando. En este caso, hemos hecho los test de las clases [Dator](../../spec/dator_spec.rb), [MyDator](../../spec/myDator_spec.rb), [ManejaLiga](../../spec/manejaLiga_spec.rb) y [Jsonify](../../spec/jsonifdatory_spec.rb)

Además, es necesario realizar los tests de integración. Para ello, dado que en mi proyecto se ha usado rspec para los tests, he buscado una gema que me permita hacerlos con rspec. Esta gema es **rack-test** y podemos conseguir realizar los test de forma muy similar a como ya los veníamos haciendo. Los test de integración se pueden consultar en el siguiente [enlace](../../specdator/app_spec.rb).

Simplemente dentro de nuestro `describe do` general tenemos que incluir lo siguiente:

```ruby
include Rack::Test::Methods

def app
    MyApp
end
```

Con esto, incluímos los métodos de la biblioteca de test e indicamos la instancia de la clase en la que se basa nuestro API.

Posteriormente, creamos un nuevo bloque `describe do` para cada una de las rutas, incluyendo los diferentes bloques `it do` en función de los tests realizados.

Voy a mostrar el test para alguna ruta de forma que sea identificativo y el resto se han hecho de forma similar. Por ejemplo, podemos ver un caso de uso de método get:

```ruby
# HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
describe "partidos de una jornada" do 
    it 'jornada correcta' do
        get '/jornada/partidos/1'

        cuerpo = ({"Partido 1":{"local":"Real Madrid","visitante":"Sevilla FC","resultado":{"golesLocal":1,"golesVisitante":0}},"Partido 2":{"local":"FC Barcelona","visitante":"Atlético Madrid","resultado":{"golesLocal":1,"golesVisitante":2}}}).to_json

        expect(last_response.body).to eq (cuerpo)
        expect(last_response.content_type).to eq ('application/json')
        expect(last_response.ok?).to eq (true)
    end

    it 'jornada incorrecta' do
        get '/jornada/partidos/-1'

        cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

        expect(last_response.body).to eq (cuerpo)
        expect(last_response.content_type).to eq ('application/json')
        expect(last_response.ok?).to eq (false)
    end
end
```

En el caso anterior, vemos que primero se realiza la petición get. Posteriormente, establecemos el cuerpo de la respuesta que debemos tener. Por último, hacemos las comprobaciones, es decir, vemos que el cuerpo coincida, que el tipo devuelto sea un json y que hayamos obtenido un código de error en el caso de la jornada -1, ya que es incorrecta y un código de OK en el caso de la jornada 1, pues es correcta.

También podemos ver un ejemplo de método post:

```ruby
# HU14: Como usuario, quiero poder añadir un equipo a una liga
    describe "añadir equipo a la liga" do 
        it 'equipo correcto' do
            equipo = {
                "name"=>"Valencia CF", 
                "code"=>"VAL", 
                "country"=>"Spain", 
                "players"=>[
                    "Gaya", 
                    "Maxi Gomez"
                ]
            }

            post '/add/equipo', equipo.to_json

            cuerpo = ({"status":"Equipo añadido correctamente"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'equipo ya existente' do
            equipo = {
                "name"=>"Real Madrid", 
                "code"=>"VAL", 
                "country"=>"Spain", 
                "players"=>[
                    "Gaya", 
                    "Maxi Gomez"
                ]
            }

            post '/add/equipo', equipo.to_json

            cuerpo = ({"status":"El equipo ya existe en la liga"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end
```

En una liga no se permite que haya más de un equipo con el mismo nombre. En el código anterior, vemos que hacemos lo mismo que ya expliqué para el método get, con la excepción de que ahora tenemos que construir el objeto que le pasamos con el post. Si se trata de un equipo que no existe en la liga, como el Valencia, vemos que no tiene que dar error, y en el caso de un equipo que ya existe en la liga, como el Real Madrid, vemos que da un error de que el equipo ya existe en la liga.

## Ejecución de la app

Por último, aunque no era necesario en este momento, se ha creado una tarea en nuestro [Rakefile](../../Rakefile), `rake start` que nos permite arrancar la aplicación. Esta tarea hace uso de rackup, que es una herramienta que ejecuta lo que haya en el archivo [config.ru](../../config.ru).