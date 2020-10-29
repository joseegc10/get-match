# Dependencias

Como he explicado en el apartado de herramientas, como gestor de dependencias uso bundler. Para instalar las dependencias podemos usar:

`bundle install`

Además, he creado una tarea en rake para poder realizar lo mismo, se haría de la siguiente forma:

`rake install`

Comentar que para poder realizar esto, es necesario tener instaladas las dos gemas:

`gem install bundler`

`gem install rake`

La documentación que he creado sobre bundler y rake se puede consultar en el apartado de herramientas.

Por último, el fichero Gemfile, donde se declaran las gemas a instalar, se puede consultar [aquí](https://github.com/joseegc10/get-match/blob/master/Gemfile).