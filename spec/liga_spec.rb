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

        @liga = Liga.new(@equipos, "Liga prueba")
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

    describe '#buscaEquipo' do
        it 'buscar un equipo de la liga' do
            expect(@liga.buscaEquipo('Real Madrid').nombre).to eq('Real Madrid')
        end
    end

    describe '#actualizaRanking' do
        it 'goles' do
            @liga.aniadeJornada(@jornada, 0)
            expect(@liga.rankingGoleadores[0].goles).to eq(3)
            expect(@liga.rankingGoleadores[1].goles).to eq(2)
        end

        it 'nombres goleadores' do
            @liga.aniadeJornada(@jornada, 0)
            expect(@liga.rankingGoleadores[0].goleador.nombre).to eq('Ramos')
            expect(@liga.rankingGoleadores[1].goleador.nombre).to eq('Pique')
        end
    end

    describe '#actualizaClasificacion' do
        it 'puntos' do
            @liga.aniadeJornada(@jornada, 0)
            expect(@liga.clasificacion[0].puntos).to eq(4)
            expect(@liga.clasificacion[1].puntos).to eq(1)
        end

        it 'nombres equipos' do
            @liga.aniadeJornada(@jornada, 0)
            expect(@liga.clasificacion[0].equipo.nombre).to eq('Real Madrid')
            expect(@liga.clasificacion[1].equipo.nombre).to eq('Barsa')
        end
    end

    # Test para HU13: Consultar el número de goles de un equipo
    describe '#numGolesEquipo' do
        it 'should raise an exception if the argument is not of type Equipo' do
            expect{@liga.numGolesEquipo("noEsUnEquipo")}.to raise_error(ArgumentError)
        end

        equipo_fuera_liga = Equipo.new('Atletico')

        it 'should raise an exception if the argument is not a team of the league' do
            expect{@liga.numGolesEquipo(equipo_fuera_liga)}.to raise_error(ArgumentError)
        end

        it 'should do the counting right' do
            @liga.aniadeJornada(@jornada, 0)
            expect(@liga.numGolesEquipo(@local)).to eq(3)
        end
    end

    describe '#resultadoPartido' do
        it 'jornada no disputada' do
            expect{@liga.resultadoPartido(99, @local)}.to raise_error(ArgumentError)
        end
    end

    describe '#goleadoresPartido' do
        it 'jornada no disputada' do
            expect{@liga.goleadoresPartido(99, @local)}.to raise_error(ArgumentError)
        end
    end

    describe '#diasPartido' do
        it 'jornada no disputada' do
            expect{@liga.diasPartido(99, @local)}.to raise_error(ArgumentError)
        end
    end

    describe '#maxGoleadorPartido' do
        it 'jornada no disputada' do
            expect{@liga.maxGoleadorPartido(99, @local)}.to raise_error(ArgumentError)
        end
    end

    describe '#partidosJornada' do
        it 'jornada no disputada' do
            expect{@liga.partidosJornada(99)}.to raise_error(ArgumentError)
        end
    end

    describe '#diasJornada' do
        it 'jornada no disputada' do
            expect{@liga.diasJornada(99)}.to raise_error(ArgumentError)
        end
    end
end