require 'json'
require 'net/https'
require 'date'

TOKEN = ENV['TG_TOKEN']

def cargaDatos()
    url = 'https://raw.githubusercontent.com/openfootball/football.json/master/2020-21/es.1.json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    partidos = JSON.parse(response)
  
    url = 'https://raw.githubusercontent.com/openfootball/football.json/master/2020-21/es.1.clubs.json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    equipos = JSON.parse(response)["clubs"]
    nombresEquipos = []
  
    for equipo in equipos
        nombresEquipos << equipo["name"]
    end
  
    return [partidos, nombresEquipos]
end

def calculaResultado(partidos, equipo, jornada)
    # Última jornada
    if (jornada == -1) 
        minimaDiferencia = Float::INFINITY
    
        # Calculo el partido jugado más cercano a la fecha actual
        for partido in partidos["matches"]
            # Si el equipo participa en el partido y dicho partido está jugado
            if (partido["team1"] == equipo or partido["team2"] == equipo) and partido["score"]
                # Calculo el número de días hasta el partido
                nuevaFecha = Date.parse partido["date"]
                diferencia = Date.today - nuevaFecha
        
                # Si el partido es más cercano que el más cercano actual
                if diferencia < minimaDiferencia and diferencia >= 0
                    minimaDiferencia = diferencia
                    golesLocal = partido["score"]["ft"][0]
                    golesVisitante = partido["score"]["ft"][1]
                    equipoLocal = partido["team1"]
                    equipoVisitante = partido["team2"]
                end
            end
        end
    
        # Si hay un partido jugado, devuelve el resultado, sino, lo notifica
        if minimaDiferencia != Float::INFINITY
            if golesLocal > golesVisitante
                msg = "En la última jornada, el equipo #{equipoLocal} le ganó #{golesLocal} a #{golesVisitante} al equipo #{equipoVisitante}."
                return msg
            elsif golesLocal < golesVisitante
                msg = "En la última jornada, el equipo #{equipoVisitante} le ganó #{golesVisitante} a #{golesLocal} al equipo #{equipoLocal}."
                return msg
            else
                msg = "En la última jornada, se produjo un empate entre el equipo #{equipoLocal} y el equipo #{equipoVisitante}."
                return msg
            end
        else
            msg = "El equipo #{equipo} no ha disputado la última jornada."
            return msg
        end
  
    # Jornada dada
    else
        # Busco el partido de dicha jornada en el que participó el equipo dado
        for partido in partidos["matches"]
            # Si el equipo participó en el partido y dicho partido pertenece a la jornada dada
            if (partido["team1"] == equipo or partido["team2"] == equipo) and partido["round"] == "Jornada #{jornada}"
                # Si está jugado el partido devolvemos el resultado
                if (partido["score"])
                    golesLocal = partido["score"]["ft"][0]
                    golesVisitante = partido["score"]["ft"][1]
                    
                    if golesLocal > golesVisitante
                        msg = "El equipo #{partido["team1"]} le ganó #{golesLocal} a #{golesVisitante} al equipo #{partido["team2"]}."
                        return msg
                    elsif golesLocal < golesVisitante
                        msg = "El equipo #{partido["team2"]} le ganó #{golesVisitante} a #{golesLocal} al equipo #{partido["team1"]}."
                        return msg
                    else
                        msg = "Se produjo un empate entre el equipo #{partido["team1"]} y el equipo #{partido["team2"]}."
                        return msg
                    end
                # Si no está jugado, lo notificamos
                else
                    msg = "El equipo #{equipo} no ha disputado la Jornada #{jornada}."
                    return msg
                end
            end
        end
  
        # Si no encuentra el equipo o la jornada
        msg = "El equipo #{equipo} no ha disputado la Jornada #{jornada}."
        return msg
    end
end

def unePalabras(palabras)
    union = ""
  
    if (palabras.size > 0)
        i = 0
    
        while i < palabras.size-1
            union += palabras[i]
            union += " "
            i += 1
        end
    
        union += palabras[i]
    end
  
    return union
end

def getMatch(event:, context:)
    begin
        data = JSON.parse(event["body"])
        message = data["message"]["text"]
        chat_id = data["message"]["chat"]["id"]
        first_name = data["message"]["chat"]["first_name"]

        partidos, equipos = cargaDatos()

        palabras = message.split()
        comando = palabras[0]

        case comando
        when '/juega'
            url = 'https://get-match.joseegc10.vercel.app/api'
            uri = URI(url)
            response = Net::HTTP.get(uri)
            respuestaVercel = JSON.parse(response)

            msg = respuestaVercel["mensaje"]

        else
            mensajes = []
            mensajes << 'Bienvenido al bot para la consulta de la liga Española.'
            mensajes << 'Usa -- /equipos -- para consultar el nombre de los equipos de la liga Española.'
            mensajes << 'Usa -- /juega nombreEquipo -- para consultar cuántos días quedan para que juegue dicho equipo.'
            mensajes << 'Usa -- /resultado nombreEquipo jornada -- para saber el resultado de dicho equipo en dicha jornada.'
            
            msg = ""
            for mensaje in mensajes
                msg += mensaje
                msg += "\n"
            end
        end
    
        payload = {text: msg, chat_id: chat_id}
    
        uri = URI("https://api.telegram.org")
    
        Net::HTTP.start(uri.hostname, uri.port, {use_ssl: true}) do |http|
            req = Net::HTTP::Post.new("/bot#{TOKEN}/sendMessage", {'Content-Type' => 'application/json; charset=utf-8'})
            req.body = payload.to_json
            http.request(req)
        end
    rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
    end
  
    return { statusCode: 200 }
end