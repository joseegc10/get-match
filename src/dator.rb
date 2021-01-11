class Dator
    def initialize()
        if (self.instance_of? Dator)
            raise  "No se permiten crear instancias de una clase abstracta"
        end
    end

    # Método auxiliar
    def buscaEquipo(nombreEquipo)
        raise "Necesaria implementación del método"
    end

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    def resultadoPartido(numJornada, nombreEquipo)
        raise "Necesaria implementación del método"
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    def goleadoresPartido(numJornada, nombreEquipo)
        raise "Necesaria implementación del método"
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    def diasPartido(numJornada, nombreEquipo)
        raise "Necesaria implementación del método"
    end

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    def maximoGoleadorPartido(numJornada, nombreEquipo)
        raise "Necesaria implementación del método"
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    def partidosJornada(numJornada)
        raise "Necesaria implementación del método"
    end

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    def diasJornada(numJornada)
        raise "Necesaria implementación del método"
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    def maxGoleadorJornada(numJornada)
        raise "Necesaria implementación del método"
    end

    # HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
    def equipoMaxGoleadorJornada(numJornada)
        raise "Necesaria implementación del método"
    end

    # HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
    def equiposLiga()
        raise "Necesaria implementación del método"
    end

    # HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
    def rankingGoleadores()
        raise "Necesaria implementación del método"
    end

    # HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
    def clasificacionLiga()
        raise "Necesaria implementación del método"
    end

    # HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
    def golesEquipo(nombreEquipo)
        raise "Necesaria implementación del método"
    end

    # HU14: Como usuario, quiero poder añadir un equipo a una liga
    def aniadeEquipo(equipo)
        raise "Necesaria implementación del método"
    end

    # HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
    def aniadePartido(partido, numJornada)
        raise "Necesaria implementación del método"
    end

    # HU16: Como usuario, quiero poder añadir una jornada a una liga 
    def aniadeJornada(jornada, numJornada)
        raise "Necesaria implementación del método"
    end

    # HU19: Como usuario, quiero poder resetear la liga 
    def reseteaLiga()
        raise "Necesaria implementación del método"
    end

    # HU20: Como usuario, debo poder acceder a la información de un equipo
    def equipo(nombre)
        raise "Necesaria implementación del método"
    end
end