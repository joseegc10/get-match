require 'etcdv3'
require 'figaro'
 
NUM_MAX_EQUIPOS_DEFECTO = 10
APP_ENV_DEFECTO = 'development'
URI_DATABASE_DEFECTO = ENV["URI_DATABASE"]
SECRET_DATABASE_DEFECTO = ENV["SECRET_DATABASE"]

VARIABLES = ["NUM_MAX_EQUIPOS", "APP_ENV", "URI_DATABASE", "SECRET_DATABASE"]

def configuracion_etcd
    vars = Hash.new

    if ENV["HOSTNAME_ETCD"] and ENV["PORT_ETCD"]
        endpoint = "https://" + ENV["HOSTNAME_ETCD"] + ":" + ENV["PORT_ETCD"]
        etcd = Etcdv3.new(endpoints: endpoint)

        for v in VARIABLES
            vars[v] = etcd.get(v)
        end
    end

    return vars
end

def configuracion_figaro
    Figaro.application = Figaro::Application.new(
        path: File.expand_path("config/application.yml")
    )
    Figaro.load

    vars = Hash.new
    for v in VARIABLES
        vars[v] = Figaro.env[v]
    end

    return vars
end

def configuracion_os
    vars = Hash.new

    for v in VARIABLES
        vars[v] = ENV[v]
    end

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
                vars["NUM_MAX_EQUIPOS"] = NUM_MAX_EQUIPOS_DEFECTO
                vars["APP_ENV"] = APP_ENV_DEFECTO
                vars["URI_DATABASE"] = URI_DATABASE_DEFECTO
                vars["SECRET_DATABASE"] = SECRET_DATABASE_DEFECTO
                
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