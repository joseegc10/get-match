require_relative "../handler.rb"

describe 'carga datos aws' do
    it 'datos correctos aws' do
        partidos, equipos = cargaDatos()
        expect(partidos["name"]).to eq 'Primera División 2020/21'
        expect(equipos[0]).to eq 'SD Eibar'
    end
end

describe '#calculaResultado' do
    it 'jornada dada y equipo en liga' do
        partidos, equipos = cargaDatos()
        res = calculaResultado(partidos, 'Real Madrid', 7)
        expect(res).to eq 'El equipo Real Madrid le ganó 1 a 3 al equipo FC Barcelona.'
    end

    it 'jornada dada y equipo no en liga' do
        partidos, equipos = cargaDatos()
        res = calculaResultado(partidos, 'NoEstoyEnLiga', 7)
        expect(res).to eq 'El equipo NoEstoyEnLiga no ha disputado la Jornada 7.'
    end

    it 'jornada no dada y equipo no en liga' do
        partidos, equipos = cargaDatos()
        res = calculaResultado(partidos, 'NoEstoyEnLiga', -1)
        expect(res).to eq 'El equipo NoEstoyEnLiga no ha disputado la última jornada.'
    end
end