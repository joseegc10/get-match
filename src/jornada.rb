require_relative "partido.rb"

# Struct para el par Equipo-número de goles
Equipo_Goles = Struct.new(:equipo, :goles)

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
        maxGoleador = nil

        for partido in @partidos
            begin
                goleador_goles = partido.maxGoleador

                if goleador_goles.goles > maxGoles
                    maxGoles = goleador_goles.goles
                    maxGoleador = goleador_goles
                end 
            rescue
            end
        end

        if maxGoleador
            return maxGoleador
        else
            raise ArgumentError, 'La jornada introducida no se ha jugado'
        end
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

    def equipoMasGoleador
        maxGoles = 0
        maxEquipo = nil

        for partido in @partidos
            begin
                resultado = partido.calculaResultado()
                golesLocal = resultado.golesLocal
                golesVisitante = resultado.golesVisitante

                if golesLocal > maxGoles
                    maxGoles = golesLocal
                    maxEquipo = partido.local
                end

                if golesVisitante > maxGoles
                    maxGoles = golesVisitante
                    maxEquipo = partido.visitante
                end
            rescue
            end
        end

        if maxEquipo
            equipo_goles = Equipo_Goles.new(maxEquipo, maxGoles)
            return equipo_goles
        else
            raise ArgumentError, "Dicha jornada no se ha jugado"
        end
    end

    def calculaResultado(equipo)
        raise ArgumentError, 'El parámetro no es un equipo' unless equipo.is_a? Equipo

        for partido in @partidos
            if partido.local.nombre == equipo.nombre or partido.visitante.nombre == equipo.nombre
                resultado = partido.calculaResultado

                return resultado
            end
        end

        raise ArgumentError, 'Ese equipo no ha jugado dicha jornada'
    end

    def goleadoresPartido(equipo)
        raise ArgumentError, 'El parámetro no es un equipo' unless equipo.is_a? Equipo

        for partido in @partidos
            if partido.local.nombre == equipo.nombre or partido.visitante.nombre == equipo.nombre
                goleadores = partido.goleadores

                return goleadores
            end
        end

        raise ArgumentError, 'Ese equipo no ha jugado dicha jornada'
    end
end