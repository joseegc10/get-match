# Clase que representa un partido de fútbol

class Partido
    # Un partido vendrá identificado por:
    #      - Equipo local
    #      - Equipo visitante
    #      - Fecha del partido
    #      - Goleadores

    def initialize(local, visitante, fecha)
        @local = local
        @visitante = visitante
        @fecha = fecha
        @goleadores = Array.new
    end

    # Métodos get de los atributos
    attr_reader :local
    attr_reader :visitante
    attr_reader :fecha
    attr_reader :goleadores

    # Método que añade un goleador al array de goleadores
    def aniadeGoleador(goleador)
        
    end
end