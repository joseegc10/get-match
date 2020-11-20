require 'net/http'
require 'json'
require 'date'

def cargaDatos()
    url = 'https://raw.githubusercontent.com/openfootball/football.json/master/2020-21/es.1.json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    partidos = JSON.parse(response)
  
    return partidos
end

def proximoPartido(partidos, equipo)
    minimaDiferencia = Float::INFINITY
  
    for partido in partidos["matches"]
        if (partido["team1"] == equipo or partido["team2"] == equipo) and not partido["score"]
            nuevaFecha = Date.parse partido["date"]
            diferencia = nuevaFecha - Date.today
  
            if diferencia < minimaDiferencia and diferencia >= 0
                minimaDiferencia = diferencia
            end
        end
    end
  
    if minimaDiferencia != Float::INFINITY
        return Integer(minimaDiferencia)
    else
        return -1
    end
end

Handler = Proc.new do |req, res|
    res.status = 200
    res['Content-Type'] = 'application/json; charset=utf-8'
  
    msg = "Prueba"
  
    res.body = {mensaje: msg}.to_json
end