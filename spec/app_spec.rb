require_relative '../src/app'
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

        it 'equipo inexistente' do
            get '/partido/resultado/NoExisto/1'

            cuerpo = ({"status":"Ese equipo no pertenece a la liga"}).to_json

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

        it 'equipo inexistente' do
            get '/partido/goleadores/NoExisto/1'

            cuerpo = ({"status":"Ese equipo no pertenece a la liga"}).to_json

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

        it 'equipo inexistente' do
            get '/partido/dias/NoExisto/1'

            cuerpo = ({"status":"Ese equipo no pertenece a la liga"}).to_json

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

        it 'equipo inexistente' do
            get '/partido/maximo-goleador/NoExisto/1'

            cuerpo = ({"status":"Ese equipo no pertenece a la liga"}).to_json

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

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    describe "dias para una jornada" do 
        it 'jornada correcta' do
            get '/jornada/dias/1'

            fechaPartido = Date.parse "2020-12-1"
            dias = (fechaPartido - Date.today).to_i
            cuerpo = ({"dias":dias,"msg":"La jornada 1 fue hace #{-dias} días"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/jornada/dias/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    describe "maximo goleador jornada" do 
        it 'jornada correcta' do
            get '/jornada/maximo-goleador/1'

            cuerpo = ({"maximoGoleador":"Joao Felix","equipo":"Atlético Madrid","goles":2,"msg":"El jugador Joao Felix ha metido 2 goles"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/jornada/maximo-goleador/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
    describe "equipo mas goleador jornada" do 
        it 'jornada correcta' do
            get '/jornada/equipo/maximo-goleador/1'

            cuerpo = ({"equipo":"Atlético Madrid","goles":2,"msg":"El equipo Atlético Madrid ha metido 2 goles"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'jornada incorrecta' do
            get '/jornada/equipo/maximo-goleador/-1'

            cuerpo = ({"status":"La jornada introducida no se ha jugado"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
    describe "equipos liga" do 
        it 'lista de los equipos de la liga' do
            get '/equipos'

            cuerpo = ({"Equipo 1":"Real Madrid","Equipo 2":"FC Barcelona","Equipo 3":"Atlético Madrid","Equipo 4":"Sevilla FC"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end
    end

    # HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
    describe "ranking goleadores liga" do 
        it 'ranking de goleadores de la liga' do
            get '/ranking/goleadores'

            cuerpo = ({"1º":{"nombre":"Joao Felix","equipo":"Atlético Madrid","goles":2},"2º":{"nombre":"Sergio Ramos","equipo":"Real Madrid","goles":1},"3º":{"nombre":"Leo Messi","equipo":"FC Barcelona","goles":1}}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end
    end

    # HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
    describe "clasificacion de la liga" do 
        it 'clasificacion de la liga' do
            get '/ranking/clasificacion'

            cuerpo = ({"1º":{"equipo":"Atlético Madrid","puntos":3,"goles":2},"2º":{"equipo":"Real Madrid","puntos":3,"goles":1},"3º":{"equipo":"FC Barcelona","puntos":0,"goles":1},"4º":{"equipo":"Sevilla FC","puntos":0,"goles":0}}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end
    end

    # HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
    describe "goles equipo en liga" do 
        it 'goles del Real Madrid en la liga' do
            get '/equipo/goles/Real%20Madrid'

            cuerpo = ({"equipo":"Real Madrid","goles":1,"msg":"El equipo Real Madrid ha metido 1 gol"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end

        it 'equipo incorrecto' do
            get '/equipo/goles/NoExisto'

            cuerpo = ({"status":"Ese equipo no pertenece a la liga"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU14: Como usuario, quiero poder añadir un equipo a una liga
    describe "añadir equipo a la liga" do 
        it 'equipo correcto' do
            equipo = {
                "name"=>"Valencia CF", 
                "players"=>[
                    "Gaya", 
                    "Maxi Gomez"
                ]
            }

            put '/equipos/Valencia%20CF', equipo.to_json

            cuerpo = ({"status":"Equipo añadido correctamente"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.location).to eq ('/equipos/Valencia%20CF')
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end

        it 'equipo ya existente' do
            equipo = {
                "name"=>"Real Madrid", 
                "players"=>[
                    "Gaya", 
                    "Maxi Gomez"
                ]
            }

            put '/equipos/Real%20Madrid', equipo.to_json

            cuerpo = ({"status":"El equipo ya existe en la liga"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
    describe "añadir partido a una jornada de la liga" do 
        it 'partido correcto' do
            # Añado otro equipo además del Valencia
            equipo = {
                "name"=>"Granada CF", 
                "players"=>[
                    "Soldado", 
                    "Yangel Herrera"
                ]
            }

            put '/equipos/Granada%20CF', equipo.to_json

            partido = {
                "round"=>"Jornada 2",
                "date"=>"2020-12-9",
                "team1"=>"Valencia CF",
                "team2"=>"Granada CF"
            }

            put '/partidos/2/Granada%20CF', partido.to_json

            cuerpo = ({"status":"Partido añadido correctamente"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end

        it 'partido con equipo ya existente' do
            partido = {
                "round"=>"Jornada 2",
                "date"=>"2020-12-9",
                "team1"=>"Real Madrid",
                "team2"=>"FC Barcelona"
            }

            put '/partidos/2/Real%20Madrid', partido.to_json

            cuerpo = ({"status":"El partido lo juega un equipo que ya juega otro partido en la jornada"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end

        it 'jornada incorrecta' do
            partido = {
                "round"=>"Jornada 3",
                "date"=>"2020-12-9",
                "team1"=>"Sevilla FC",
                "team2"=>"FC Barcelona"
            }

            put '/partidos/3/Sevilla%20FC', partido.to_json

            cuerpo = ({"status":"La jornada introducida no existe"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU16: Como usuario, quiero poder añadir una jornada a una liga
    describe "añadir jornada de la liga" do 
        it 'jornada correcta' do
            jornada = [
                    {
                        "round": "Jornada 3",
                        "date": "2020-12-8",
                        "team1": "FC Barcelona",
                        "team2": "Real Madrid"
                    }
                ]

            put '/jornadas/3', jornada.to_json

            cuerpo = ({"status":"Jornada 3 añadida correctamente"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end

        it 'equipo que no está en liga' do
            jornada = [
                    {
                        "round": "Jornada 4",
                        "date": "2020-12-8",
                        "team1": "No estoy en liga",
                        "team2": "Real Madrid"
                    }
                ]

            put '/jornadas/4', jornada.to_json

            cuerpo = ({"status":"Al menos un equipo del partido no participa en la liga"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end

        it 'jornada incorrecta' do
            jornada = [
                    {
                        "round": "Jornada 999",
                        "date": "2020-12-8",
                        "team1": "FC Barcelona",
                        "team2": "Real Madrid"
                    }
                ]

            put '/jornadas/999', jornada.to_json

            cuerpo = ({"status":"Número de jornada incorrecta"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (false)
        end
    end

    # HU20: Como usuario, debo poder acceder a la información de un equipo
    describe 'info de un equipo' do
        it 'obtener la informacion de un equipo' do
            get '/equipos/Real%20Madrid'

            cuerpo = ({
                "name":"Real Madrid",
                "players":["Sergio Ramos", "Eden Hazard"]
                
            }).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end
    end

    # HU19: Como usuario, quiero poder resetear la liga
    describe "resetear la liga" do
        it 'liga reseteada' do
            delete '/liga'

            cuerpo = ({"status":"Liga reseteada correctamente"}).to_json

            expect(last_response.body).to eq (cuerpo)
            expect(last_response.content_type).to eq ('application/json')
            expect(last_response.ok?).to eq (true)
        end
    end
end