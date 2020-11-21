require_relative "../api/index.rb"

describe 'carga datos vercel' do
    it 'datos correctos vercel' do
        partidos, equipos = cargaDatos()
        expect(partidos["name"]).to eq 'Primera División 2020/21'
        expect(equipos[0]).to eq 'SD Eibar'
    end
end

describe '#proximoPartido' do
    it 'proximo partido de un equipo' do
        partidos, equipos = cargaDatos()
        dias = proximoPartido(partidos, 'NoEstoyEnLiga')
        expect(dias).to eq (-1)
    end
end

describe 'handler Vercel' do
    it 'proximo partido de un equipo desde vercel' do
        url = 'https://get-match.vercel.app/api?equipo=NoEstoyEnLiga'
        uri = URI(url)
        response = Net::HTTP.get(uri)
        respuestaVercel = JSON.parse(response)

        expect(respuestaVercel["mensaje"]).to eq 'NoEstoyEnLiga no es un equipo de la Liga Española'
    end
end