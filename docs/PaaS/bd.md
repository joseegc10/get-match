# Implementación de persistencia

Anteriormente, tal y como se explicó en el [documento sobre el diseño del API](../microservicio/api.md), nuestra capa de persistencia estaba formada por la clase myDator, con la que conseguíamos persistencia entre peticiones pero no ante reinicios, pues se usaba una implementación en memoria.

Por tanto, se ha decidido implementar un dator para la persistencia ante reinicios. La estructura del API no ha cambiado, ya que anteriormente se diseñó con visión a futuro de añadir un nuevo dator. Como cumplimos los dos principios básicos de inyección de dependencias y SSOT, simplemente debemos implementar una nueva clase dator que herede de nuestra clase inicial Dator y la cual implemente los métodos de dicha clase proporcionando una persistencia ante reinicios mediante el uso de una base de datos.

Entonces, una vez creamos la nueva clase dator, cambiamos en nuestra clase App la linea en la que creábamos una instancia de la clase manejadora ManejaLiga, pasándole ahora como parámetro del constructor una instancia de la nueva clase dator implementada.

## Base de datos utilizada

En primer lugar, pensé que tipo de base de datos es la que iba a ir mejor a mi API. Por la estructura de mis clases, se podría pensar en una base de datos relacional y se estuvo investigando sobre el uso de postgrees como addon de heroku. Sin embargo, pienso que es excesivo el trabajo que me hubiera llevado la creación de todos los modelos, pudiendo hacer uso de una base de datos NoSQL de tipo documento que me permita no repetir demasiada memoria. 

Por ejemplo, para un partido, vamos a tener que almacenar los dos equipos que participan, pero dichos equipos ya estarían en la lista de equipos de la liga. Por ello, se podría pensar que con una base de datos NoSQL se iba a repetir demasiada memoria. Sin embargo, si en lugar de almacenar en los equipos en sí dentro del partido, almacenamos las claves de dichos equipos, me permitiría saber quiénes son los equipos de dicho partido solamente teniendo que repetir la clave de los equipos, en este caso los nombres.

Una vez he tomado la decisión de usar una base de datos NoSQL, tenemos que elegir cual usamos. Se podría pensar en usar MongoDB, pues es comúnmente usada e iba a encontrar mucho soporte para mi lenguaje. Sin embargo, finalmente he decidido usar realtime database de firebase, una base de datos también alojada en la nube. Como ya probé aws de Amazon con serverless, he querido aprender también un sistema de Google. 

Además, del motivo anterior, los motivos principales por los que he elegido firebase han sido que usa el formato JSON (al igual que MongoDB) y sobre todo su sistema de rutas. Este sistema consiste en que los documentos de la base de datos están identificados por una ruta. Esto es muy adecuado para mi API, puesto que por ejemplo, podríamos obtener cada una de las jornadas de la liga mediante la ruta /jornadas/NUM-JORNADA. Esto se puede extender al resto de objetos de mi API, puesto que está diseñada con objetos organizados jerárquicamente, ordenados de la siguiente forma:

`jugador < equipo < partido < jornada < liga`

Cada una de las entidades usa a su vez las entidades que se encuentran a su izquierda.

## Estructura de la base de datos e implementación de cache en memoria

Por todo lo anterior, pienso que realtime database de Firebase es la base de datos adecuada para mi API. En este momento de desarrollo, la base de datos va a coincidir con una liga. Por ello, en ella va a existir la ruta `/equipos` y la ruta `/jornadas`. En cuanto a la clasificación y al ranking de goleadores de la liga, sus otros dos atributos, he decidido no almacenarlas como tal, pues si las almacenamos ya si que estaríamos repitiendo mucha memoria (pues repetimos equipos y jugadores), además de que es algo que se calcula a partir del resto de datos. Como alternativa, he decidido implementar una cache en memoria, a partir de la cual cuando el usuario solicita la clasificación o el ranking de goleadores, se mira el tiempo que ha pasado desde la última actualización de dichos atributos. En mi caso, he establecido que si ha pasado más de 5 minutos desde su último cálculo, vuelva a calcularlas haciendo las peticiones necesarias a la base de datos y almacenándolas como instancias de clase en memoria. Esto nos provoca que la clasificación no siempre esté en su última versión (máximo está 5 minutos atrasada), pero a cambio nos aporta una respuesta más rápida al usuario y un menor uso de memoria en la base de datos. El método que actualiza la caché ha quedado de la siguiente forma:

