require_relative "../src/jornada.rb"
require_relative "../src/partido.rb"
require_relative "../src/jugador.rb"
require_relative "../src/equipo.rb"

describe Jornada do 
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

        @jornada = Jornada.new(1,Date.today)

        @partido2 = Partido.new(@visitante, @local, @fecha) 

        @nuevosPartidos = Array.new
        @nuevosPartidos << @partido
        @nuevosPartidos << @partido2
    end

    describe 'numero' do
        it 'numero de la jornada' do
            expect(@jornada.numero).to eq(1)
        end
    end

    describe '#aniadePartido' do
        it 'nuevo partido' do
            @jornada.aniadePartido(@partido)
            expect(@jornada.partidos.length).to eq(1)
        end

        it 'no es un partido' do
            expect{@jornada.aniadePartido(@local)}.to raise_error(ArgumentError)
        end
    end

    describe '#aniadePartidos' do
        it 'nuevos partidos' do
            @jornada.aniadePartidos(@nuevosPartidos)
            expect(@jornada.partidos.length).to eq(2)
        end

        it 'es un array pero no de partidos' do
            conjunto = Array.new
            conjunto << @local
            conjunto << @visitante

            expect{@jornada.aniadePartidos(conjunto)}.to raise_error(ArgumentError)
        end

        it 'no es un array de partidos' do
            expect{@jornada.aniadePartidos(@local)}.to raise_error(ArgumentError)
        end
    end
end