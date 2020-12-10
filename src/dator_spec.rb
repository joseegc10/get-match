require_relative '../src/dator.rb'

describe Dator do   
    describe 'clase no instanciable' do
        it 'no podemos generar una instancia de la clase Dator' do
            expect{dator = Dator.new}.to raise_error(StandardError, "No se permiten crear instancias de una clase abstracta")
        end
    end
end