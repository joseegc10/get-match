require_relative "jugador.rb"
require_relative "equipo.rb"
require 'date'

# Struct para el resultado del partido
Resultado = Struct.new(:golesLocal, :golesVisitante, :equipoLocal, :equipoVisitante)

# Struct para el par Goleador-número de goles
Goleador_Goles = Struct.new(:goleador, :goles)

# Clase que representa un partido de fútbol

class Partido
    # Un partido vendrá identificado por:
    #      - Equipo local
    #      - Equipo visitante
    #      - Fecha del partido
    #      - Goleadores
    #      - Resultado del partido

    def initialize(local, visitante, fecha, resultado=nil)
        @local = local
        @visitante = visitante
        @fecha = fecha

        @resultado = resultado

        @goleadores = Array.new
    end

    # Métodos get de los atributos
    attr_reader :local
    attr_reader :visitante
    attr_reader :fecha
    attr_reader :goleadores   # HU2: consulta de goleadores

    # Método que añade un goleador al array de goleadores a partir de su nombre y del nombre del equipo
    def aniadeGoleadorNombre(nombreGoleador, nombreEquipo)
        if nombreEquipo == @local.nombre
            jugadores = @local.jugadores
        elsif nombreEquipo == @visitante.nombre
            jugadores = @visitante.jugadores
        else
            raise ArgumentError, 'El nombre del equipo no corresponde con un equipo del partido'
        end

        goleador = nil
        for jugador in jugadores
            if jugador.nombre == nombreGoleador
                goleador = jugador
            end
        end

        if goleador
            @goleadores << goleador
        else
            raise ArgumentError, 'El nombre del goleador no corresponde con un jugador del partido'
        end
    end

    # Método que añade un goleador al array de goleadores
    def aniadeGoleador(goleador)
        raise ArgumentError, 'El parámetro no es un Jugador' unless goleador.is_a? Jugador

        if (not @resultado)
            @resultado = Resultado.new(0,0,@local.nombre,@visitante.nombre)
        end

        if (goleador.equipo.nombre == @local.nombre)
            @resultado.golesLocal += 1
        elsif (goleador.equipo.nombre == @visitante.nombre)
            @resultado.golesVisitante += 1
        else
            raise ArgumentError, 'Hay al menos un goleador de un equipo que no juega el partido'
        end

        @goleadores << goleador
    end

    # Método que añade un conjunto de goleadores al partido
    def aniadeGoleadores(nuevosGoleadores)
        raise ArgumentError, 'El parámetro no es un array de jugadores' unless nuevosGoleadores.is_a? Array

        if (not @resultado)
            @resultado = Resultado.new(0,0,@local.nombre,@visitante.nombre)
        end

        for goleador in nuevosGoleadores
            raise ArgumentError, 'El parámetro no es un array de jugadores' unless goleador.is_a? Jugador
    
            if (goleador.equipo.nombre == @local.nombre)
                @resultado.golesLocal += 1
            elsif (goleador.equipo.nombre == @visitante.nombre)
                @resultado.golesVisitante += 1
            else
                raise ArgumentError, 'Hay al menos un goleador de un equipo que no juega el partido'
            end

            @goleadores << goleador
        end
    end

    # Método que calcula el resultado de un partido teniendo en cuenta los goleadores
    # Se corresponde con la HU1: consulta del resultado de un partido
    def calculaResultado
        if @resultado
            return @resultado
        else
            raise ArgumentError, 'El partido que piden no ha sido jugado'
        end
    end

    # Método que calcula el número de días que quedan para el partido
    # Se corresponde con la HU3: consultar del tiempo que queda para que empiece un partido
    def diasPara_DesdeElPartido
        return (@fecha - Date.today).to_i
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
    def maxGoleador
        maximoGoleador = nil
        max_apariciones = 0

        if not @resultado
            raise ArgumentError, 'Ese equipo no ha jugado dicha jornada'
        end

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
                maximoGoleador = @goleadores[i]
            end
        end

        goleador_goles = Goleador_Goles.new(maximoGoleador, max_apariciones)
        return goleador_goles
    end
end