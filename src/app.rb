require 'sinatra/base'
require 'json'
require_relative './manejaLiga'
require 'logger'
require_relative '../config/config.rb'
require_relative './myLogger'
require_relative './firebaseDator'

class MyApp < Sinatra::Base
    set :environment, configuracion()["APP_ENV"]

    configure :production do
        myLogger = MyLogger.new('output.log')
        @@logger = myLogger._logger
        set :logger, @@logger
    end
    
    configure :development do
        myLogger = MyLogger.new()
        @@logger = myLogger._logger
        set :logger, @@logger
    end

    configure do
        dator = FirebaseDator.new()
        @@manejador = ManejaLiga.new(dator)
        @@jsonify = Jsonify.new()
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
            resultado = @@manejador.resultadoPartido(numJornada, nombreEquipo)

            status 200
            json(
                {
                    :Local => resultado.equipoLocal.nombre, 
                    :Visitante => resultado.equipoVisitante.nombre, 
                    :resultado => {
                        :golesLocal => resultado.golesLocal,
                        :golesVisitante => resultado.golesVisitante
                    }
                }
            )
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    get '/partido/goleadores/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            goleadores = @@manejador.goleadoresPartido(numJornada, nombreEquipo)

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
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    get '/partido/dias/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            dias = @@manejador.diasPartido(numJornada, nombreEquipo)

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
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    get '/partido/maximo-goleador/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            goleador_goles = @@manejador.maximoGoleadorPartido(numJornada, nombreEquipo)

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
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    get '/jornada/partidos/:jornada' do
        numJornada = params['jornada'].to_i

        begin
            partidos = @@manejador.partidosJornada(numJornada)

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
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    get '/jornada/dias/:jornada' do
        numJornada = params['jornada'].to_i

        begin
            dias = @@manejador.diasJornada(numJornada)

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
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    get '/jornada/maximo-goleador/:jornada' do
        numJornada = params['jornada'].to_i

        begin
            goleador_goles = @@manejador.maxGoleadorJornada(numJornada)

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
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
    get '/jornada/equipo/maximo-goleador/:jornada' do
        numJornada = params['jornada'].to_i

        begin
            equipo_goles = @@manejador.equipoMaxGoleadorJornada(numJornada)

            status 200
            hash = Hash.new 

            if equipo_goles.goles > 0
                hash["equipo"] = equipo_goles.equipo.nombre
                hash["goles"] = equipo_goles.goles
                
                if equipo_goles.goles == 1
                    hash["msg"] = "El equipo #{equipo_goles.equipo.nombre} ha metido #{equipo_goles.goles} gol"
                else
                    hash["msg"] = "El equipo #{equipo_goles.equipo.nombre} ha metido #{equipo_goles.goles} goles"
                end
            else
                hash["msg"] = "En la jornada #{numJornada} no hubo ningún gol"
            end

            json(hash)
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
    get '/equipos' do
        begin
            equipos = @@manejador.equiposLiga()

            status 200
            hash = Hash.new 

            i = 1
            for equipo in equipos
                numEquipo = "Equipo #{i}"

                hash[numEquipo] = equipo.nombre

                i += 1
            end

            json(hash)
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
    get '/ranking/goleadores' do
        begin
            goleadores_goles = @@manejador.rankingGoleadores()

            status 200
            hash = Hash.new 

            i = 1
            for goleador_goles in goleadores_goles
                numero = "#{i}º"

                hashJugador = Hash.new
                hashJugador["nombre"] = goleador_goles.goleador.nombre
                hashJugador["equipo"] = goleador_goles.goleador.equipo.nombre
                hashJugador["goles"] = goleador_goles.goles

                hash[numero] = hashJugador

                i += 1
            end

            json(hash)
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
    get '/ranking/clasificacion' do
        begin
            equipos_puntos_goles = @@manejador.clasificacionLiga()

            status 200
            hash = Hash.new 

            i = 1
            for equipo_puntos_goles in equipos_puntos_goles
                numero = "#{i}º"

                hashEquipo = Hash.new
                hashEquipo["equipo"] = equipo_puntos_goles.equipo.nombre
                hashEquipo["puntos"] = equipo_puntos_goles.puntos
                hashEquipo["goles"] = equipo_puntos_goles.goles

                hash[numero] = hashEquipo

                i += 1
            end

            json(hash)
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
    get '/equipo/goles/:equipo' do
        equipo = params['equipo']

        begin
            goles = @@manejador.golesEquipo(equipo)

            status 200
            hash = Hash.new 

            hash["equipo"] = equipo
            hash["goles"] = goles

            if goles > 0            
                if goles == 1
                    hash["msg"] = "El equipo #{equipo} ha metido #{goles} gol"
                else
                    hash["msg"] = "El equipo #{equipo} ha metido #{goles} goles"
                end
            else   
                hash["msg"] = "El equipo #{equipo} no ha metido ningún gol"
            end

            json(hash)
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU14: Como usuario, quiero poder añadir un equipo a una ligaanejadoranejador
    post '/equipos' do
        # curl --header "Content-Type: application/json" --request POST --data '{"name":"Valencia","code":"VAL","country":"Spain","players":["Gaya","Mangala"]}' http://localhost:9999/add/equipo
        begin
            jsonEquipo = JSON.parse(request.body.read)

            ## Comprobamos que la estructura es correcta y se podría formar un equipo
            equipo = @@jsonify.jsonToEquipo(jsonEquipo)

            
            @@manejador.aniadeEquipo(jsonEquipo)

            status 200
            json({:status => "Equipo añadido correctamente"})
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end
    
    # HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
    post '/partidos' do
        # curl --header "Content-Type: application/json" --request POST --data '{"round": "Jornada 1","date": "2020-12-1","team1": "Real Madrid","team2": "Sevilla FC","score": {"ft": [1,0],"scorers": [{"team": "Real Madrid","name": "Sergio Ramos"}]  }}' http://localhost:9999/add/partido
        begin
            jsonPartido = JSON.parse(request.body.read)
            partido, numJornada = @@jsonify.jsonToPartido(jsonPartido, @@manejador.equiposLiga)
            @@manejador.aniadePartido(partido, jsonPartido, numJornada)

            status 200
            json({:status => "Partido añadido correctamente"})
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU16: Como usuario, quiero poder añadir una jornada a una liga 
    post '/jornadas' do
        # curl --header "Content-Type: application/json" --request POST --data '{"name": "Primera División 2020/21","matches": [{"round": "Jornada 3","date": "2020-12-20","team1": "Real Madrid","team2": "FC Barcelona"},{"round": "Jornada 3","date": "2020-12-21","team1": "Sevilla FC","team2": "Atlético Madrid"}]}' http://localhost:9999/add/jornada
        begin
            jsonPartidos = JSON.parse(request.body.read)
            jornada, numJornada = @@jsonify.jsonToJornada(jsonPartidos, @@manejador.equiposLiga)
            @@manejador.aniadeJornada(jornada, jsonPartidos, numJornada)

            status 200
            json({:status => "Jornada #{numJornada} añadida correctamente"})
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU19: Como usuario, quiero poder resetear la liga 
    delete '/nuevaLiga' do
        begin
            @@manejador.reseteaLiga()

            status 200
            json({:status => "Liga reseteada correctamente"})
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    # HU20: Como usuario, debo poder acceder a la información de un equipo
    get '/equipos/:equipo' do
        begin
            equipo = @@manejador.equipo(params['equipo'])

            status 200
            hash = Hash.new 

            hash["nombre"] = equipo.nombre
            hash["jugadores"] = []
            for j in equipo.jugadores
                hash["jugadores"] << j.nombre
            end

            json(hash)
        rescue => $error
            status 400
            json({:status => $error.message})
        end
    end

    error 404 do
        @@logger.info("La ruta introducida no ha sido encontrada")
		json({:status => 'Error: la ruta introducida no ha sido encontrada'})
    end
    
    after do
        if $error
            @@logger.info($error.message)
            $error = nil
        end
    end
end