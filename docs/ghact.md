# GitHub Action

En este archivo se recogerán las github actions que elabore a lo largo del proyecto.

En primer lugar, he creado una github action para que cuando hagamos push al repositorio de github, haga un build de nuevo de la imagen, ejecute los tests y si no fallan estos, haga push automáticamente a Github Container Registry. Esta Github Action se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/.github/workflows/contenedor.yml) y ha quedado de la siguiente forma:

```
name: auto-docker-build
on: [push]
jobs:
    auto-GHCR:
        runs-on: ubuntu-latest
        steps:
        - uses: actions/checkout@v2
        - name: login en GitHub Container Registry
          env:
            DOCKER_USER: ${{ secrets.USER_GITHUBCR }}
            DOCKER_PASSWORD: ${{ secrets.PASSWORD_GITHUBCR }}
          run: docker login ghcr.io -u $DOCKER_USER -p $DOCKER_PASSWORD 
        - name: construccion de la imagen
          run: docker build -t ghcr.io/joseegc10/env-get-match:latest .
        - name: ejecutar tests
          run: docker run -t -v `pwd`:/test ghcr.io/joseegc10/env-get-match:latest
        - name: push a GitHub Container Registry
          run: docker push ghcr.io/joseegc10/env-get-match:latest
```

Como hemos mencionado arriba, en primer lugar hace login en GitHub Container Registry, para posteriormente hacer la construcción de la imagen. Después, ejecuta los tests y en el caso de que no fallen, sube a GitHub Container Registry la imagen.