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
        raise ArgumentError, 'El parámetro no es un Jugador' unless goleador.is_a? Jugador

        @goleadores << goleador
    end

    # Método que añade un conjunto de goleadores al partido
    def aniadeGoleadores(nuevosGoleadores)
        raise ArgumentError, 'El parámetro no es un array de jugadores' unless nuevosGoleadores.is_a? Array

        for goleador in nuevosGoleadores
            raise ArgumentError, 'El parámetro no es un array de jugadores' unless goleador.is_a? Jugador
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

    # Método que saca el nombre de los jugadores que han metido gol en el partido
    # HU2: consulta de goleadores
    def sacaGoleadores
        nombreGoleadores = Array.new

        for goleador in @goleadores
            nombreGoleadores << goleador.nombre
        end

        nombres = nombreGoleadores.join(", ")

        return nombres
    end

    # Método que calcula el máximo goleador de un partido
    # Se corresponde con la HU4: consultar el máximo goleador de un partido
    def maximoGoleador
        maximoGoleador = ''
        max_apariciones = 0

        for i in (0..(@goleadores.length)-1) do
            a_buscar = @goleadores[i].nombre
            num_apariciones = 1
            
            for j in (i+1..(@goleadores.length)-1) do
                if a_buscar == @goleadores[j].nombre
                    num_apariciones += 1
                end
            end

            if num_apariciones > max_apariciones
                max_apariciones = num_apariciones
                maximoGoleador = a_buscar
            end
        end

        return maximoGoleador
    end
end