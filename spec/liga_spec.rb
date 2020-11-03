require_relative "../src/jornada.rb"
require_relative "../src/partido.rb"
require_relative "../src/jugador.rb"
require_relative "../src/equipo.rb"
require_relative "../src/liga.rb"

describe Liga do 
    before(:each) do
        @local = Equipo.new('Real Madrid')
        @visitante = Equipo.new('Barsa') 
        @equipos = Array.new
        @equipos << @local
        @equipos << @visitante
        @fecha = Date.today

        @jugador = Jugador.new('Ramos', @local)
        @jugador2 = Jugador.new('Pique', @visitante)

        @jornada = Jornada.new(Date.today)

        @partido = Partido.new(@local, @visitante, @fecha) 
        @partido.aniadeGoleador(@jugador)
        @partido.aniadeGoleador(@jugador)
        @partido.aniadeGoleador(@jugador2)

        @partido2 = Partido.new(@visitante, @local, @fecha)
        @partido2.aniadeGoleador(@jugador)
        @partido2.aniadeGoleador(@jugador2)

        @jornada.aniadePartido(@partido)
        @jornada.aniadePartido(@partido2)

        @liga = Liga.new(@equipos)
    end

    describe 'equipos' do
        it 'num_equipos' do
            expect(@liga.equipos.length).to eq(2)
        end
    end

    describe 'clasificacion' do
        it 'num_equipos' do
            expect(@liga.clasificacion.length).to eq(2)
        end
    end

    describe '#aniadeJornada' do
        it 'no es una jornada' do
            expect{@liga.aniadeJornada(@local)}.to raise_error(ArgumentError)
        end
    end

    """
    describe '#actualizaRanking' do
        it 'nueva jornada' do
            @liga.aniadeJornada(@jornada)
            print (@liga.rankingGoleadores[1].goles)
            expect(@liga.rankingGoleadores[0].goles).to eq(3)
        end
    end
    """

    describe '#actualizaClasificacion' do
        it 'puntos' do
            @liga.aniadeJornada(@jornada)
            expect(@liga.clasificacion[0].puntos).to eq(4)
            expect(@liga.clasificacion[1].puntos).to eq(1)
        end

        it 'nombres equipos' do
            @liga.aniadeJornada(@jornada)
            expect(@liga.clasificacion[0].equipo.nombre).to eq('Real Madrid')
            expect(@liga.clasificacion[1].equipo.nombre).to eq('Barsa')
        end
    end
end