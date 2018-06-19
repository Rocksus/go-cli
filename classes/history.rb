# require 'YAML'

class Ride
	attr_accessor :date
	attr_accessor :start
	attr_accessor :finish
	attr_accessor :pos
	attr_accessor :dest
	attr_accessor :fare
	attr_accessor :driverName
	attr_accessor :uToD
	attr_accessor :dToU
	attr_accessor :routes
	
	def initialize(date, start, finish, pos, dest, fare, driverName, uToD, dToU, routes)
		@date = date
		@start = start
		@finish = finish
		@pos = pos
		@dest = dest
		@fare = fare
		@driverName = driverName
		@uToD = uToD
		@dToU = dToU
		@routes = routes
	end
end

class History
	attr_accessor :profileName
	attr_accessor :debt
	attr_accessor :rideCount
	attr_accessor :rating
	attr_accessor :rides
	attr_accessor :password
	def initialize(uName, password, debt, rideCount, rating)
		@rides = []
		@profileName = uName
		@debt = debt
		@rideCount = rideCount
		@rating = rating
		@password = password
	end
	def addRides(duration, pos, dest, fare, driverName, uToD, dToU, routes)
		@ntime = Time.now.to_s.split(" ")
		@date = @ntime[0]
		@start = @ntime[1]
		@addTime = duration
		@finish = (Time.now + @addTime*60).to_s.split(" ")[1]
		@pos = pos.split(",").each { |e| e.to_i }
		@dest = dest.split(",").each { |e| e.to_i }
		@fare = fare
		@driverName = driverName
		@uToD = uToD
		@dToU = dToU
		@routes = routes
		@rides.push(Ride.new(@date, @start, @finish, @pos, @dest, @fare, @driverName, @uToD, @dToU, @routes))
	end
end

# history = History.new("Farhan", "test123", 56000, 3, 4.5)

# history.addRides(32, "1,2", "4,5", 21000, "Adit", 5, 4, ["Start at (1,2)", "Go to (1,5)", "Turn Right", "Go to (4,5)", "Finish at (4,5)"])
# history.addRides(56, "1,1", "15,6", 78001, "Tono", 5, 4, ["Start at (1,1)", "Go to (1,6)", "Turn Right", "Go to (15,6)", "Finish at (16,6)"])

# output = File.new("test.yml", "w")

# output.puts YAML.dump(history)