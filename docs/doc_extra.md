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

## Integración continua

### Travis-CI

- La documentación sobre el proceso seguido para enlazar este repositorio con Travis se puede ver en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/travis/config_travis.md).
- Para consultar una explicación de Travis-CI, incluyendo sus ventajas, como se ha hecho la construcción del fichero .travis.yml y la justificación de las versiones de ruby utilizadas y pruebas realizadas, seguir el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/travis/travis.md).

### Circle-CI

- La documentación sobre el proceso seguido para enlazar este repositorio con CircleCI se puede ver en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/circleci/config_circleci.md).
- Para consultar una explicación de CircleCI, incluyendo sus ventajas, como se ha construido el fichero config.yml y una comparación con Travis, consultar el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/circleci/circleci.md).

### Github Action

He creado una github action para la publicación automática de la imagen en GitHub Container Registry. La explicación del fichero se puede ver en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/ghact.md).

## Serverless

### Vercel

La documentación sobre Vercel y la función Serverless creada se puede consultar en el siguiente [enlace](./docs/serverless/vercel.md).

### AWS Lambda

- La documentación sobre AWS Lambda y el bot de Telegram creado se puede consultar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/serverless/aws_lamda.md).
- La documentación sobre el archivo serverless.yml que me permite establecer la configuración del deploy a aws, puede consultarse [aquí](./docs/serverless/serverless.md).
- He creado una github action para el deploy automático a aws lambda cuando hacemos push en este repositorio modificando alguno de los dos archivos del bot. La información sobre esta action se puede consultar [aquí](./docs/serverless/deploy_aws_lambda.md).