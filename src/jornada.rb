require_relative "partido.rb"

# Clase que representa una jornada de fútbol

class Jornada
	# Una jornada vendrá identificado por:
    #      - Fecha en la que comienza
    #      - Lista de partidos que se juegan en la jornada
	
	def initialize(fechaInicio)
        @fechaInicio = fechaInicio
        @partidos = Array.new
	end

    attr_reader :fechaInicio
    attr_reader :partidos
    
    # Método que añade un partido al array de partidos
    def aniadePartido(partido)
        raise ArgumentError, 'El parámetro no es un partido' unless partido.is_a? Partido

        @partidos << partido
    end

	# Método que añade un conjunto de partidos a la jornada
    def aniadePartidos(nuevosPartidos)
        raise ArgumentError, 'El parámetro no es un array de partidos' unless nuevosPartidos.is_a? Array

        for partido in nuevosPartidos
            raise ArgumentError, 'El parámetro no es un array de partidos' unless partido.is_a? Partido
            @partidos << partido
        end
    end

    # Método que calcula el número de días que quedan para la jornada
    # Se corresponde con la HU7: consultar el tiempo que queda para que empiece una jornada o desde que empezó
    def diasPara_DesdeLaJornada
        return (@fechaInicio - Date.today)
    end

    def maximoGoleadorJornada
        maxGoles = 0
        maxGoleador = ""

        for partido in @partidos
            maxGoleadorPartido, goles = partido.maximoGoleador()

            if goles > maxGoles
                maxGoles = goles
                maxGoleador = maxGoleadorPartido
            end
        end

        return maxGoleador, maxGoles
    end

    def equipoMasGoleador
        maxGoles = 0
        maxEquipo = ""

        for partido in @partidos
            golesLocal, golesVisitante = partido.calculaResultado()

            if golesLocal > maxGoles
                maxGoles = golesLocal
                maxEquipo = partido.local
            end

            if golesVisitante > maxGoles
                maxGoles = golesVisitante
                maxEquipo = partido.visitante
            end
        end

        return [maxEquipo, maxGoles]
    end
end