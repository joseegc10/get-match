# CircleCI

**CircleCI es otro sistema de integración continua. Su página oficial se puede encontrar [aquí](https://circleci.com/).**

## Ventajas de CircleCI

- Es muy sencillo de enlazar con GitHub.
- Los trabajos se ejecutan de forma rápida.
- Soporta múltiples plataformas.
- Tiene soporte Docker.
- Se puede llegar a hacer ejecuciones en palalelo mediante el uso de contenedores, pero lo veo con mayor dificultad que en Travis.

## Uso

Al igual que para Travis, necesitamos crear un archivo para la configuración. En este caso, debemos crear una carpeta llamada .circleci y dentro de ella añadir el archivo config.yml. El archivo que he creado se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/.circleci/config.yml). En él, hacemos lo siguiente:

```
# Versión de CircleCI que vamos a usar
version: 2.1

# Trabajos
jobs:
  build:
    # Indicamos que hacemos uso de docker
    docker:
      - image: joseegc10/get-match
    # Pasos en la ejecución del trabajo build
    steps:
      # Descargamos el repo
      - checkout
      # Ejecutamos los test con el contenedor de docker
      - run: rake test
```

Lo explicamos paso por paso:

1. Indicamos la versión de CircleCI que vamos a usar:

`version: 2.1`

2. Indicamos los trabajos que se van a realizar:

`jobs:`

3. Tarea build:
```
    # Indicamos que hacemos uso de docker
    docker:
      - image: joseegc10/get-match
    # Pasos en la ejecución del trabajo build
    steps:
      # Descargamos el repo
      - checkout
      # Ejecutamos los test con el contenedor de docker
      - run: rake test
```

En la tarea anterior, en primer lugar indicamos que vamos a utilizar un contenedor de Docker, pues este aumenta el rendimiento compilando solo lo necesario. Posteriormente, establecemos los pasos a seguir en el trabajo:

    1. Hacemos checkout del repo.

    - checkout

    2. Ejecutamos los test en el contenedor de docker

    - run: rake test

En la siguiente imagen se muestra el correcto funcionamiento del trabajo build, es decir, cuando hacemos push a nuestro repositorio de GitHub, en CircleCI se va a proceder a hacer el pull de nuestro contenedor y la ejecución de los test:

![test](https://raw.githubusercontent.com/joseegc10/get-match/master/docs/img/circleci/test.png)


# Finalidad de uso

En el caso de Travis, vi adecuado usarlo para hacer la prueba de la versión de ruby en las que mi código funcionaba (los tests pasaban). Sin embargo, CircleCI lo veo adecuado para el uso de Docker, pues, según su página oficial, destaca en rapidez. Para comprobar esto, modifiqué el fichero de configuración de travis para que hiciera lo mismo que hago en CircleCI, quedando de la siguiente forma:

```
language: ruby

docker run -t -v `pwd`:/test joseegc10/get-match
```

El tiempo que tardó Travis en ejecutarlo se puede ver a continuación:

![prueba-travis](https://raw.githubusercontent.com/joseegc10/get-match/master/docs/img/circleci/prueba-travis.png)

Mientras que CircleCI tardó lo siguiente:

![prueba-circle](https://raw.githubusercontent.com/joseegc10/get-match/master/docs/img/circleci/prueba-circle.png)

Como se puede apreciar, pasamos de 25 segundos a 11. Esto demuestra lo que decíamos al principio, CircleCI es más rapido, en concreto es más de 2 veces más rapido, por lo que es muy adecuado para la ejecución de los tests usando mi contenedor de docker.