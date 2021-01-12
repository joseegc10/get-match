require 'rspec/core/rake_task'

task default: %w[install]

desc "Instalación de dependencias"
task :install do
    exec "bundle install"
end

task :start do
	exec "foreman start"
end

task :stop do
	exec "pkill -f rackup"
end

task :build do
end

RSpec::Core::RakeTask.new(:test) do |t|
    t.pattern = 'spec/*_spec.rb'
end

RSpec::Core::RakeTask.new(:vercel_test) do |t|
    t.pattern = 'spec/vercel/*_spec.rb'
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

RSpec::Core::RakeTask.new(:app) do |t|
    t.pattern = 'spec/app_spec.rb'
end

RSpec::Core::RakeTask.new(:jornada) do |t|
    t.pattern = 'spec/jornada_spec.rb'
end

RSpec::Core::RakeTask.new(:jsonify) do |t|
    t.pattern = 'spec/jsonify_spec.rb'
end

RSpec::Core::RakeTask.new(:liga) do |t|
    t.pattern = 'spec/liga_spec.rb'
end

RSpec::Core::RakeTask.new(:manejaLiga) do |t|
    t.pattern = 'spec/manejaLiga_spec.rb'
end