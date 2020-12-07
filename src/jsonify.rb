require_relative "liga.rb"
require_relative "jornada.rb"
require_relative "equipo.rb"
require_relative "partido.rb"
require 'json'
require 'date'

# Clase que representa un "traductor" entre json y mis entidades

class Jsonify

	def initialize()
    end

    ##################################################################################

    def jsonToEquipo(json)
        nombre = json["name"]

        nombreJugadores = []

        equipo = Equipo.new(nombre)

        for jugador in json["players"]
            nuevoJugador = Jugador.new(jugador, equipo)
            equipo.aniadeJugador(nuevoJugador)
        end

        return equipo
    end

    ##################################################################################

    def jsonToPartido(json, equipos)
        jornada = ((json["round"].split(' '))[1]).to_i
       
        fecha = Date.parse json["date"]

        equipoLocal = nil
        equipoVisitante = nil
        for equipo in equipos
            if equipo.nombre == json["team1"]
                equipoLocal = equipo
            elsif equipo.nombre == json["team2"]
                equipoVisitante = equipo
            end
        end

        if equipoLocal == nil or equipoVisitante == nil
            raise ArgumentError, 'Al menos un equipo del partido no participa en la liga'
        end

        if json["score"]
            resultado = Resultado.new(json["score"]["ft"][0], json["score"]["ft"][1], equipoLocal, equipoVisitante)
            nombreGoleadores = json["score"]["scorers"]
            goleadores = []

            for nombre in nombreGoleadores
                begin
                    jugador = equipoLocal.buscaJugador(nombre["name"])
                    goleadores << jugador
                rescue
                    jugador = equipoVisitante.buscaJugador(nombre["name"])
                    goleadores << jugador
                end
            end

            partido = Partido.new(equipoLocal, equipoVisitante, fecha, resultado)
            partido.aniadeGoleadores(goleadores)
        else
            partido = Partido.new(equipoLocal, equipoVisitante, fecha)
        end

        return [partido, jornada]
    end

    ##################################################################################

    def jsonToJornada(json, equipos)
        jsonPartidos = json["matches"]

        if jsonPartidos.size == 0
            raise ArgumentError, 'La jornada no tiene ningún partido'
        end

        numJornada = ((jsonPartidos[0]["round"].split(' '))[1]).to_i
        fechaJornada = Date.parse jsonPartidos[0]["date"]

        partidos = []
        for jsonPartido in jsonPartidos
            nuevoPartido, numJornadaPartido = jsonToPartido(jsonPartido, equipos)

            if numJornadaPartido != numJornada
                raise ArgumentError, 'Todos los partidos no pertenecen a la misma jornada'
            end

            partidos << nuevoPartido
        end

        jornada = Jornada.new(fechaJornada)
        jornada.aniadePartidos(partidos)

        return [jornada, numJornada]
    end

    ##################################################################################

    def jsonToJornadas(partidosJSON, hashEquipos)
        partidos = partidosJSON["matches"]

        # Creamos el array para las jornadas
        numJornadas = (partidos.size / hashEquipos.size) * 2
        jornadas = Array.new(numJornadas)
        partidosPorJornada = hashEquipos.size / 2

        i = 0
        # Añadimos todos los partidos en su jornada correspondiente
        while i < partidos.size
            numJornada = Integer(i / partidosPorJornada)

            # Miramos si toca crear jornada
            if (i % partidosPorJornada) == 0
                fechaJornada = Date.parse partidos[i]["date"]
                nuevaJornada = Jornada.new(fechaJornada)
                jornadas[numJornada] = nuevaJornada
            end

            # Creamos el partido con el equipo local, visitante, fecha y resultado
            equipoLocal = hashEquipos[partidos[i]["team1"]]
            equipoVisitante = hashEquipos[partidos[i]["team2"]]
            fechaPartido = Date.parse partidos[i]["date"]

            if partidos[i]["score"]
                resultado = Resultado.new(
                    partidos[i]["score"]["ft"][0], 
                    partidos[i]["score"]["ft"][1],
                    partidos[i]["team1"],
                    partidos[i]["team2"]
                )

                nuevoPartido = Partido.new(equipoLocal, equipoVisitante, fechaPartido, resultado)
            else
                nuevoPartido = Partido.new(equipoLocal, equipoVisitante, fechaPartido)
            end

            # Añadimos los goleadores del partido
            if partidos[i]["score"] and partidos[i]["score"]["scorers"]
                goleadores = partidos[i]["score"]["scorers"]
                for goleador in goleadores
                    nuevoPartido.aniadeGoleadorNombre(goleador["name"], goleador["team"])
                end
            end

            # Añadimos el partido a la jornada
            jornadas[numJornada].aniadePartido(nuevoPartido)
            
            i += 1
        end

        return jornadas
    end

    ##################################################################################

    def jsonToLiga(ubicacionPartidos, ubicacionEquipos)
        pathPartidos = File.join(File.dirname(__FILE__), ubicacionPartidos)
		filePartidos = File.read(pathPartidos)
        partidosJSON = JSON.parse(filePartidos)
        
        pathEquipos = File.join(File.dirname(__FILE__), ubicacionEquipos)
		fileEquipos = File.read(pathEquipos)
        equiposJSON = JSON.parse(fileEquipos)

        clubs = equiposJSON["clubs"]
        equipos = []
        hashEquipos = Hash.new

        # Añadimos los equipos de la liga
        for club in clubs
            nuevoEquipo = Equipo.new(club["name"])

            # Añadimos los jugadores del equipo
            players = club["players"]
            for player in players
                nuevoJugador = Jugador.new(player, nuevoEquipo)
                nuevoEquipo.aniadeJugador(nuevoJugador)
            end

            equipos << nuevoEquipo
            hashEquipos[club["name"]] = nuevoEquipo
        end

        liga = Liga.new(equipos, partidosJSON["name"])

        jornadas = jsonToJornadas(partidosJSON, hashEquipos)

        i = 0
        for jornada in jornadas
            liga.aniadeJornada(jornada, i)
            i += 1
        end

        return liga
    end
end