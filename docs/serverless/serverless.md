# serverless.yml

La herramienta Serverless requiere de un archivo de configuración llamado serverless.yml, pudiéndose consultar el mío [aquí](../../serverless.yml). El código es el siguiente:

```yml
service: bot-get-match

provider:
  name: aws
  runtime: ruby2.7
  memorySize: 128
  region: eu-west-3
  stage: dev

functions:
  getMatch:
    handler: handler.getMatch
    description: "Da el resultado de un partido de fútbol"
    events:
      - http:
          path: /
          method: get
    environment:
      TG_TOKEN: ${ssm:bot-get-match-token~true}
```

De forma general, establezco lo siguiente:

- Nombre del servicio
- Proveedor: aws con runtime de ruby. En mi caso he establecido un tamaño de memoria menor que el que venía por defecto (1024), pues no requería de tanto. Además, es necesario establecer la región, en mi caso París, el más cercano a mi ubicación.
- Función serverless: hay que establecer en que archivo está la función serverless y qué función de ellas es. En mi caso está en el archivo handler y se llama getMatch. Establecemos que ese trata de un evento get y le proporcionamos una variable TG_TOKEN que contiene el valor del token de telegram y la cual he creado desde la página de AWS para que pueda acceder a ella.