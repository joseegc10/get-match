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

        @jornada = Jornada.new(Date.today)

        @partido2 = Partido.new(@visitante, @local, @fecha) 

        @nuevosPartidos = Array.new
        @nuevosPartidos << @partido
        @nuevosPartidos << @partido2
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

    describe '#diasPara_DesdeLaJornada' do
        it 'número de dias que quedan/pasaron para/desde una jornada' do
            expect(@jornada.diasPara_DesdeLaJornada).to eq(0)
        end
    end

    describe '#maximoGoleadorJornada' do
        it 'no hay goleadores' do
            expect{@jornada.maximoGoleadorJornada}.to raise_error(ArgumentError)
        end

        it 'calcular el máximo goleador de una jornada' do
            @partido.aniadeGoleador(@jugador)
            @partido.aniadeGoleador(@jugador)
            @partido2.aniadeGoleador(@jugador2)
            @jornada.aniadePartido(@partido)
            @jornada.aniadePartido(@partido2)

            goleador_goles  = @jornada.maximoGoleadorJornada

            expect(goleador_goles.goleador.nombre).to eq('Ramos')
            expect(goleador_goles.goles).to eq(2)
        end
    end

    describe '#equipoMasGoleador' do
        it 'no hay goleadores' do
            expect{@jornada.equipoMasGoleador}.to raise_error(ArgumentError)
        end

        it 'calcular el equipo más goleador de una jornada' do
            @partido.aniadeGoleador(@jugador)
            @partido.aniadeGoleador(@jugador)
            @partido2.aniadeGoleador(@jugador2)
            @jornada.aniadePartido(@partido)
            @jornada.aniadePartido(@partido2)
            
            equipo_goles  = @jornada.equipoMasGoleador

            expect(equipo_goles.equipo.nombre).to eq('Real Madrid')
            expect(equipo_goles.goles).to eq(2)
        end
    end

    describe '#calculaResultado' do
        it 'equipo que no ha jugado la jornada' do
            equipoNoJornada = Equipo.new('Equipo que no juega la jornada')
            expect{@jornada.calculaResultado(equipoNoJornada)}.to raise_error(ArgumentError)
        end
    end

    describe '#goleadoresPartido' do
        it 'equipo que no ha jugado la jornada' do
            equipoNoJornada = Equipo.new('Equipo que no juega la jornada')
            expect{@jornada.goleadoresPartido(equipoNoJornada)}.to raise_error(ArgumentError)
        end
    end
end