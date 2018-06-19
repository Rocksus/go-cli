require 'YAML'
require_relative 'classes\system'


inpt = ARGV

if(inpt.length > 3)
	puts "Invalid parameter!"
	puts "Params:"
	puts "ruby go-cli.rb n x y"
	puts "*Creates a n*n and places you in x y"
	puts "ruby go-cli.rb filename"
	puts "*Creates a map based on file provided"
	puts "ruby go-cli.rb"
	puts "*Generates you a random 20x20 map"
else
	Gem.win_platform? ? (system "cls") : (system "clear")
	puts "Go-Cli v.0.1, All Rights Reserved."
end

if(inpt.length == 3) 
	puts "Generating random map with #{inpt[0]}x#{inpt[0]} size..."
	puts "Placing you in position x:#{inpt[1]} y:#{inpt[2]}.."
	admin = System.new(inpt[0], inpt[1], inpt[2])
elsif (inpt.length == 1)
	puts "Valdiating #{inpt[0]}..."
	if File.file?("maps/"+inpt[0])
		puts "Validated!"
		puts "Generating map from #{inpt[0]}..."
		admin = System.new(inpt[0])
	else
		puts "Invalid filename! Please generate the map with generateMap.rb first!"
	end
elsif (inpt.length == 0)
	puts "Generating you a random 20x20 map..."
	admin = System.new
end
system "pause"

