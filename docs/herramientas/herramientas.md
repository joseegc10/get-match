# Herramientas :hammer:

## Herramientas principales

- Como **lenguaje de programación** he elegido [Ruby](https://www.ruby-lang.org/es/), ya que es un lenguaje no demasiado difícil y con el cual no he realizado ningún proyecto. Esto me motiva a elegirlo, para poder aprender a realizar proyectos en este lenguaje.
- Como **gestor de versiones** de ruby he elegido **RVM**, cuya información puede encontrarse en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/rvm.md).
- Como **herramienta de gestión de dependencias** se hace uso de **bundler**. La información acerca de esta herramienta se puede consultar en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/bundler.md).
- Como **herramienta para testear el código** uso **RSpec**, documentada en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/rspec.md).
- Como **gestor de tareas** uso **Rake**, documentada en el siguiente [enlace](https://github.com/joseegc10/get-match/blob/master/docs/herramientas/rake.md).

## Otras herramientas:

- **Framework:** He elegido Sinatra, descubierto por recomendación en el grupo de telegram de la asignatura. El motivo de la elección ha sido que lo consideran un framework sencillo con el que realizar APIs REST, pues contiene lo mínimo para poder hacerla. Además, es un framework bastante rápido.
- **Base de datos:** Los resultados de los partidos hará falta almacenarlos, por lo que se necesitará una capa de persistencia, más adelante decidida, como podría ser el almacenamiento local en archivos JSON.
- **Fuente de datos:** Obtenidos de forma externa, permitiendo estar lo más al día posible.
- **Logs:** Será necesario almacenar las "trazas" que siguen los usuarios, lo que nos permitirá la búsqueda de posibles errores y mejorar la gestión de la información.