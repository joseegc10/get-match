Handler = Proc.new do |req, res|
    res.status = 200
    res['Content-Type'] = 'application/json; charset=utf-8'
  
    msg = "Prueba"
  
    res.body = {mensaje: msg}.to_json
end