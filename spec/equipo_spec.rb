require_relative "../src/equipo.rb"
require_relative "../src/jugador.rb"

describe Equipo do 
    before(:each) do
        @equipo = Equipo.new('Real Madrid') 
        
        @jugador1 = Jugador.new('Ramos', @equipo)


        @jugador2 = Jugador.new('Marcelo', @equipo)
        @jugador3 = Jugador.new('Varane', @equipo)
        @nuevosJugadores = Array.new
        @nuevosJugadores << @jugador2
        @nuevosJugadores << @jugador3
    end
    
    describe 'nombre' do
        it 'nombre del equipo' do
            expect(@equipo.nombre).to eq 'Real Madrid'
        end
    end

    describe 'jugadores' do
        it 'array creado y vacío' do
            expect(@equipo.jugadores.length).to eq(0)
        end
    end

    describe '#aniadeJugador' do
        it 'nuevo jugador' do
            @equipo.aniadeJugador(@jugador1)
            expect(@equipo.jugadores.length).to eq(1)
        end

        it 'nombre jugador' do
            @equipo.aniadeJugador(@jugador1)
            expect(@equipo.jugadores[0].nombre).to eq 'Ramos'
        end

        it 'no es un jugador' do
            expect{@equipo.aniadeJugador(@equipo)}.to raise_error(ArgumentError)
        end
    end

    describe '#aniadeJugadores' do
        it 'nuevos jugadores' do
            @equipo.aniadeJugadores(@nuevosJugadores)

            expect(@equipo.jugadores.length).to eq(2)
        end

        it 'nombres jugadores' do
            @equipo.aniadeJugadores(@nuevosJugadores)

            expect(@equipo.jugadores[0].nombre).to eq 'Marcelo'
            expect(@equipo.jugadores[1].nombre).to eq 'Varane'
        end

        it 'es un array pero no de jugadores' do
            conjunto = Array.new
            conjunto << @equipo

            expect{@equipo.aniadeJugadores(conjunto)}.to raise_error(ArgumentError)
        end

        it 'no es un array de jugadores' do
            expect{@equipo.aniadeJugadores(@equipo)}.to raise_error(ArgumentError)
        end
    end

    describe '#sacaJugadores' do
        it 'nombre de los jugadores del equipo' do
            @equipo.aniadeJugadores(@nuevosJugadores)

            expect(@equipo.sacaJugadores).to eq 'Marcelo, Varane'
        end
    end

    describe '#buscaJugador' do
        it 'jugador en equipo' do
            @equipo.aniadeJugador(@jugador1)
            expect(@equipo.buscaJugador('Ramos').nombre).to eq 'Ramos'
        end

        it 'jugador no está en equipo' do
            expect{@equipo.buscaJugador('NoEstoy')}.to raise_error(ArgumentError)
        end
    end
end