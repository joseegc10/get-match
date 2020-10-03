class Partido
    def initialize(local, visitante, fecha)
        @local = local
        @visitante = visitante
        @fecha = fecha
        @goleadores = Array.new
    end

    attr_reader :local
    attr_reader :visitante
    attr_reader :fecha

    def aniadeGoleador(goleador)
        goleadores << goleador
    end
end