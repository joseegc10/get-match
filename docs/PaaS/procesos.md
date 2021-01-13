# Gestor de procesos

Como gestor de procesos, he querido hacer uso de una herramienta que me permitiera una **integración total** con mi proyecto de ruby, es decir, un gestor de procesos que consistiera en una gema de ruby.

En primer lugar, estuve aprendiendo sobre la **gema 'god'**. Esta gema es bastante fácil de configurar, pues funciona en base a lo que llama relojes. Un reloj consiste en una estructura en la cual le indicamos el nombre del proceso, como se arranca, se detiene, si se mantiene vivo siempre o no, etc. Por tanto, debemos crear una archivo .god y añadir un reloj con nuestro proyecto en él:

```ruby
God.watch do |w|
  w.name = "get-match"
  w.dir = "."
  w.pid_file = "#{w.name}.pid"
  w.start = "rackup -D config.ru -p 9292 -P #{w.pid_file}"
  w.keepalive
end
```

Como vemos, el reloj anterior nos va a generar el proceso llamado get-match, arrancándolo mediante rackup y manteniendolo vivo. Por tanto, se ejecutamos `god -c fichero.god`, se arrancará el proceso god que se va a encargar de ejecutar nuestros procesos. El proceso get-match lo arranca por defecto, pudiendo ejecutar las siguiente órdenes para pararlo, arrancarlo, reiniciarlo o monitorizarlo:

```bash
god stop get-match
god start get-match
god restart get-match
god log get-match
```

Sin embargo, a pesar de la enorme simpleza que me aporta esta herramienta, he descartado su uso. El motivo ha sido que no he encontrado opciones por ejemplo para levantar varias instancias de mi aplicación, es decir, de forma sencilla, solo podemos hacer las operaciones básicas que he comentado anteriormente, y si nos salimos de ahí la herramienta comienza a coger una excesiva complejidad.

Por tanto, se va a hacer uso de otro gestor de procesos, **foreman**. Este, además de ser una gema de ruby y de tener un funcionamiento simple, me permite la ejecución de varias instancias de mi aplicación, pudiendo hacer estas operaciones más complejas de forma simple también. Para la ejecución de más de un proceso del mismo tipo, existe la siguiente orden:

`foreman start -c worker=2`

Con la cual ejecutamos dos procesos del mismo tipo. Además, foreman toma el fichero Procfile para saber que proceso tiene que ejecutar, el cual ya teníamos creado por Heroku, no teniendo que hacer este trabajo extra. 

Como última razón, foreman es útil tanto para ejecutar el API en desarrollo, haciendo uso de lo anterior, como para ejecutarla en producción. Para esto, tiene la orden `foreman export`, la cual nos permite exportar a upstart o standard unix init.

Por tanto, se ha creado una tarea en mi fichero [Rakefile](../../Rakefile), start, la cual ejecuta la orden `foreman start`, ejecutándolo lo que teníamos en nuestro fichero [Procfile](../../Procfile), es decir, la orden `bundle exec rackup config.ru -p $PORT`, por lo que se ejecuta lo que tengamos en nuestro fichero de configuración [config.ru](../../config.ru).