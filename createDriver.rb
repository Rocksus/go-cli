require 'yaml'
#this is for initializing the driver yaml database

class Driver
	attr_accessor :driverName
	attr_accessor :driveCount
	attr_accessor :rating
	def initialize(driverName, driveCount, rating)
		@driverName = driverName
		@driveCount = driveCount
		@rating = rating
	end
end

drivers={}
output = File.new('drivers/drivernames.yml', 'w')

File.open('drivers/drivernames.bin', 'rb') do |f|
	f.each_line do |line|
		inpt = line.split(" ")
		driverName = inpt[0].to_s
		driveCount = inpt[1].to_i
		rating = inpt[2].to_f
		output = File.new('drivers/'+driverName+'.yml', 'w')
		output.puts YAML.dump(Driver.new(driverName, driveCount, rating))
	end
end

puts "Generate drivers from drivernames.bin complete!"