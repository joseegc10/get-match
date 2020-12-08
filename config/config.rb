require 'etcdv3'
require 'figaro'

PORT_DEFECTO = 9292
NUM_MAX_EQUIPOS_DEFECTO = 10

def configuracion_etcd
    vars = Hash.new

    if ENV["HOSTNAME_ETCD"] and ENV["PORT_ETCD"]
        endpoint = "https://" + ENV["HOSTNAME_ETCD"] + ":" + ENV["PORT_ETCD"]
        etcd = Etcdv3.new(endpoints: endpoint)

        vars["PORT"] = etcd.get('PORT')
        vars["NUM_MAX_EQUIPOS"] = etcd.get('NUM_MAX_EQUIPOS')
    end

    return vars
end

def configuracion_figaro
    Figaro.application = Figaro::Application.new(
        path: File.expand_path("config/application.yml")
    )
    Figaro.load

    vars = Hash.new
    vars["PORT"] = (Figaro.env.PORT).to_i
    vars["NUM_MAX_EQUIPOS"] = (Figaro.env.NUM_MAX_EQUIPOS).to_i

    return vars
end

def configuracion_os
    vars = Hash.new
    vars["PORT"] = ENV["PORT"]
    vars["NUM_MAX_EQUIPOS"] = ENV["NUM_MAX_EQUIPOS"]

    return vars
end

def configuracion
    vars_ectd = configuracion_etcd()
    
    if !vars_ectd["PORT"] or !vars_ectd["NUM_MAX_EQUIPOS"]
        vars_os = configuracion_os()
        vars_figaro = configuracion_figaro()
        
        if !vars_figaro["PORT"] or !vars_figaro["NUM_MAX_EQUIPOS"]
            if !vars_os["PORT"] or !vars_os["NUM_MAX_EQUIPOS"]
                vars = Hash.new
                vars["PORT"] = PORT_DEFECTO
                vars["NUM_MAX_EQUIPOS"] = NUM_MAX_EQUIPOS_DEFECTO
                
                return vars
            else
                
                return vars_os
            end
        else
            return vars_figaro
        end
    else
        return vars_ectd
    end
end