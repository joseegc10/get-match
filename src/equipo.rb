require_relative "jugador.rb"

# Clase que representa un equipo de fútbol

class Equipo
    # Un equipo vendrá identificado por:
    #      - Nombre del equipo
    #      - Jugadores que forman el equipo

    def initialize(nombre)
        @nombre = nombre
        @jugadores = Array.new
    end

    # Métodos get de los atributos
    attr_reader :nombre
    attr_reader :jugadores

    # Método que añade un jugador al equipo
    def aniadeJugador(jugador)
        raise ArgumentError, 'El parámetro no es un jugador' unless jugador.is_a? Jugador

        @jugadores << jugador
    end

    # Método que añade un conjunto de jugadores al equipo
    def aniadeJugadores(nuevosJugadores)
        raise ArgumentError, 'El parámetro no es un array de jugadores' unless nuevosJugadores.is_a? Array

        for jugador in nuevosJugadores
            raise ArgumentError, 'El parámetro no es un array de jugadores' unless jugador.is_a? Jugador
            @jugadores << jugador
        end
    end

    # Método que devuelve el nombre de los jugadores de un equipo
    # separados por ,
    def sacaJugadores
        nombreJugadores = Array.new

        for jugador in @jugadores
            nombreJugadores << jugador.nombre
        end

        nombres = nombreJugadores.join(", ")

        return nombres
    end
end