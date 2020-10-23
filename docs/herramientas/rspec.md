# RSPEC

[RSpec](https://rspec.info/) es una herramienta que nos permite testear el código que escribimos en ruby, realizando pruebas unitarias, es decir, probando cada método o función. Este permite el desarrollo basado en pruebas (TDD), escribiendo las pruebas primero y permitiendo la automatización de estas pruebas.

## Ventajas

Los motivos de la elección de RSpec son:

- Realiza pruebas de forma rápida.
- Esta orientado a pruebas unitarias.
- Es sencillo y fácil de aprender.
- Proporciona información desarrollada sobre los errores.
- Permite la prueba de una clase o parte de una clase de forma aislada al resto del código.
- Está escrito en ruby.

## Instalación

Instalamos la gema rspec.

`gem install rspec`

Posteriormente, iniciamos rspec.

`rspec --init`

Una vez hacemos lo anterior, se generan dos cosas:
- Una carpeta spec, donde se deberán incluir los test que realicemos, con el nombre de la clase y añadiendo _spec en el nombre de todos ellos (Ej: partido_spec.rb). Además, dentro de esta carpeta se genera el archivo spec_helper.rb, necesario para la ejecución de los tests.
- Un archivo .rspec, que nos servirá para no tener que hacer el require de spec_helper en cada fichero, por lo que es necesario dejarlo en el repositorio.