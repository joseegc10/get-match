require_relative "../src/partido.rb"
require_relative "../src/jugador.rb"
require_relative "../src/equipo.rb"

describe Partido do 
    before(:each) do
        @local = Equipo.new('Real Madrid')
        @visitante = Equipo.new('Barsa') 
        @fecha = Date.today

        @partido = Partido.new(@local, @visitante, @fecha) 

        @jugador = Jugador.new('Ramos', @local)
        @jugador2 = Jugador.new('Pique', @visitante)

        @nuevosGoleadores= Array.new
        @nuevosGoleadores << @jugador
        @nuevosGoleadores << @jugador2
    end

    describe 'nombre' do
        it 'nombre del equipo local' do
            expect(@partido.local.nombre).to eq 'Real Madrid'
        end

        it 'nombre del equipo visitante' do
            expect(@partido.visitante.nombre).to eq 'Barsa'
        end
    end

    describe '#aniadeGoleador' do
        it 'nuevo goleador' do
            @partido.aniadeGoleador(@jugador)
            expect(@partido.goleadores.length).to eq(1)
        end

        it 'nombre goleador' do
            @partido.aniadeGoleador(@jugador)
            expect(@partido.goleadores[0].nombre).to eq 'Ramos'
        end
    end

    describe '#aniadeGoleadores' do
        it 'nuevos goleadores' do
            @partido.aniadeGoleadores(@nuevosGoleadores)
            expect(@partido.goleadores.length).to eq(2)
        end

        it 'nombres goleadores' do
            @partido.aniadeGoleadores(@nuevosGoleadores)

            expect(@partido.goleadores[0].nombre).to eq 'Ramos'
            expect(@partido.goleadores[1].nombre).to eq 'Pique'
        end
    end
end