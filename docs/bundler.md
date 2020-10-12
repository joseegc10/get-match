# Bundler

Bundler nos permite la administración de librerías (gemas) en ruby. Si tuvieramos que instalar cada gema de forma manual en nuestros proyectos, podría provocar una pérdida de tiempo y un extra de dificultad. Este problema se resuelve con bundler, puesto que nos permite indicar las gemas y la versión de dichas gemas que se usan en el proyecto. Además, esto permite el poder tener diferentes versiones de la misma gema instaladas.
Además de que resuelve todo lo anterior, bundler es una herramienta que nos resuelve todo esto de forma muy sencilla, por lo que creo que es una muy buena opción y por ello la elijo.

## Instalación

Bundler es una gema más, por lo que se instala como cualquier gema.
`gem install bundler`

Posteriormente, iniciamos bundler, creándonos el archivo Gemfile donde se declararan las gemas usadas en el proyecto y las versiones.
`bundle init`

Una vez añadimos al archivo Gemfile las gemas y la versión que queremos usar de dichas gemas, hacemos lo siguiente para instalarlas.
`bundle install`