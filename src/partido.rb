require_relative "jugador.rb"
require_relative "equipo.rb"
require 'date'

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
        @goleadores << goleador
    end

    # Método que añade un conjunto de goleadores al partido
    def aniadeGoleadores(nuevosGoleadores)
        for goleador in nuevosGoleadores
            @goleadores << goleador
        end
    end

    # Método que calcula el resultado de un partido teniendo en cuenta los goleadores
    # Se corresponde con la HU1: consulta del resultado de un partido
    def calculaResultado
        golesLocal = 0
        golesVisitante = 0

        for goleador in @goleadores

            if goleador.equipo.nombre == @local.nombre
                golesLocal += 1

            elsif goleador.equipo.nombre == @visitante.nombre
                golesVisitante += 1
                
            end 

        end

        return [golesLocal, golesVisitante]
    end

    # Método que calcula el número de días que quedan para el partido
    # Se corresponde con la HU3: consultar del tiempo que queda para que empiece un partido
    def diasPara_DesdeElPartido
        return (@fecha - Date.today)
    end
end