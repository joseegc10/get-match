require_relative "jsonify.rb"

# Clase que maneja una liga de futbol

class ManejaLiga
	# La clase para manejar la liga vendrá identificada por:
    #      - Liga creada
	
	def initialize()
        @jsonify = Jsonify.new()
        @liga = @jsonify.jsonToLiga('../sampledata/partidos.json', '../sampledata/equipos.json')
    end

    attr_reader :liga

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
end