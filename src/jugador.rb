class Jugador
	def initialize(nombre, equipo)
        @nombre = nombre
        @equipo = equipo
	end

	attr_reader :nombre
	attr_reader :equipo
	
	def cambiaEquipo(nuevoEquipo)
		@equipo = nuevoEquipo
	end
end