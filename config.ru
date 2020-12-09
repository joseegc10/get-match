require './src/app.rb'
require './config/config.rb'
require 'sinatra'

vars = configuracion()
Rack::Handler.default.run(MyApp, :Port => vars["PORT"])