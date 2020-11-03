require_relative "jugador.rb"
require_relative "equipo.rb"
require_relative "partido.rb"

# Struct para el par Equipo-puntos
Equipo_Puntos = Struct.new(:equipo, :puntos)

# Struct para el par Goleador-número de goles
Goleador_Goles = Struct.new(:goleador, :goles)


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
        inicializaClasificacion()
    end

    def inicializaClasificacion()
        for equipo in @equipos
            nuevoEquipo = Equipo_Puntos.new(equipo, 0)
            @clasificacion << nuevoEquipo
        end
    end

    def actualizaRanking(partidos)
        nombreGoleadores = Array.new

        for goleador_goles in @rankingGoleadores
            nombreGoleadores << goleador_goles.goleador.nombre
        end

        for partido in partidos

            for goleador in partido.goleadores
                indice = nombreGoleadores.index(goleador.nombre)
                if indice
                    nuevoGoleador = rankingGoleadores[indice]
                    rankingGoleadores.delete_at(indice)
                    nuevoGoleador.goles += 1

                    pos = 0
                    salir = false

                    while pos < rankingGoleadores.length and !salir
                        if rankingGoleadores[pos].goles < nuevoGoleador.goles
                            salir = true
                            rankingGoleadores.insert(pos, nuevoGoleador)
                        end

                        pos += 1
                    end
                else
                    nuevoGoleador = Goleador_Goles.new(goleador, 1)
                    rankingGoleadores << nuevoGoleador
                end
            end
        end
    end

    def actualizaClasificacion(partidos)

    end

    def aniadeJornada(jornada)
        raise ArgumentError, 'El parámetro no es un array de partidos' unless jornada.is_a? Array

        for partido in jornada.partidos
            raise ArgumentError, 'El parámetro no es un array de partidos' unless partido.is_a? Partido
        end

        @jornadas << jornada

        actualizaRanking(jornada.partidos)
        actualizaClasificacion(jornada.partidos)
    end
end