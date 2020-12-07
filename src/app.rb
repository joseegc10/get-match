require 'sinatra/base'
require 'json'
require_relative 'manejaLiga.rb'

class MyApp < Sinatra::Base
    before do
        @manejador = ManejaLiga.new()
        @jsonify = Jsonify.new()
    end

    def json(data_object)
        content_type :json
        data_object.to_json
    end
end