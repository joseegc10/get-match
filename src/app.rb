require 'sinatra/base'
require 'json'
require_relative 'manejaLiga.rb'

class MyApp < Sinatra::Base
    before do
        @manejador = ManejaLiga.new()
        @jsonify = Jsonify.new()
    end

    def json(data_object)
        content_type :json
        data_object.to_json
    end

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    get '/partido/resultado/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            resultado = @manejador.resultadoPartido(numJornada, nombreEquipo)

            status 200
            json(
                {
                    :Local => resultado.equipoLocal, 
                    :Visitante => resultado.equipoVisitante, 
                    :resultado => {
                        :golesLocal => resultado.golesLocal,
                        :golesVisitante => resultado.golesVisitante
                    }
                }
            )
        rescue => e
            status 400
            json({:status => e.message})
        end
        
    end
end