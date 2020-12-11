# Uso de buenas prácticas

## Configuración distribuida

### Variables creadas

He visto adecuado establecer una serie de variables de las que va a depender mi aplicación. Estas son las siguientes:

- PORT: nos indica el puerto por el que se va a iniciar mi aplicación mediante rackup.
- APP_ENV: nos indica el modo en el que se ejecuta la aplicación, es decir, si se ejecuta en desarrollo o en producción.
- NUM_MAX_EQUIPOS: es importante indicar en mi aplicación el número de equipos que van a formar la liga, pues puede existir mucha variedad en este número y no veo adecuado establecer un número a priori.

### Archivo para obtener las variables

He creado un archivo [config.rb](../../config/config.rb) dentro de la carpeta config, el cual se encarga de obtener las variables de las que depende mi aplicación. Por tanto, cuando queremos hacer uso de estas variables desde cualquier archivo, simplemente importamos el archivo config.rb y solicitamos que nos las de.

Para establecer estas variables, hacemos lo siguiente:

```ruby
VARIABLES = ["PORT", "NUM_MAX_EQUIPOS", "APP_ENV"]

def existenVariables(vars)
    for variable in VARIABLES
        if !vars[variable]
            return false
        end
    end

    return true
end

def configuracion
    vars_etcd = configuracion_etcd()
    
    if !existenVariables(vars_etcd)
        vars_os = configuracion_os()
        vars_figaro = configuracion_figaro()
        
        if !existenVariables(vars_figaro)
            if !existenVariables(vars_os)
                vars = Hash.new
                vars["PORT"] = PORT_DEFECTO
                vars["NUM_MAX_EQUIPOS"] = NUM_MAX_EQUIPOS_DEFECTO
                vars["APP_ENV"] = APP_ENV_DEFECTO
                
                return vars
            else
                return vars_os
            end
        else
            return vars_figaro
        end
    else
        return vars_ectd
    end
end
```

Básicamente, podemos obtener las variables de cuatro formas distintas, utilizando la función existenVariables para comprobar si un método ha devuelto todas las variables requeridas:

1. En primer lugar, intenta obtener las variables mediante etcd.

```ruby
def configuracion_etcd
    vars = Hash.new

    if ENV["HOSTNAME_ETCD"] and ENV["PORT_ETCD"]
        endpoint = "https://" + ENV["HOSTNAME_ETCD"] + ":" + ENV["PORT_ETCD"]
        etcd = Etcdv3.new(endpoints: endpoint)

        vars["PORT"] = etcd.get('PORT')
        vars["NUM_MAX_EQUIPOS"] = etcd.get('NUM_MAX_EQUIPOS')
        vars["APP_ENV"] = etcd.get('APP_ENV')
    end

    return vars
end
```

En el caso de que existan las variables de entorno del host y del puerto de etcd al que conectarnos, nos conectamos y solicitamos las variables.

2. Si no hemos obtenido todas las variables con etcd, intentamos obtenerlas mediante fígaro.

```ruby
def configuracion_figaro
    Figaro.application = Figaro::Application.new(
        path: File.expand_path("config/application.yml")
    )
    Figaro.load

    vars = Hash.new
    vars["PORT"] = (Figaro.env.PORT).to_i
    vars["NUM_MAX_EQUIPOS"] = (Figaro.env.NUM_MAX_EQUIPOS).to_i
    vars["APP_ENV"] = Figaro.env.APP_ENV

    return vars
end
```

Fígaro es una gema que he descubierto que nos permite obtener el valor de las variables de forma muy sencilla. Simplemente indicamos el archivo donde se van a encontrar las variables (archivo yml -- clave/valor) y cargamos en Fígaro las variables que se encuentren en dicho archivo.

Posteriormente, obtenemos las variables con `Figaro.env.NOMBRE_VARIABLE`

3. En el caso de que con fígaro no obtengamos todas las variables, intentamos obtenerlas a partir de las variables de entorno.

```ruby
def configuracion_os
    vars = Hash.new
    vars["PORT"] = ENV["PORT"]
    vars["NUM_MAX_EQUIPOS"] = ENV["NUM_MAX_EQUIPOS"]
    vars["APP_ENV"] = ENV["APP_ENV"]

    return vars
end
```

4. Por último, en el caso de que tampoco las podamos obtener de la forma anterior, las obtenemos mediante los valores por defecto que hay en el archivo config.ru.

```ruby
PORT_DEFECTO = 8080 # Puerto por defecto que proporciona rackup
NUM_MAX_EQUIPOS_DEFECTO = 10
APP_ENV_DEFECTO = 'development' # Modo por defecto de sinatra
```

### Donde uso las variables

