require_relative "../config/config.rb"

# Clase que maneja una liga de futbol

class ManejaLiga
	# La clase para manejar la liga vendrá identificada por:
    #      - Dator donde se contiene la liga

	def initialize(dator)
        @dator = dator
    end

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    def resultadoPartido(numJornada, nombreEquipo)
        return @dator.resultadoPartido(numJornada, nombreEquipo)
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    def goleadoresPartido(numJornada, nombreEquipo)
        return @dator.goleadoresPartido(numJornada, nombreEquipo)
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    def diasPartido(numJornada, nombreEquipo)
        return @dator.diasPartido(numJornada, nombreEquipo)
    end

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    def maximoGoleadorPartido(numJornada, nombreEquipo)
        return @dator.maximoGoleadorPartido(numJornada, nombreEquipo)
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    def partidosJornada(numJornada)
        return @dator.partidosJornada(numJornada)
    end

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    def diasJornada(numJornada)
        return @dator.diasJornada(numJornada)
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    def maxGoleadorJornada(numJornada)
        return @dator.maxGoleadorJornada(numJornada)
    end

    # HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
    def equipoMaxGoleadorJornada(numJornada)
        return @dator.equipoMaxGoleadorJornada(numJornada)
    end

    # HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
    def equiposLiga()
        return @dator.equiposLiga()
    end

    # HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
    def rankingGoleadores()
        return @dator.rankingGoleadores()
    end

    # HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
    def clasificacionLiga()
        return @dator.clasificacionLiga()
    end

    # HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
    def golesEquipo(nombreEquipo)
        return @dator.golesEquipo(nombreEquipo)
    end

    # HU14: Como usuario, quiero poder añadir un equipo a una liga
    def aniadeEquipo(equipo)
        return @dator.aniadeEquipo(equipo)
    end

    # HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
    def aniadePartido(partido, partidoJSON, numJornada)
        return @dator.aniadePartido(partido, partidoJSON, numJornada)
    end

    # HU16: Como usuario, quiero poder añadir una jornada a una liga 
    def aniadeJornada(jornada, jornadaJSON, numJornada)
        return @dator.aniadeJornada(jornada, jornadaJSON, numJornada)
    end

    # HU19: Como usuario, quiero poder resetear la liga 
    def reseteaLiga()
        return @dator.reseteaLiga()
    end

    # HU20: Como usuario, debo poder acceder a la información de un equipo
    def equipo(nombre)
        return @dator.equipo(nombre)
    end
end