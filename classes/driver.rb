class Driver
	attr_accessor :driverName
	attr_accessor :driveCount
	attr_accessor :rating
	attr_accessor :x
	attr_accessor :y
	
	def initialize(driverName, driveCount, rating, x, y)
		@driverName = driverName
		@driveCount = driveCount
		@rating = rating
		@x = x
		@y = y
	end
end