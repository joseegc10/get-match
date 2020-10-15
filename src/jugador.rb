require_relative "equipo.rb"

class Jugador
	def initialize(nombre, equipo)
        @nombre = nombre
        @equipo = equipo
	end

	attr_reader :nombre
	attr_reader :equipo
	
	def cambiaEquipo(nuevoEquipo)
        raise ArgumentError, 'El parámetro no es un equipo' unless nuevoEquipo.is_a? Equipo
		@equipo = nuevoEquipo
	end
end