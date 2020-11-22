require 'net/http'
require 'json'
require 'date'

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
  
    equipo = req.query['equipo'] || 'Real Madrid'

    partidos, nombresEquipos = cargaDatos()

    dias = proximoPartido(partidos, equipo)

    if dias != -1
        if dias == 0
            msg = "El próximo partido es hoy"
        elsif dias == 1
            msg = "Queda #{dias} día para el próximo partido del #{equipo}"
        else
            msg = "Quedan #{dias} días para el próximo partido del #{equipo}"
        end
    else
        msg = "#{equipo} no es un equipo de la Liga Española"
    end
  
    res.body = {equipo: equipo, diasRestantes: dias, mensaje: msg}.to_json
end