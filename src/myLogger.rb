class MyLogger
    def initialize(file=nil)
        if file
            Dir.mkdir('logs') unless File.exist?('logs')

            log_file = File.new('logs/'+file, 'a')

            @_logger = Logger.new(log_file,'weekly')
            @_logger.level = Logger::INFO
            @_logger.datetime_format = '%a %d-%m-%Y %H%M '

            $stdout = log_file
            $stdout.sync = true
            $stderr = log_file
        else
            @_logger = Logger.new(STDOUT)
            @_logger.level = Logger::INFO
            @_logger.datetime_format = '%a %d-%m-%Y %H%M '
        end
    end
    
    attr_reader :_logger
end