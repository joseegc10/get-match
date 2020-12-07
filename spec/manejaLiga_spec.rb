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
end