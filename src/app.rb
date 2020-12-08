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

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    get '/partido/maximo-goleador/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            goleador_goles = @manejador.maximoGoleadorPartido(numJornada, nombreEquipo)

            status 200
            hash = Hash.new 

            if goleador_goles.goles > 0
                hash["maximoGoleador"] = goleador_goles.goleador.nombre
                hash["equipo"] = goleador_goles.goleador.equipo.nombre
                hash["goles"] = goleador_goles.goles
                
                if goleador_goles.goles == 1
                    hash["msg"] = "El jugador #{goleador_goles.goleador.nombre} ha metido #{goleador_goles.goles} gol"
                else
                    hash["msg"] = "El jugador #{goleador_goles.goleador.nombre} ha metido #{goleador_goles.goles} goles"
                end
            else
                hash["msg"] = "En dicho partido no hubo ningún gol"
            end

            json(hash)
        rescue => e
            status 400
            json({:status => e.message})
        end
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    get '/jornada/partidos/:jornada' do
        numJornada = params['jornada'].to_i

        begin
            partidos = @manejador.partidosJornada(numJornada)

            status 200
            hash = Hash.new 

            i = 1
            for partido in partidos
                nuevoHash = Hash.new

                nuevoHash["local"] = partido.local.nombre
                nuevoHash["visitante"] = partido.visitante.nombre

                begin
                    resultado = partido.calculaResultado
                    hashResultado = Hash.new
                    hashResultado["golesLocal"] = resultado.golesLocal
                    hashResultado["golesVisitante"] = resultado.golesVisitante
                    nuevoHash["resultado"] = hashResultado
                rescue
                end

                numPartido = "Partido #{i}"

                hash[numPartido] = nuevoHash

                i += 1
            end

            json(hash)
        rescue => e
            status 400
            json({:status => e.message})
        end
    end

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    get '/jornada/dias/:jornada' do
        numJornada = params['jornada'].to_i

        begin
            dias = @manejador.diasJornada(numJornada)

            status 200
            hash = Hash.new 

            hash["dias"] = dias
            if dias > 0
                hash["msg"] = "La jornada #{numJornada} es dentro de #{dias} días"
            elsif dias < 0
                hash["msg"] = "La jornada #{numJornada} fue hace #{-dias} días"
            else
                hash["msg"] = "La jornada #{numJornada} es hoy"
            end

            json(hash)
        rescue => e
            status 400
            json({:status => e.message})
        end
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    get '/jornada/maximo-goleador/:jornada' do
        numJornada = params['jornada'].to_i

        begin
            goleador_goles = @manejador.maxGoleadorJornada(numJornada)

            status 200
            hash = Hash.new 

            if goleador_goles.goles > 0
                hash["maximoGoleador"] = goleador_goles.goleador.nombre
                hash["equipo"] = goleador_goles.goleador.equipo.nombre
                hash["goles"] = goleador_goles.goles
                
                if goleador_goles.goles == 1
                    hash["msg"] = "El jugador #{goleador_goles.goleador.nombre} ha metido #{goleador_goles.goles} gol"
                else
                    hash["msg"] = "El jugador #{goleador_goles.goleador.nombre} ha metido #{goleador_goles.goles} goles"
                end
            else
                hash["msg"] = "En la jornada #{numJornada} no hubo ningún gol"
            end

            json(hash)
        rescue => e
            status 400
            json({:status => e.message})
        end
    end
end