require_relative "jugador.rb"
require_relative "equipo.rb"
require_relative "partido.rb"

# Struct para el par Equipo-puntos
Equipo-Puntos = Struct.new(:equipo, :puntos)

# Struct para el par Goleador-número de goles
Goleador-Goles = Struct.new(:goleador, :goles)


# Clase que representa una liga de fútbol

class Liga
    # Una liga vendrá identificado por:
    #      - Lista de equipos de la liga
    #      - Lista de jornadas de la liga
    #      - Ranking de goleadores de la liga
    #      - Clasificación de la liga

    def initialize(equipos)
        @equipos = equipos
        @jornadas = Array.new
        @rankingGoleadores = Array.new
        @clasificacion = Array.new
    end
end