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
    # Pruebo la última versión de ruby
    - ruby-head
    # Pruebo jruby en su última versión
    - jruby-head
    # Pruebo la última versión compatible
    - 2.3
    # Pruebo una versión intermedia
    - 2.6
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

A parte de esto, existen otras posibilidades en la construcción del fichero .travis.yml, que se pueden consultar en el [manual oficial de Travis para Ruby](https://docs.travis-ci.com/user/languages/ruby/).

## Pruebas realizadas en Travis

### Versiones de ruby utilizadas

En este subapartado se recogerán la versiones de ruby utilizadas y una justificación de las mismas. Como se puede apreciar arriba, se han elegido 4 versiones diferentes de ruby:
- En primer lugar, he considerado que es fundamental probar la última versión de ruby, pues esto nos va a permitir saber si nuestro código "está al día" con ruby, siendo compatible con su última versión.
- En segundo lugar, he descubierto la existencia de JRuby, que es una implementación 100% Java del lenguaje Ruby. Debido a su fama (gracias a ser compatible con bibliotecas Java), he considerado adecuado ver si mi código funcionaba para esta versión también.
- En tercer lugar, tal y como se ha explicado arriba, para que mi código sea compatible con bundler, es necesario instalarlo en su última versión actual, pues la que viene por defecto en Travis provoca incompatibilidad. Por ello, es necesario saber cual es la última versión de ruby compatible con esta versión de bundler. Como podemos apreciar arriba, la última versión es la 2.3, por lo que considero importante mantener en Travis la última versión para la que mi código funciona.
- Por último, en cuarto lugar, he decidido añadir una versión intermedia entre la última que funciona y la más reciente, para ver que efectivamente si funciona en las versiones intermedias, pues podría ocurrir que funcionara en la 2.3 y en la última pero no en las intermedias.

### Diferentes sistemas operativos

Además de probar en diferentes versiones, considero bueno probar en que sistemas operativos funciona mi código. Para ello, hay que añadir lo siguiente al archivo .travis.yml:

```
os:
  - windows
  - linux
  - osx
```

En linux ya sabíamos que iba a funcionar, pues es el SO que viene por defecto y ya lo habíamos probado. En cuanto a windows y osx, no sabíamos el resultado que iba a tener.

El resultado de la prueba que he realizado se puede ver en el siguiente [enlace](https://travis-ci.com/github/joseegc10/get-match/builds/199372910).

Resultado para windows:

![windows](https://github.com/joseegc10/get-match/blob/master/docs/img/travis/windows.png)

Como se puede apreciar, para windows no funciona mi código. Si nos adentramos en el error, vemos que no funciona debido a que ruby no es soportado actualmente por windows.

Resultado para osx:

![osx](https://github.com/joseegc10/get-match/blob/master/docs/img/travis/osx.png)

En cuanto a osx, vemos que si funciona para 3 de las 4 versiones que hemos probado. En el caso de la versión 2.3 falla debido a la incompatibilidad de esta versión con un paquete en osx.

**Como conclusión final, he elegido Travis para realizar lo explicado arriba debido a que quería utilizar un sistema que me permitiera probar los tests en diferentes versiones de ruby. Travis, gracias a que permite la ejecución en paralelo, la veo ideal para este cometido.**