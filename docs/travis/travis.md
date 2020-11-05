# Travis-CI

La integración continua es un método de desarrollo de software que permite que los miembros de un equipo puedan integrar su trabajo, de tal forma que cada miembro solo incluya su trabajo a la rama principal cuando ha pasado los tests y se encuentra por tanto libre de errores.

**Travi-CI es un sistema de integración continua "gratuito" para proyectos Open Source y va a ser uno de los que use en este proyecto. Su página oficial se puede encontrar [aquí](https://travis-ci.com/). Lo de que sea gratuito ya no es del todo cierto, pues desde que se pasó al dominio .com, se establecen limitaciones, que en nuestro caso por ser estudiantes quedan eliminadas.**

## Ventajas de Travis-CI

- Es muy sencillo de enlazar con GitHub.
- Genera resultados rápidamente, pudiendo incluso ejecutar pruebas en paralelo. Por ejemplo, la prueba de diferentes versiones del lenguaje de ruby se pueden hacer en paralelo.
- Se pueden consultar las pruebas incluso cuando se están ejecutando.
- Fácil de empezar, pues solo hay que crear un archivo de configuración en el repositorio.
- Soporte para muchos lenguajes.

## Uso

Como se ha dicho en las ventajas, es muy fácil empezar con Travis-CI. Simplemente debemos crear un fichero, llamado **.travis.yml**, que esté en la carpeta principal de nuestro proyecto. El fichero que he creado para este proyecto se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/.travis.yml). En él, hacemos lo siguiente:

1. Establacemos el lenguaje del código.

`languaje: ruby`

2. Establecemos las versiones de ruby donde se van a ejecutar los test. En el caso de ruby, en Travis viene por defecto usar rvm como gestor de versiones.

```
rvm:
    - 2.7.2
    - 2.7.1
    - 2.7.0
    - 2.6.0
    - 2.5.0
    - 2.4.0
    - 2.3.0
```

La elección de las versiones no se ha hecho de forma aleatoria. Como veremos más adelante, voy a usar la versión 2.1.4 de bundler. Esto hace que solo sean compatibles con él las versiones de ruby posteriores o iguales a la 2.3.0.

Para demostrar lo anterior muestro en primer lugar la correcta ejecución de los tests con las versiones anteriores:

![ok_test](https://github.com/joseegc10/get-match/blob/master/docs/img/travis/ok_version.png)

Ahora, mostramos una prueba de ejecución de una versión anterior a la 2.3.0, la 2.2.9:

![bad_test](https://github.com/joseegc10/get-match/blob/master/docs/img/travis/bad_version.png)

Como se puede apreciar, hemos obtenido un error. Si nos adentramos en dicho error, podemos ver lo siguiente:

![error_test](https://github.com/joseegc10/get-match/blob/master/docs/img/travis/error_version.png)

Lo anterior confirma lo que habíamos establecido al principio, pues trabajar con versiones de ruby anteriores a la 2.3.0 es incompatible con usar la versión 2 o mayor de bundler.

3. Instalamos la última versión de bundler, la 2.1.4. Esto entra dentro de lo que travis llama antes de instalar (before_install).

```
before_install:
    - gem install bundler
```

4. Instalamos las dependencias. Esto entra dentro de lo que Travis llama install, como es evidente. Comentar que Travis usa por defecto bundler para ruby.

`install: bundle install`

5. Establecemos la ejecución de los tests. Esto entra dentro del apartado script, para el cual Travis trae por defecto rake como gestor de tareas para ruby.

`script: rake test`

## Otras posibilidades

Comentar también que Travis da la posibilidad de hacer más cosas. Algunas utilidades extra podrían ser las siguiente:

1. Podríamos cachear las dependencias con el siguiente comando:

`cache: bundler`

Sin embargo, debido a las pocas dependencias que hay en la actualidad en el proyecto, no lo veo necesario, aunque en un futuro podría incluirlo en caso de que estas dependencias comenzaran a crecer.

2. Podríamos probar diferentes versiones de dependencias. Por ejemplo, haciendo uso de diferentes ficheros gemfile, que deberían estar almacenados en un directorio llamado ./gemfiles. Un posible ejemplo sería el siguiente:

```
gemfile:
  - gemfiles/primero.gemfile
  - gemfiles/segundo.gemfile
  - gemfiles/tercero.gemfile
```

3. Otra forma de acelerar la instalación, además del uso de cache, podría ser excluyendo dependencias no esenciales en la instalación. Esto es útil ya que en ocasiones tenemos bibliotecas por defecto que no se van a usar. Para excluirlas, deberíamos poner lo siguiente:

```
group :production do
  gem 'ruby-debug'
  gem 'unicorn'
end

bundler_args: --without production
```

De esa forma, se excluirían los paquetes ruby-debug y unicorn.

4. Por último, podríamos hacer uso de docker para la ejecución de los tests. Para ello el archivo .travis.yml contendría solamente lo siguiente:

```
script:
  - docker run -t -v `pwd`:/test joseegc10/get-match
```

Como vemos, en el apartado de script en lugar de usar rake test deberíamos usar la orden que he puesto arriba, que también haría rake test pero lo obtiene desde el Dockerfile.

A parte de esto, existen otras posibilidades en la construcción del fichero .travis.yml, que se pueden consultar en el [manual oficial de Travis para Ruby](https://docs.travis-ci.com/user/languages/ruby/).

**Como conclusión final, he elegido Travis para realizar lo explicado arriba debido a que quería utilizar un sistema que me permitiera probar los tests en diferentes versiones de ruby. Travis, gracias a que permite la ejecución en paralelo, la veo ideal para este cometido.**