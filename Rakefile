require 'rspec/core/rake_task'

task default: %w[install]

desc "Instalación de dependencias"
task :install do
    exec "bundle install"
end

RSpec::Core::RakeTask.new(:test) do |t|
    t.pattern = 'spec/*_spec.rb'
end

RSpec::Core::RakeTask.new(:equipo) do |t|
    t.pattern = 'spec/equipo_spec.rb'
end

RSpec::Core::RakeTask.new(:jugador) do |t|
    t.pattern = 'spec/jugador_spec.rb'
end

RSpec::Core::RakeTask.new(:partido) do |t|
    t.pattern = 'spec/partido_spec.rb'
end