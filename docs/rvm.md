# RVM

[RVM](https://rvm.io/) es un gestor de versiones de python. Este nos va a permitir poder disponer de varias versiones de python en mi proyecto, pudiendo ejecutarlo en todas ellas.

## Motivo de uso

El principal motivo de uso es la sencillez que proporciona. Además, permite formar conjuntos de gemas que sean únicos para una versión determinada de ruby.

## Instalación

Primero instalamos la clave GPG

`gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB`

Instalamos RVM

`\curl -sSL https://get.rvm.io | bash -s stable`

Una vez lo hemos instalado, reiniciamos la consola y debemos ir a las preferencias de nuestra terminal y activar la siguiente opción.

![config_rvm](https://github.com/joseegc10/get-match/blob/master/docs/img/config_rvm.png)

Por último instalamos ruby, en mi caso la versión 2.7.0, aunque sería igual para cualquier otra.

`rvm install ruby-2.7.0`