# serverless.yml

La herramienta Serverless requiere de un archivo de configuración llamado serverless.yml, pudiéndose consultar el mío [aquí](../../serverless.yml). El código es el siguiente:

```yml
service: bot-get-match

provider:
  name: aws
  runtime: ruby2.7
  stage: dev
  region: eu-west-2

functions:
  get:
    handler: handler.getMatch
    events:
      - http:
          path: getMatch
          method: get
          cors: true
```

De forma general, establezco lo siguiente:

- Nombre del servicio
- Proveedor: aws con runtime de ruby. Además, es necesario establecer la región, en mi caso uno del oeste de Europa, debido a mi ubicación.
- Función serverless: hay que establecer en que archivo está la función serverless y qué función del archivo es. En mi caso está en el archivo handler y se llama getMatch. Por último, establecemos que ese trata de un evento get.

El uso de esta herramienta me permite poder mover mi bot de una plataforma a otra de una manera muy sencilla. Por ejemplo, para pasar mi bot a Azure simplemente tendría que cambiar el apartado provider, indicando en el nombre azure, cambiando la región a la correspondiente en dicha plataforma y ajustando el resto de parámetros que representan al proveedor, ejecutando el correspondiende `serverless deploy` o directamente al hacer push se subiría a dicha plataforma.