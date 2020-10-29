require_relative "partido.rb"

# Clase que representa una jornada de fútbol

class Jornada
	# Una jornada vendrá identificado por:
    #      - Número de jornada
    #      - Fecha en la que comienza
    #      - Lista de partidos que se juegan en la jornada
	
	def initialize(numero, fechaInicio)
        @numero = numero
        @fechaInicio = fechaInicio
        @partidos = Array.new
	end

	attr_reader :numero
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
end