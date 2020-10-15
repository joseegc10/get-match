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
        @jugadores << jugador
    end

    # Método que añade un conjunto de jugadores al equipo
    def aniadeJugadores(nuevosJugadores)
        for jugador in nuevosJugadores
            @jugadores << jugador
        end
    end

    def sacaJugadores
        nombreJugadores = Array.new

        for jugador in @jugadores
            nombreJugadores << jugador.nombre
        end

        nombres = nombreJugadores.join(", ")

        return nombres
    end
end