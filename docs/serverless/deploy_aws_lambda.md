# Despliegue a AWS Lambda

En primer lugar, comentar que aws contiene las herramientas necesarias para conectar una función Lambda con GitHub. Sin embargo, pienso que existía una excesiva dificultad para conseguirlo, pudiéndo hacer una simple GitHub action que me permitiera hacer lo que quería. Esta GH action se puede consultar [aquí](../../.github/workflows/awsDeploy.yml).

El código de la action es el siguiente:

```yml
name: Deploy telegramBot

on:
  push:
    paths:
      - "handler.rb"
      - "serverless.yml"

jobs:
  deploy:
    name: deploy
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [12.x]
    steps:
    - uses: actions/checkout@v2
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v1
      with:
        node-version: ${{ matrix.node-version }}
    - name: serverless deploy
      uses: serverless/github-action@master
      with:
        args: deploy
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

Como se puede observar, esta action solo se ejecuta cuando se modifica el archivo handler.rb o el archivo serverless.yml, los dos archivos en los que se basa el bot de telegram.

El trabajo de esta action consiste en usar una máquina ubuntu en la que va a descargar node.js, necesario para la herramienta serverless, y la descarga de dicha herramienta. Posteriormente, le proporcionamos el AWS_ACCESS_KEY_ID y el AWS_SECRET_ACCESS_KEY, que le permite conectarse al contenedor de datos S3 de AWS.

Para poder hacer esto, he creado dos secrets en el repositorio, pues estas claves no pueden estar de forma pública, permitiéndome garantizar la seguridad de ellas.
