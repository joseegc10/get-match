require_relative "../src/manejaLiga.rb"

describe ManejaLiga do 
    before(:each) do
        @gestor = ManejaLiga.new()
    end
    
    describe '#buscaEquipo' do
        it 'buscar un equipo por nombre' do
            expect(@gestor.buscaEquipo('Real Madrid').nombre).to eq 'Real Madrid'
        end

        it 'buscar un equipo que no esta en la liga' do
            expect{@gestor.buscaEquipo('No estoy en la liga')}.to raise_error(ArgumentError)
        end
    end

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    describe '#resultadoPartido' do
        it 'obtener el resultado de un partido' do
            expect(@gestor.resultadoPartido(1,'Real Madrid').golesLocal).to eq (1)
        end
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    describe '#goleadoresPartido' do
        it 'obtener los goleadores de un partido' do
            expect(@gestor.goleadoresPartido(1,'Real Madrid')[0].nombre).to eq 'Sergio Ramos'
        end
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    describe '#diasPartido' do
        it 'obtener los dias hasta un partido' do
            fechaPartido = Date.parse "2020-12-1"
            dias = (fechaPartido - Date.today).to_i
            expect(@gestor.diasPartido(1,'Real Madrid')).to eq (dias)
        end
    end

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    describe '#maximoGoleadorPartido' do
        it 'obtener el maximo goleador de un partido' do
            expect(@gestor.maximoGoleadorPartido(1,'Real Madrid').goleador.nombre).to eq 'Sergio Ramos'
            expect(@gestor.maximoGoleadorPartido(1,'Real Madrid').goles).to eq (1)
        end
    end
end