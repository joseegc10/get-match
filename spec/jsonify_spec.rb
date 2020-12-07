require_relative "../src/jsonify.rb"

describe Jsonify do 
    before(:each) do
        @jsonify = Jsonify.new()
        @liga = @jsonify.jsonToLiga('../sampledata/partidos.json', '../sampledata/equipos.json')
    end

    describe '#jsonToLiga' do
        it 'nombre de liga bien creado' do
            expect(@liga.nombreLiga).to eq 'Primera División 2020/21'
        end

        it 'equipos bien creados' do
            expect(@liga.equipos.size).to eq (4)
        end

        describe '#jsonToJornadas' do
            it 'jornadas bien creadas' do
                expect(@liga.jornadas[0].partidos[0].local.nombre).to eq 'Real Madrid'
            end
        end

        it 'clasificacion bien creada' do
            expect(@liga.clasificacion[0].equipo.nombre).to eq 'Atlético Madrid'
        end

        it 'ranking goleadores bien creado' do
            expect(@liga.rankingGoleadores[0].goleador.nombre).to eq 'Joao Felix'
        end
    end

    describe '#jsonToEquipo' do
        it 'equipo bien creado' do
            pathEquipos = File.join(File.dirname(__FILE__), '../sampledata/equipos.json')
            fileEquipos = File.read(pathEquipos)
            equiposJSON = JSON.parse(fileEquipos)
            equipoJSON = equiposJSON["clubs"][0]

            expect(@jsonify.jsonToEquipo(equipoJSON).nombre).to eq 'Real Madrid'
            expect(@jsonify.jsonToEquipo(equipoJSON).jugadores.size).to eq (2)
        end
    end

    describe '#jsonToPartido' do
        it 'partido bien creado' do
            pathPartidos = File.join(File.dirname(__FILE__), '../sampledata/partidos.json')
            filePartidos = File.read(pathPartidos)
            partidosJSON = JSON.parse(filePartidos)
            partidoJSON = partidosJSON["matches"][0]

            partido, jornada = @jsonify.jsonToPartido(partidoJSON, @liga.equipos)

            expect(partido.local.nombre).to eq 'Real Madrid'
            expect(partido.goleadores.size).to eq (1)
            expect(jornada).to eq (1)
        end

        it 'partido mal creado' do
            pathPartidos = File.join(File.dirname(__FILE__), '../sampledata/partidos.json')
            filePartidos = File.read(pathPartidos)
            partidosJSON = JSON.parse(filePartidos)
            partidoJSON = partidosJSON["matches"][0]

            partidoJSON["score"]["scorers"][0]["name"] = "NoEstoy"

            expect{@jsonify.jsonToPartido(partidoJSON, @liga.equipos)}.to raise_error(ArgumentError)
        end
    end

    describe '#jsonToJornada' do
        it 'jornada bien creada' do
            pathPartidos = File.join(File.dirname(__FILE__), '../sampledata/testJsonify.json')
            filePartidos = File.read(pathPartidos)
            partidosJSON = JSON.parse(filePartidos)

            jornada, numJornada = @jsonify.jsonToJornada(partidosJSON, @liga.equipos)

            expect(jornada.fechaInicio).to eq (Date.parse "2020-12-1")
            expect(jornada.partidos.size).to eq (2)
            expect(numJornada).to eq (1)
        end

        it 'jornada mal creada' do
            pathPartidos = File.join(File.dirname(__FILE__), '../sampledata/partidos.json')
            filePartidos = File.read(pathPartidos)
            partidosJSON = JSON.parse(filePartidos)

            expect{@jsonify.jsonToJornada(partidosJSON, @liga.equipos)}.to raise_error(ArgumentError)
        end
    end
end