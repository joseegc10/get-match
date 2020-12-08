require '../src/app.rb'
require 'rack/test'

describe 'MyApp' do
    include Rack::Test::Methods

    def app
        MyApp
    end

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    describe "resultado de un partido" do 
        it 'jornada correcta' do
            get '/partido/resultado/Real%20Madrid/1'

            cuerpo = ({"Local":"Real Madrid","Visitante":"Sevilla FC","resultado":{"golesLocal":1,"golesVisitante":0}}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/partido/resultado/Real%20Madrid/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    get '/partido/goleadores/:equipo/:jornada' do
        numJornada = params['jornada'].to_i
        nombreEquipo = params['equipo']

        begin
            goleadores = @manejador.goleadoresPartido(numJornada, nombreEquipo)

            status 200
            hash = Hash.new 

            if goleadores.size > 0
                for goleador in goleadores
                    if hash[goleador.equipo.nombre]
                        hash[goleador.equipo.nombre] += (", " + goleador.nombre)
                    else
                        hash[goleador.equipo.nombre] = goleador.nombre
                    end
                end
            else
                hash["msg"] = "Ese partido no ha tenido ningún gol"
            end

            json(hash)
        rescue => e
            status 400
            json({:status => e.message})
        end
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    describe "dias para un partido" do 
        it 'jornada correcta' do
            get '/partido/dias/Real%20Madrid/1'

            fechaPartido = Date.parse "2020-12-1"
            dias = (fechaPartido - Date.today).to_i
            cuerpo = ({"dias":dias,"msg":"El partido fue hace #{-dias} días"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/partido/dias/Real%20Madrid/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end
end