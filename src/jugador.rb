require_relative "equipo.rb"

# Clase que representa un jugador de fútbol

class Jugador
	# Un jugador vendrá identificado por:
    #      - Nombre del jugador
	#      - Equipo del jugador
	
	def initialize(nombre, equipo)
        @nombre = nombre
        @equipo = equipo
	end

	attr_reader :nombre
	attr_reader :equipo
	
	# Método que cambia el equipo en el que juega un jugador
	def cambiaEquipo(nuevoEquipo)
        raise ArgumentError, 'El parámetro no es un equipo' unless nuevoEquipo.is_a? Equipo
		@equipo = nuevoEquipo
	end 
end