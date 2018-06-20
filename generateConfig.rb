require 'YAML'
require_relative 'classes/config'

puts "Rate?"
rate = gets.chomp.to_i
puts "Number of drivers?"
drivers = gets.chomp.to_i
puts "Rush Hour Start(hh:mm:ss)?"
rush_hour_start = gets.chomp
puts "Rush Hour End(hh:mm:ss)?"
rush_hour_end = gets.chomp
puts "finishedTimeDiff?"
finishedTimeDiff = gets.chomp.to_f

cfg = Config.new(rate, drivers, rush_hour_start, rush_hour_end, finishedTimeDiff)

output = File.new('config.yml', 'w')

output.puts YAML.dump(cfg)
