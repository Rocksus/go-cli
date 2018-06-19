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
		drivers[driverName] = Driver.new(driverName, driveCount, rating)
	end
end

drivers.each do |k, val| 
	puts drivers[k.to_s].driveCount
end

output.puts YAML.dump(drivers)
puts YAML.dump(drivers)
