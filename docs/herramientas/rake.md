# Rake

[Rake](https://github.com/ruby/rake) es una herramienta de construcción en Ruby que se ha convertido en un estándar, reemplazando a Make. Esto nos va a permitir la automatización de tareas, permitiendo incluso relaciones entre ellas.

## Ventajas

He elegido Rake por los siguientes motivos:

- Hay mucha documentación sobre él.
- Está escrito en ruby.
- Por el motivo anterior, podemos usar las gemas (librerías) que tengamos en nuestro proyecto.
- Se puede especificar requisitos previos a las tareas.
- Permite la ejecución paralela de las tareas.

## Instalación

Instalamos la gema rake.

`gem install rake`

Una vez hemos creado el archivo Rakefile, hacemos lo siguiente.

`rake`