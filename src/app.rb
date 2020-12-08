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

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    get '/partido/goleadores/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            goleadores = @manejador.goleadoresPartido(numJornada, nombreEquipo)

            status 200
            hash = Hash.new 

            if goleadores.size > 0
                for goleador in goleadores
                    if hash[goleador.equipo.nombre]
                        hash[goleador.equipo.nombre] += (", " + goleador.nombre)
                    else
                        hash[goleador.equipo.nombre] = goleador.nombre
                    end
                end
            else
                hash["msg"] = "Ese partido no ha tenido ningún gol"
            end

            json(hash)
        rescue => e
            status 400
            json({:status => e.message})
        end
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    get '/partido/dias/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            dias = @manejador.diasPartido(numJornada, nombreEquipo)

            status 200
            hash = Hash.new 

            hash["dias"] = dias
            if dias > 0
                hash["msg"] = "El partido es dentro de #{dias} días"
            elsif dias < 0
                hash["msg"] = "El partido fue hace #{-dias} días"
            else
                hash["msg"] = "El partido es hoy"
            end

            json(hash)
        rescue => e
            status 400
            json({:status => e.message})
        end
    end
end