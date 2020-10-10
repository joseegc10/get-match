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
    attr_reader :goleadores   # HU2: consulta de goleadores

    # Método que añade un goleador al array de goleadores
    def aniadeGoleador(goleador)
        
    end

    # Método que calcula el resultado de un partido teniendo en cuenta los goleadores
    # Se corresponde con la HU1: consulta del resultado de un partido
    def calculaResultado

    end
end