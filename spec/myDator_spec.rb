require_relative "../src/manejaLiga.rb"
require_relative '../src/myDator.rb'

describe ManejaLiga do 
    before(:each) do
        @dator = MyDator.new()
    end
    
    # Método auxiliar
    describe '#buscaEquipo' do
        it 'buscar un equipo por nombre' do
            expect(@dator.buscaEquipo('Real Madrid').nombre).to eq 'Real Madrid'
        end

        it 'buscar un equipo que no esta en la liga' do
            expect{@dator.buscaEquipo('No estoy en la liga')}.to raise_error(ArgumentError)
        end
    end

    # HU1: Como usuario, quiero poder consultar el resultado de un partido
    describe '#resultadoPartido' do
        it 'obtener el resultado de un partido' do
            expect(@dator.resultadoPartido(1,'Real Madrid').golesLocal).to eq (1)
        end
    end

    # HU2: Como usuario, me gustaría poder consultar los goleadores de un partido
    describe '#goleadoresPartido' do
        it 'obtener los goleadores de un partido' do
            expect(@dator.goleadoresPartido(1,'Real Madrid')[0].nombre).to eq 'Sergio Ramos'
        end
    end

    # HU3: Como usuario, me gustaría poder consultar los días que hace que se jugó un partido o los días que quedan para que se juegue
    describe '#diasPartido' do
        it 'obtener los dias hasta un partido' do
            fechaPartido = Date.parse "2020-12-1"
            dias = (fechaPartido - Date.today).to_i
            expect(@dator.diasPartido(1,'Real Madrid')).to eq (dias)
        end
    end

    # HU4: Como usuario, debo poder consultar el máximo goleador de un partido
    describe '#maximoGoleadorPartido' do
        it 'obtener el maximo goleador de un partido' do
            expect(@dator.maximoGoleadorPartido(1,'Real Madrid').goleador.nombre).to eq 'Sergio Ramos'
            expect(@dator.maximoGoleadorPartido(1,'Real Madrid').goles).to eq (1)
        end
    end

    # HU6: Como usuario, me gustaría poder consultar los partidos de una jornada
    describe '#partidosJornada' do
        it 'obtener los partidos de una jornada' do
            expect(@dator.partidosJornada(1)[0].local.nombre).to eq 'Real Madrid'
            expect(@dator.partidosJornada(1)[1].local.nombre).to eq 'FC Barcelona'
        end
    end

    # HU7: Como usuario, me gustaría consultar el tiempo que queda para que empiece una jornada o desde que empezó
    describe '#diasJornada' do
        it 'obtener los dias hasta una jornada' do
            fechaJornada = Date.parse "2020-12-1"
            dias = (fechaJornada - Date.today).to_i
            expect(@dator.diasJornada(1)).to eq (dias)
        end
    end

    # HU8: Como usuario, me gustaría poder consultar el máximo goleador de una jornada
    describe '#maxGoleadorJornada' do
        it 'obtener el maximo goleador de una jornada' do
            expect(@dator.maxGoleadorJornada(1).goleador.nombre).to eq 'Joao Felix'
            expect(@dator.maxGoleadorJornada(1).goles).to eq (2)
        end
    end

    # HU9: Como usuario, me gustaría poder consultar el equipo más goleador de una jornada
    describe '#equipoMaxGoleadorJornada' do
        it 'obtener el equipo más goleador de una jornada' do
            expect(@dator.equipoMaxGoleadorJornada(1).equipo.nombre).to eq 'Atlético Madrid'
            expect(@dator.equipoMaxGoleadorJornada(1).goles).to eq (2)
        end
    end

    # HU10: Como usuario, me gustaría poder consultar los equipos que participan en una liga
    describe '#equiposLiga' do
        it 'obtener los equipos que participan en la liga' do
            expect(@dator.equiposLiga().size).to eq (4)
        end
    end

    # HU11: Como usuario, me gustaría poder consultar el ranking de goleadores de una liga
    describe '#rankingGoleadores' do
        it 'obtener el ranking de goleadores en la liga' do
            expect(@dator.rankingGoleadores()[0].goleador.nombre).to eq 'Joao Felix'
        end
    end

    # HU12: Como usuario, me gustaría poder consultar la clasificación de una liga
    describe '#clasificacionLiga' do
        it 'obtener la clasificacion en la liga' do
            expect(@dator.clasificacionLiga()[0].equipo.nombre).to eq 'Atlético Madrid'
        end
    end

    # HU13: Como usuario, me gustaría poder consultar el número de goles que ha metido un equipo en una liga
    describe '#golesEquipo' do
        it 'obtener los goles de un equipo en la liga' do
            expect(@dator.golesEquipo('Real Madrid')).to eq (1)
        end
    end

    # HU14: Como usuario, quiero poder añadir un equipo a una liga
    describe '#aniadeEquipo' do
        it 'añadir un equipo en la liga' do
            equipo = Equipo.new('Real Madrid')
            expect{@dator.aniadeEquipo(equipo)}.to raise_error(ArgumentError)
        end
    end

    # HU15: Como usuario, quiero poder añadir un partido a una jornada de la liga
    describe '#aniadePartido' do
        it 'añadir un partido en una jornada de la liga' do
            local = Equipo.new('Real Madrid')
            visitante = Equipo.new('Granada') 
            fecha = Date.today
            partido = Partido.new(local, visitante, fecha)

            expect{@dator.aniadePartido(partido, 1)}.to raise_error(ArgumentError)
        end
    end

    # HU16: Como usuario, quiero poder añadir una jornada a una liga 
    describe '#aniadeJornada' do
        it 'añadir una jornada a la liga' do
            local = Equipo.new('Real Madrid')
            visitante = Equipo.new('Granada') 
            fecha = Date.today
            partido = Partido.new(local, visitante, fecha)
            jornada = Jornada.new(Date.today)
            jornada.aniadePartido(partido)

            expect{@dator.aniadeJornada(jornada, 1)}.to raise_error(ArgumentError)
        end
    end

    # HU20: Como usuario, debo poder acceder a la información de un equipo
    describe '#equipo' do
        it 'obtener informacion de un equipo' do
            equipo = @dator.equipo('Real Madrid')

            expect(equipo.nombre).to eq('Real Madrid')
        end
    end

    # HU19: Como usuario, quiero poder resetear la liga
    describe '#reseteaLiga' do
        it 'resetear una liga' do
            @dator.reseteaLiga()

            expect(@dator.clasificacionLiga().size).to eq(0)
            expect(@dator.rankingGoleadores().size).to eq(0)
        end
    end
end