Estas variables se van a usar en 3 puntos de mi aplicación:

1. El archivo [config.ru](../../config.ru) es el archivo donde rackup mira los pasos a seguir para arrancar la aplicación. En este archivo usamos la variable PORT, pues con rack solo nos deja indicar el puerto en este archivo:

```ruby
vars = configuracion()
Rack::Handler.default.run(MyApp, :Port => vars["PORT"])
```

2. En mi archivo de aplicación [app.rb](../../src/app.rb). En sinatra, podemos establecer el modo de ejecución (variable APP_ENV) de la aplicación desde la clase Sinatra. Para ello, hacemos uso de lo siguiente:

```ruby
set :environment, configuracion()["APP_ENV"]
```

3. Por último, la variable NUM_MAX_EQUIPOS se va a usar desde la clase [MyDator](../../src/myDator.rb), que es el dator que he creado en este momento de desarrollo de la aplicación. Esta va a ser usada cuando añadimos un nuevo equipo a la liga y cuando creamos la liga, pues tenemos que ver que el número de equipos que tenemos no supere el número almacenado es dicha variable.

```ruby
NUM_MAX_EQUIPOS = configuracion()["NUM_MAX_EQUIPOS"]
```

## Logs y middleware

En mi caso he decidido "crear" un middleware para la gestión de los logs. Realmente, he pensado que no era adecuado crear un middleware como tal propio, pues pienso que el que viene por defecto en sinatra proporciona la información necesaria, más que si lo construyera por mi cuenta. Por ello, lo que he hecho es crear una clase Logger, [MyLogger](../../src/myLogger.rb), que hace uso del middleware por defecto de sinatra pero con modificaciones. Esta clase es la siguiente:

```ruby
class MyLogger
    def initialize(file=nil)
        if file
            Dir.mkdir('logs') unless File.exist?('logs')

            log_file = File.new('logs/'+file, 'a')

            @_logger = Logger.new(log_file,'weekly')
            @_logger.level = Logger::INFO
            @_logger.datetime_format = '%a %d-%m-%Y %H%M '

            $stdout = log_file
            $stdout.sync = true
            $stderr = log_file
        else
            @_logger = Logger.new(STDOUT)
            @_logger.level = Logger::INFO
            @_logger.datetime_format = '%a %d-%m-%Y %H%M '
        end
    end
    
    attr_reader :_logger
end
```

Como vemos, lo que hace depende de si recibimos un nombre de un archivo en el constructor o no. Como ya explicamos en el documento sobre la API, dispongo de dos modos de ejecución de la aplicación. En el caso del modo de desarrollo, usamos la salida estándar (la consola). Sin embargo, en el caso del modo de producción, vamos a crear una instancia de MyLogger pasando un archivo. En este archivo se van a almacenar los logs producimos mediante el uso de la aplicación, pues no tendría sentido sacarlo en la consola cuando el usuario no dispone de ella.

Un middleware se ejecuta antes o después de la activación de una ruta. En mi caso, estoy utilizando el proporcionado por la clase estándar Logger. Sin embargo, esta clase proporciona una serie de métodos mediante el cual podemos hacer pequeñas modificaciones en este middleware de forma muy sencilla. En mi caso he hecho dos, pudiendo hacer más conforme se vaya desarrollando más la aplicación. Estas dos son:

```ruby
@_logger.level = Logger::INFO
@_logger.datetime_format = '%a %d-%m-%Y %H%M '
```

Primero indicamos el nivel de información que va a sacar este logger, pudiendo ser de info como en mi caso, o de error, debug, etc. Además, en mi caso he decidido cambiar un poco el formato de la fecha que saca, pues me parece más intuitiva de esta forma.

La instancia de MyLogger se va a crear en la clase Sinatra en función del modo en el que nos encontremos, como ya explicamos en el documento de la api.

**Otro uso del logger:**

Hasta ahora, lo que hemos hecho es crear un Logger como middleware, usando el Logger por defecto con pequeñas modificaciones y redirigiendo la salida de este logger en función del modo en el que nos encontremos. Sin embargo, este logger lo uso también para sacar la información proporcionada por las excepciones producidas en las activaciones de las rutas. Esto se consigue mediante lo siguiente:

```ruby
after do
    if $error
        @@logger.info($error.message)
        $error = nil
    end
end
```

El bloque after do me permite ejecutar algo después de la activación de una ruta. En este caso, como ya explicamos en el documento de la api, cuando activamos una ruta y se produce un error, se crea la variable $error que almacena el error producido en la excepción. Por ello, en el caso de que se produzca una excepción, después de la activación de este ruta le decimos al logger que muestre la información que explica por qué se ha producido dicha excepción.