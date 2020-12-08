require_relative "jugador.rb"
require_relative "equipo.rb"
require_relative "partido.rb"

# Struct para el par Equipo-puntos
Equipo_Puntos_Goles = Struct.new(:equipo, :puntos, :goles)

# Clase que representa una liga de fútbol

class Liga
    # Una liga vendrá identificado por:
    #      - Lista de equipos de la liga
    #      - Lista de jornadas de la liga
    #      - Ranking de goleadores de la liga
    #      - Clasificación de la liga
    #      - Nombre de la liga

    def initialize(equipos, nombreLiga)
        @equipos = equipos
        @jornadas = Array.new
        @rankingGoleadores = Array.new

        @nombreLiga = nombreLiga

        @clasificacion = Array.new
        inicializaClasificacion()
    end

    attr_reader :equipos
    attr_reader :jornadas
    attr_reader :rankingGoleadores
    attr_reader :clasificacion
    attr_reader :nombreLiga

    def buscaEquipo(nombreEquipo)
        for e in @equipos
            if e.nombre == nombreEquipo
                return e
            end
        end

        return nil
    end

    def inicializaClasificacion()
        for equipo in @equipos
            nuevoEquipo = Equipo_Puntos_Goles.new(equipo, 0, 0)
            @clasificacion << nuevoEquipo
        end
    end

    def numGolesEquipo(equipo)
        raise ArgumentError, 'El parámetro no es un equipo' unless equipo.is_a? Equipo

        # Comprobamos que el equipo pertenece a la liga
        encontrado = buscaEquipo(equipo.nombre)

        if !encontrado
            raise ArgumentError, 'El parámetro no es un equipo de la liga'
        end

        nombreEquipos = Array.new

        for equipo_puntos_goles in @clasificacion
            nombreEquipos << equipo_puntos_goles.equipo.nombre
        end

        indice = nombreEquipos.index(equipo.nombre)

        return @clasificacion[indice].goles
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
                    # Sumamos un gol al goleador
                    nuevoGoleador = @rankingGoleadores[indice]
                    @rankingGoleadores.delete_at(indice)
                    nuevoGoleador.goles += 1

                    pos = 0
                    salir = false

                    while pos < @rankingGoleadores.length and !salir
                        if @rankingGoleadores[pos].goles < nuevoGoleador.goles
                            salir = true
                            @rankingGoleadores.insert(pos, nuevoGoleador)
                        end

                        pos += 1
                    end

                    if !salir
                        @rankingGoleadores << nuevoGoleador
                    end
                else
                    # Creamos el par goleador_goles porque ese goleador ha marcado su primer gol en la liga
                    nuevoGoleador = Goleador_Goles.new(goleador, 1)
                    @rankingGoleadores << nuevoGoleador
                    nombreGoleadores << nuevoGoleador.goleador.nombre
                end
            end
        end
    end

    def actualizaClasificacion(partidos)
        nombreEquipos = Array.new

        for equipo_puntos_goles in @clasificacion
            nombreEquipos << equipo_puntos_goles.equipo.nombre
        end

        for partido in partidos
            begin
                resultado = partido.calculaResultado()
                golesLocal = resultado.golesLocal
                golesVisitante = resultado.golesVisitante
                jugado = true
            rescue
                jugado = false
            end

            if (jugado)
                # Añado los goles a cada equipo
                indiceLocal = nombreEquipos.index(partido.local.nombre)
                indiceVisitante = nombreEquipos.index(partido.visitante.nombre)

                @clasificacion[indiceLocal].goles += golesLocal
                @clasificacion[indiceVisitante].goles += golesVisitante

                if golesLocal != golesVisitante # Hay un ganador
                    if golesLocal > golesVisitante
                        ganador = partido.local
                        indice = indiceLocal
                    else
                        ganador = partido.visitante
                        indice = indiceVisitante
                    end
        
                    # Sumamos tres puntos al equipo ganador
                    nuevoEquipo = @clasificacion[indice]
                    @clasificacion.delete_at(indice)
                    nuevoEquipo.puntos += 3
        
                    pos = 0
                    salir = false
        
                    while pos < @clasificacion.length and !salir
                        if (@clasificacion[pos].puntos < nuevoEquipo.puntos) or 
                            (@clasificacion[pos].puntos == nuevoEquipo.puntos and @clasificacion[pos].goles < nuevoEquipo.goles)
                            salir = true
                            @clasificacion.insert(pos, nuevoEquipo)
                        end
        
                        pos += 1
                    end
                else # Empate

                    # Sumamos un punto al equipo local
                    indice = nombreEquipos.index(partido.local.nombre)
                    nuevoEquipo = @clasificacion[indice]
                    @clasificacion.delete_at(indice)
                    nuevoEquipo.puntos += 1
        
                    pos = 0
                    salir = false
        
                    while pos < @clasificacion.length and !salir
                        if (@clasificacion[pos].puntos < nuevoEquipo.puntos) or 
                            (@clasificacion[pos].puntos == nuevoEquipo.puntos and @clasificacion[pos].goles < nuevoEquipo.goles)
                            salir = true
                            @clasificacion.insert(pos, nuevoEquipo)
                        end
        
                        pos += 1
                    end

                    if !salir
                        @clasificacion << nuevoEquipo
                    end

                    # Sumamos un punto al equipo visitante
                    indice = nombreEquipos.index(partido.visitante.nombre)
                    nuevoEquipo = @clasificacion[indice]
                    @clasificacion.delete_at(indice)
                    nuevoEquipo.puntos += 1
        
                    pos = 0
                    salir = false
        
                    while pos < @clasificacion.length and !salir
                        if (@clasificacion[pos].puntos < nuevoEquipo.puntos) or 
                            (@clasificacion[pos].puntos == nuevoEquipo.puntos and @clasificacion[pos].goles < nuevoEquipo.goles)
                            salir = true
                            @clasificacion.insert(pos, nuevoEquipo)
                        end
        
                        pos += 1
                    end

                    if !salir
                        @clasificacion << nuevoEquipo
                    end
                end
            end
        end
    end

    def aniadeJornada(jornada, numJornada)
        if numJornada != @jornadas.size
            raise ArgumentError, 'Número de jornada incorrecta'
        end

        for partido in jornada.partidos
            local = buscaEquipo(partido.local.nombre)
            visitante = buscaEquipo(partido.visitante.nombre)

            if !local or !visitante
                raise ArgumentError, 'Hay un partido que lo juega un equipo que no participa en la liga'
            end
        end

        @jornadas << jornada
        actualizaRanking(jornada.partidos)
        actualizaClasificacion(jornada.partidos)
    end

    def resultadoPartido(numJornada, equipo)
        if numJornada < @jornadas.size and numJornada >= 0
            jornada = @jornadas[numJornada]
        else
            raise ArgumentError, 'La jornada introducida no se ha jugado'
        end

        resultado = jornada.calculaResultado(equipo)

        return resultado
    end

    def goleadoresPartido(numJornada, equipo)
        if numJornada < @jornadas.size and numJornada >= 0
            jornada = @jornadas[numJornada]
        else
            raise ArgumentError, 'La jornada introducida no se ha jugado'
        end

        goleadores = jornada.goleadoresPartido(equipo)

        return goleadores
    end
end