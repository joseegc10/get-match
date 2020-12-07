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

    describe '#aniadeGoleadorNombre' do
        it 'equipo del jugador no juega el partido' do
            expect{@partido.aniadeGoleadorNombre('Goleador', 'EquipoNoPartido')}.to raise_error(ArgumentError)
        end

        it 'jugador no pertenece a un equipo que juega el partido' do
            expect{@partido.aniadeGoleadorNombre('GoleadorNoPartido', 'Barsa')}.to raise_error(ArgumentError)
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

        it 'no es un jugador' do
            expect{@partido.aniadeGoleador(@local)}.to raise_error(ArgumentError)
        end

        it 'no es un jugador de un equipo que juegue el partido' do
            equipoNoPartido = Equipo.new('No soy un equipo del partido')
            jugadorCualquiera = Jugador.new('jugador cualquiera', equipoNoPartido)
            expect{@partido.aniadeGoleador(jugadorCualquiera)}.to raise_error(ArgumentError)
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

        it 'es un array pero no de jugadores' do
            conjunto = Array.new
            conjunto << @local
            conjunto << @visitante

            expect{@partido.aniadeGoleadores(conjunto)}.to raise_error(ArgumentError)
        end

        it 'no es un array de jugadores' do
            expect{@partido.aniadeGoleadores(@local)}.to raise_error(ArgumentError)
        end

        it 'hay un jugador que no es de un equipo que juegue el partido' do
            equipoNoPartido = Equipo.new('No soy un equipo del partido')
            jugadorCualquiera = Jugador.new('jugador cualquiera', equipoNoPartido)
            conjunto = Array.new
            conjunto << jugadorCualquiera
            expect{@partido.aniadeGoleadores(conjunto)}.to raise_error(ArgumentError)
        end
    end

    describe '#calculaResultado' do
        it 'calcular el resultado de un partido' do
            @partido.aniadeGoleador(@jugador)
            resultado = @partido.calculaResultado
            expect(resultado.golesLocal).to eq(1)
            expect(resultado.golesVisitante).to eq(0)
        end
    end

    describe '#diasPara_DesdeElPartido' do
        it 'número de dias que quedan/pasaron para/desde un partido' do
            expect(@partido.diasPara_DesdeElPartido).to eq(0)
        end
    end

    describe '#sacaGoleadores' do
        it 'nombre de los goleadores del partido' do
            @partido.aniadeGoleadores(@nuevosGoleadores)

            expect(@partido.sacaGoleadores).to eq 'Ramos, Pique'
        end
    end

    describe '#maximoGoleador' do
        it 'no hay goleadores' do
            expect{@partido.maxGoleador}.to raise_error(ArgumentError)
        end

        it 'calcular el maximo goleador de un partido' do
            @partido.aniadeGoleador(@jugador)
            goleador_goles = @partido.maxGoleador
            expect(goleador_goles.goleador.nombre).to eq('Ramos')
        end
    end
end