```ruby
def actualizaCache()
    timeActual = DateTime.now
    diferencia = (timeActual - @timeCache)

    if (diferencia*24*60).to_i >= 5
        ligaJSON = @database.get('').body
        if ligaJSON
            keys = ligaJSON.keys
            if keys.include?('jornadas')
                liga = @jsonify.jsonToLiga(ligaJSON)
                @clasificacion = liga.clasificacion
                @rankingGoleadores = liga.rankingGoleadores
                @timeCache = DateTime.now
            end
        end
    end
end
```

En un futuro, se podría añadir una capa más a la lógica de mi aplicación que nos permita tener un conjunto de ligas, de tal forma que en la base de datos en lugar de tener directamente los equipos y las jornadas, se tenga el nombre de la liga y en un subnivel posterior los equipos y las jornadas, de tal forma que para obtener los equipos de una liga la ruta en la base de datos sea `/NOMBRE-LIGA/equipos`, viendo de nuevo la gran utilidad para mi API del sistema de rutas de la base de datos utilizada.

## Implementación de la base de datos de firebase en ruby

Para hacer uso de la base de datos de realtime database de firebase, se ha hecho uso de la gema firebase de ruby. Esta se instala con el comando `gem install firebase` y a continuación se pueden ver ejemplos de su uso:

```ruby
# Nos conectamos a la base de datos
@database = Firebase::Client.new(URI_DATABASE, SECRET_DATABASE)
# Obtenemos el documento de la ruta /equipos
equiposJSON = @database.get('equipos').body
# Añadimos a la ruta /equipos un nuevo documento
@database.push('equipos', equipoJSON)
# Eliminamos toda la base de datos
@database.delete('') 
```

Además, si queremos hacer consultas en función de algún parámetro, tenemos que usar lo que firebase llama **reglas**. Estas, nos permite establecer ciertos atributos a las rutas en las que se basa la base de datos. Por ejemplo, si queremos permitir que en la ruta /equipos se pueda hacer una búsqueda por nombre, tenemos que añadir la siguiente regla:

```json
"equipos": {
    ".read": true,
    ".write": "auth.uid != null",
    ".indexOn": ["name"]
},
```

En ella indicamos que la ruta equipos puede ser leída, puede ser modificada con un usuario identificado y se puede hacer una búsqueda en función del atributo "name", por lo que firebase indexa internamente las entidades equipos en este caso en función de su nombre. Sin esto, realtime database no permite hacer una búsqueda de un equipo por su nombre.

Una vez hemos establecido lo anterior, podemos hacer una peticion a la base de datos de la siguiente forma:

```ruby
query = {
    :orderBy => '"name"',
    :equalTo => '"' + nombre + '"'
}

equipoJSON = @database.get('equipos', query).body
```

Es decir, buscamos en la ruta /equipos un equipo particular por su nombre. Las comillas " son necesarias, aunque pueda parecer que no.

Mediante el uso de los métodos anteriores, se han ido creando todos los métodos de la clase Dator, obteneniendo una nueva clase, [FirebaseDator](../../src/firebaseDator.rb).

## Reflexiones finales

Como reflexionar final, he de decir que me ha gustado finalmente usar realtime database como mi base de datos, pues creo que su estructura va muy bien con mi API. Sin embargo, he encontrado dificultades en obtener los recursos que me permita saber como se hace todo en ruby, además de que realtime database no permite por ejemplo peticiones complejas, aunque por la simpleza de mi API no existe demasiado problema, pudiéndo migrar **a Cloud Firestore** de firebase en caso de que necesitara una mayor complejidad.