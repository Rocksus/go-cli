require 'YAML'
require_relative 'classes/driver'
require_relative 'classes/genMap'

print "Enter map name: "
mapName = gets.chomp

outputs = File.new('maps/'+mapName+'.yml', 'w')

map = GeneratedMap.new

outputs.puts YAML.dump(map)