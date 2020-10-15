require_relative "../src/jugador.rb"
require_relative "../src/equipo.rb"

describe Jugador do 
    before(:each) do
        @equipo = Equipo.new('Real Madrid')
        @jugador = Jugador.new('Ramos', @equipo)
    end
    
    describe 'nombre' do
        it 'nombre del jugador' do
            expect(@jugador.nombre).to eq 'Ramos'
        end
    end

    describe 'equipo' do
        it 'equipo del jugador' do
            expect(@jugador.equipo.nombre).to eq 'Real Madrid'
        end
    end

    describe '#cambiaEquipo' do
        it 'jugador cambia de equipo' do
            nuevoEquipo = Equipo.new('Barsa')
            @jugador.cambiaEquipo(nuevoEquipo)
            
            expect(@jugador.equipo.nombre).to eq 'Barsa'
        end

        it 'no es un equipo' do
            expect{@jugador.cambiaEquipo(@jugador)}.to raise_error(ArgumentError)
        end
    end
end