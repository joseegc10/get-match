require './src/app.rb'
require './config/config.rb'

vars = configuracion()

Rack::Handler.default.run(MyApp, :Port => vars["PORT"])