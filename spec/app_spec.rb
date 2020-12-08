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
    describe "goleadores de un partido" do 
        it 'jornada correcta' do
            get '/partido/goleadores/Real%20Madrid/1'

            cuerpo = ({"Real Madrid":"Sergio Ramos"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/partido/goleadores/Real%20Madrid/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
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

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    describe "maximo goleador de un partido" do 
        it 'jornada correcta' do
            get '/partido/maximo-goleador/Real%20Madrid/1'

            cuerpo = ({"maximoGoleador":"Sergio Ramos","equipo":"Real Madrid","goles":1,"msg":"El jugador Sergio Ramos ha metido 1 gol"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/partido/maximo-goleador/Real%20Madrid/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    describe "partidos de una jornada" do 
        it 'jornada correcta' do
            get '/jornada/partidos/1'

            cuerpo = ({"Partido 1":{"local":"Real Madrid","visitante":"Sevilla FC","resultado":{"golesLocal":1,"golesVisitante":0}},"Partido 2":{"local":"FC Barcelona","visitante":"Atlético Madrid","resultado":{"golesLocal":1,"golesVisitante":2}}}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/jornada/partidos/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end
end