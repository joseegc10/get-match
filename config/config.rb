require 'etcdv3'
require 'figaro'
 
PORT_DEFECTO = 8080
NUM_MAX_EQUIPOS_DEFECTO = 10
APP_ENV_DEFECTO = 'development'

VARIABLES = ["PORT", "NUM_MAX_EQUIPOS", "APP_ENV"]

def configuracion_etcd
    vars = Hash.new

    if ENV["HOSTNAME_ETCD"] and ENV["PORT_ETCD"]
        endpoint = "https://" + ENV["HOSTNAME_ETCD"] + ":" + ENV["PORT_ETCD"]
        etcd = Etcdv3.new(endpoints: endpoint)

        vars["PORT"] = etcd.get('PORT')
        vars["NUM_MAX_EQUIPOS"] = etcd.get('NUM_MAX_EQUIPOS')
        vars["APP_ENV"] = etcd.get('APP_ENV')
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
    vars["APP_ENV"] = Figaro.env.APP_ENV

    return vars
end

def configuracion_os
    vars = Hash.new
    vars["PORT"] = ENV["PORT"]
    vars["NUM_MAX_EQUIPOS"] = ENV["NUM_MAX_EQUIPOS"]
    vars["APP_ENV"] = ENV["APP_ENV"]

    return vars
end

def existenVariables(vars)
    for variable in VARIABLES
        if !vars[variable]
            return false
        end
    end

    return true
end

def configuracion
    vars_etcd = configuracion_etcd()
    
    if !existenVariables(vars_etcd)
        vars_os = configuracion_os()
        vars_figaro = configuracion_figaro()
        
        if !existenVariables(vars_figaro)
            if !existenVariables(vars_os)
                vars = Hash.new
                vars["PORT"] = PORT_DEFECTO
                vars["NUM_MAX_EQUIPOS"] = NUM_MAX_EQUIPOS_DEFECTO
                vars["APP_ENV"] = APP_ENV_DEFECTO
                
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