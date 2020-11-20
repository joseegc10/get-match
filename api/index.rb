def cargaDatos()
    url = 'https://raw.githubusercontent.com/openfootball/football.json/master/2020-21/es.1.json'
    uri = URI(url)
    response = Net::HTTP.get(uri)
    partidos = JSON.parse(response)
  
    return partidos
end

Handler = Proc.new do |req, res|
    res.status = 200
    res['Content-Type'] = 'application/json; charset=utf-8'
  
    msg = "Prueba"
  
    res.body = {mensaje: msg}.to_json
end