require_relative "jsonify.rb"
require_relative "../config/config.rb"
require_relative './dator'
require 'firebase'
require 'json'
require 'date'

#######################################################################

# Clase que almacena una liga de futbol en una base de datos leída desde un fichero JSON

conf = configuracion()

NUM_MAX_EQUIPOS = conf["NUM_MAX_EQUIPOS"]
URI_DATABASE = conf["URI_DATABASE"]
SECRET_DATABASE = conf["SECRET_DATABASE"]

#######################################################################

class FirebaseDator < Dator
    def initialize()
        @database = Firebase::Client.new(URI_DATABASE, SECRET_DATABASE)
        @jsonify = Jsonify.new()

        ligaJSON = @database.get('').body
        if ligaJSON
            keys = ligaJSON.keys
            if keys.include?('jornadas')
                liga = @jsonify.jsonToLiga(ligaJSON)
                @clasificacion = liga.clasificacion
                @rankingGoleadores = liga.rankingGoleadores
                @timeCache = DateTime.now
            end
        end
    end

    #######################################################################

    # METODOS AUXILIARES

    def buscaEquipo(equipos, nombreEquipo)
        equipo = nil
        for e in equipos
            if e.nombre == nombreEquipo
                equipo = e
            end
        end

        if equipo
            return equipo
        else
            raise ArgumentError, 'Ese equipo no pertenece a la liga'
        end
    end

    def respuestaCorrectaBD(json)
        if json.is_a?(Hash) and json.keys.size != 0
            return true
        else
            return false
        end
    end

    def actualizaCache()
        timeActual = DateTime.now
        diferencia = (timeActual - @timeCache)

        if (diferencia*24*60).to_i >= 0
            ligaJSON = @database.get('').body
            if ligaJSON
                keys = ligaJSON.keys
                if keys.include?('jornadas')
                    liga = @jsonify.jsonToLiga(ligaJSON)
                    @clasificacion = liga.clasificacion
                    @rankingGoleadores = liga.rankingGoleadores
                    @timeCache = DateTime.now
                end
            end
        end
    end

    def jornadaBD(numJornada)
        equiposJSON = @database.get('equipos').body

        if respuestaCorrectaBD(equiposJSON)
            equipos = @jsonify.jsonToEquipos(equiposJSON)
        else
            raise ArgumentError, "No existe ningún equipo en la liga"
        end

        jornadaJSON = @database.get("jornadas/#{numJornada}").body
        nuevoJSON = []

        if respuestaCorrectaBD(jornadaJSON)
            keys = jornadaJSON.keys
            for k in keys
                nuevoJSON << jornadaJSON[k]
            end
            jornada, numJornada = @jsonify.jsonToJornada(nuevoJSON, equipos)
        else
            raise ArgumentError, "No existe la jornada #{numJornada}"
        end

        return jornada
    end

    def jornadaEquipoBD(numJornada, nombreEquipo)
        equiposJSON = @database.get('equipos').body

        if respuestaCorrectaBD(equiposJSON)
            equipos = @jsonify.jsonToEquipos(equiposJSON)
            equipo = buscaEquipo(equipos, nombreEquipo)
        else
            raise ArgumentError, "No existe ningún equipo en la liga"
        end

        jornadaJSON = @database.get("jornadas/#{numJornada}").body
        nuevoJSON = []

        if respuestaCorrectaBD(jornadaJSON)
            keys = jornadaJSON.keys
            for k in keys
                nuevoJSON << jornadaJSON[k]
            end
            jornada, numJornada = @jsonify.jsonToJornada(nuevoJSON, equipos)
        else
            raise ArgumentError, "No existe la jornada #{numJornada}"
        end

        return [jornada, equipo]
    end

    #######################################################################

    # HISTORIAS DE USUARIO

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    def resultadoPartido(numJornada, nombreEquipo)
        jornada, equipo = jornadaEquipoBD(numJornada, nombreEquipo)

        resultado = jornada.calculaResultado(equipo)

        return resultado
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    def goleadoresPartido(numJornada, nombreEquipo)
        jornada, equipo = jornadaEquipoBD(numJornada, nombreEquipo)

        goleadores = jornada.goleadoresPartido(equipo)

        return goleadores
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    def diasPartido(numJornada, nombreEquipo)
        jornada, equipo = jornadaEquipoBD(numJornada, nombreEquipo)

        dias = jornada.diasPartido(equipo)

        return dias
    end

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    def maximoGoleadorPartido(numJornada, nombreEquipo)
        jornada, equipo = jornadaEquipoBD(numJornada, nombreEquipo)

        goleador_goles = jornada.maxGoleadorPartido(equipo)

        return goleador_goles
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    def partidosJornada(numJornada)
        jornada = jornadaBD(numJornada)

        return jornada.partidos
    end

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    def diasJornada(numJornada)
        jornada = jornadaBD(numJornada)

        dias = jornada.diasPara_DesdeLaJornada()

        return dias
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    def maxGoleadorJornada(numJornada)
        jornada = jornadaBD(numJornada)

        goleador_goles = jornada.maximoGoleadorJornada()

        return goleador_goles
    end

    # HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
    def equipoMaxGoleadorJornada(numJornada)
        jornada = jornadaBD(numJornada)

        equipo_goles = jornada.equipoMasGoleador()

        return equipo_goles
    end

    # HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
    def equiposLiga()
        equiposJSON = @database.get("equipos/").body
        if respuestaCorrectaBD(equiposJSON)
            equipos = @jsonify.jsonToEquipos(equiposJSON)
        else
            raise ArgumentError, "No se ha añadido ningún equipo a la liga"
        end

        return equipos
    end

    # HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
    def rankingGoleadores()
        actualizaCache()
        if @rankingGoleadores
            return @rankingGoleadores
        else
            raise ArgumentError, 'No existe ninguna jornada en la liga'
        end
    end

    # HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
    def clasificacionLiga()
        actualizaCache()
        if @clasificacion
            return @clasificacion
        else
            raise ArgumentError, 'No existe ninguna jornada en la liga'
        end
    end

    # HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
    def golesEquipo(nombreEquipo)
        nombreEquipos = Array.new

        for equipo_puntos_goles in @clasificacion
            nombreEquipos << equipo_puntos_goles.equipo.nombre
        end

        indice = nombreEquipos.index(nombreEquipo)

        if indice
            return @clasificacion[indice].goles
        else
            raise ArgumentError, 'El equipo no pertenece a la liga'
        end
    end

    # HU14: Como usuario, quiero poder añadir un equipo a una liga
    def aniadeEquipo(equipoJSON)
        equiposJSON = @database.get('equipos').body

        if equiposJSON and equiposJSON.keys.size == NUM_MAX_EQUIPOS
            raise ArgumentError, 'La liga tiene el número máximo de equipos'
        end

        query = {
            :orderBy => '"name"',
            :equalTo => '"' + equipoJSON["name"] + '"'
        }

        buscaEquipoJSON = @database.get('equipos', query).body
        p buscaEquipoJSON

        if respuestaCorrectaBD(buscaEquipoJSON)
            raise ArgumentError, "El equipo #{equipoJSON["name"]} ya existe en la liga"
        else
            @database.push('equipos/', equipoJSON)
        end
    end

    # HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
    def aniadePartido(partido, partidoJSON, numJornada)
        equiposJSON = @database.get('equipos').body

        if respuestaCorrectaBD(equiposJSON)
            equipos = @jsonify.jsonToEquipos(equiposJSON)
        else
            raise ArgumentError, "No existe ningún equipo en la liga"
        end

        # Comprobar que el partido cumple las condiciones para poder ser añadido
        jornadaJSON = @database.get("jornadas/#{numJornada}").body

        if respuestaCorrectaBD(jornadaJSON)
            keys = jornadaJSON.keys
            nuevoJSON = []
            for k in keys
                nuevoJSON << jornadaJSON[k]
            end
            jornada, num = @jsonify.jsonToJornada(nuevoJSON, equipos)
            participan = jornada.participan(partido.local.nombre, partido.visitante.nombre)
            if participan
                raise ArgumentError, 'En el partido participa un equipo que ya esta en la jornada'
            end
        else
            raise ArgumentError, "La jornada #{numJornada} no existe"
        end

        @database.push("jornadas/#{numJornada}", partidoJSON)
    end
    # Prueba: {"round":"Jornada 1","date":"2020-12-1","team1":"Valencia CF","team2":"Granada CF","score":{"ft":[0,1],"scorers":[{"team":"Granada CF","name":"Luis Milla"}]}}

    # HU16: Como usuario, quiero poder añadir una jornada a una liga 
    def aniadeJornada(jornada, jornadaJSON, numJornada)
        equiposJSON = @database.get('equipos').body

        if respuestaCorrectaBD(equiposJSON)
            equipos = @jsonify.jsonToEquipos(equiposJSON)
        else
            raise ArgumentError, "No existe ningún equipo en la liga"
        end

        # Comprobar que la jornada cumple las condiciones para poder ser añadida
        jornadaJSON_antes = @database.get("jornadas/#{numJornada}").body

        if respuestaCorrectaBD(jornadaJSON_antes)
            raise ArgumentError, "La jornada #{numJornada} ya existe"
        else
            jorn = Jornada.new()
            for j in jornadaJSON
                # Comprobamos que el partido se puede añadir
                partido, jor = @jsonify.jsonToPartido(j, equipos)
                jorn.aniadePartido(partido)

                # Añaimos el partido a la jornada
                @database.push("jornadas/#{numJornada}", j)
            end
        end
    end
    # Prueba: {[{"round":"Jornada 1","date":"2020-12-1","team1":"Real Madrid","team2":"Sevilla FC","score":{"ft":[1,0],"scorers":[{"team":"Real Madrid","name":"Sergio Ramos"}]}},{"round":"Jornada 1","date":"2020-12-2","team1":"FC Barcelona","team2":"Atletico Madrid","score":{"ft":[1,2],"scorers":[{"team":"FC Barcelona","name":"Leo Messi"},{"team":"Atletico Madrid","name":"Joao Felix"},{"team":"Atletico Madrid","name":"Joao Felix"}]}}]

    # HU19: Como usuario, quiero poder resetear la liga 
    def reseteaLiga()
        @database.delete('')
    end

    # HU20: Como usuario, debo poder acceder a la información de un equipo
    def equipo(nombre)
        query = {
            :orderBy => '"name"',
            :equalTo => '"' + nombre + '"'
        }

        equipoJSON = @database.get('equipos', query).body

        if respuestaCorrectaBD(equipoJSON)
            keys = equipoJSON.keys
            equipo = @jsonify.jsonToEquipo(equipoJSON[keys[0]])

            return equipo
        else
            raise ArgumentError, "El equipo #{nombre} no existe en la liga"
        end
    end
end