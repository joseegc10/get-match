require 'json'
require 'net/https'
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

def getMatch(event:, context:)
    begin
        data = JSON.parse(event["body"])
        message = data["message"]["text"]
        chat_id = data["message"]["chat"]["id"]
        first_name = data["message"]["chat"]["first_name"]
    
        response = "Bot de prueba"
    
        payload = {text: response, chat_id: chat_id}
    
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