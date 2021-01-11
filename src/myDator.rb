require_relative "jsonify.rb"
require_relative "../config/config.rb"
require_relative './dator'

# Clase que almacena una liga de futbol leída desde un fichero JSON
PARTIDOS_JSON = '../sampledata/partidos.json'
EQUIPOS_JSON = '../sampledata/equipos.json'
CONF = configuracion()

class MyDator < Dator
	def initialize()
        @jsonify = Jsonify.new()

        pathPartidos = File.join(File.dirname(__FILE__), PARTIDOS_JSON)
		filePartidos = File.read(pathPartidos)
        partidosJSON = JSON.parse(filePartidos)

        partidosJSON = partidosJSON["matches"]
        finalPartidosJSON = []
        jornada1 = Hash.new
        jornada1["0"] = partidosJSON[0]
        jornada1["1"] = partidosJSON[1]
        jornada2 = Hash.new
        jornada2["0"] = partidosJSON[2]
        jornada2["1"] = partidosJSON[3]
        finalPartidosJSON << jornada1
        finalPartidosJSON << jornada2
        
        pathEquipos = File.join(File.dirname(__FILE__), EQUIPOS_JSON)
		fileEquipos = File.read(pathEquipos)
        equiposJSON = JSON.parse(fileEquipos)

        equiposJSON = equiposJSON["clubs"]
        finalEquiposJSON = Hash.new
        i = 0
        for e in equiposJSON
            finalEquiposJSON[i.to_s] = e
            i += 1
        end

        ligaJSON = Hash.new
        ligaJSON["equipos"] = finalEquiposJSON
        ligaJSON["jornadas"] = finalPartidosJSON

        @liga = @jsonify.jsonToLiga(ligaJSON)

        if @liga.equipos.size > CONF["NUM_MAX_EQUIPOS"]
            raise ArgumentError, 'Número de equipos demasiado alto'
        end
    end

    # Método auxiliar
    def buscaEquipo(nombreEquipo)
        equipos = @liga.equipos

        equipo = nil
        for e in equipos
            if e.nombre == nombreEquipo
                equipo = e
            end
        end

        if equipo
            return equipo
        else
            raise ArgumentError, 'Ese equipo no pertenece a la liga'
        end
    end

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    def resultadoPartido(numJornada, nombreEquipo)
        # Jornada: 0..numJornadas
        numJornada -= 1

        equipo = buscaEquipo(nombreEquipo)
        
        resultado = @liga.resultadoPartido(numJornada, equipo)

        return resultado
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    def goleadoresPartido(numJornada, nombreEquipo)
        # Jornada: 0..numJornadas
        numJornada -= 1

        equipo = buscaEquipo(nombreEquipo)

        goleadores = @liga.goleadoresPartido(numJornada, equipo)

        return goleadores
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    def diasPartido(numJornada, nombreEquipo)
        # Jornada: 0..numJornadas
        numJornada -= 1

        equipo = buscaEquipo(nombreEquipo)

        dias = @liga.diasPartido(numJornada, equipo)

        return dias
    end

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    def maximoGoleadorPartido(numJornada, nombreEquipo)
        # Jornada: 0..numJornadas
        numJornada -= 1

        equipo = buscaEquipo(nombreEquipo)

        goleador_goles = @liga.maxGoleadorPartido(numJornada, equipo)

        return goleador_goles
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    def partidosJornada(numJornada)
        # Jornada: 0..numJornadas
        numJornada -= 1

        partidos = @liga.partidosJornada(numJornada)

        return partidos
    end

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    def diasJornada(numJornada)
        # Jornada: 0..numJornadas
        numJornada -= 1

        dias = @liga.diasJornada(numJornada)

        return dias
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    def maxGoleadorJornada(numJornada)
        # Jornada: 0..numJornadas
        numJornada -= 1

        goleador_goles = @liga.maxGoleadorJornada(numJornada)

        return goleador_goles
    end

    # HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
    def equipoMaxGoleadorJornada(numJornada)
        # Jornada: 0..numJornadas
        numJornada -= 1

        equipo_goles = @liga.equipoMaxGoleadorJornada(numJornada)

        return equipo_goles
    end

    # HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
    def equiposLiga()
        return @liga.equipos
    end

    # HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
    def rankingGoleadores()
        return @liga.rankingGoleadores
    end

    # HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
    def clasificacionLiga()
        return @liga.clasificacion
    end

    # HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
    def golesEquipo(nombreEquipo)
        equipo = buscaEquipo(nombreEquipo)

        goles = @liga.numGolesEquipo(equipo)

        return goles
    end

    # HU14: Como usuario, quiero poder añadir un equipo a una liga
    def aniadeEquipo(jsonEquipo)
        raise ArgumentError, 'El parámetro debe ser un json' unless jsonEquipo.is_a? Hash

        equipo = @jsonify.jsonToEquipo(jsonEquipo)

        if @liga.equipos.size == CONF["NUM_MAX_EQUIPOS"]
            raise ArgumentError, 'La liga tiene el número máximo de equipos'
        end

        @liga.aniadeEquipo(equipo)
    end

    # HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
    def aniadePartido(partido, jsonPartido, numJornada)
        numJornada -= 1

        @liga.aniadePartido(partido, numJornada)
    end

    # HU16: Como usuario, quiero poder añadir una jornada a una liga 
    def aniadeJornada(jornada, jsonPartidos, numJornada)
        numJornada -= 1

        @liga.aniadeJornada(jornada, numJornada)
    end

    # HU19: Como usuario, quiero poder resetear la liga
    def reseteaLiga()
        @liga.reseteaLiga()
    end

    # HU20: Como usuario, debo poder acceder a la información de un equipo
    def equipo(nombre)
        return buscaEquipo(nombre)
    end
end