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
end