require 'YAML'
require_relative 'driver'
require_relative 'user'
require_relative 'map'
require_relative 'genMap'
require_relative 'config'

class System
	def initialize(*args)
		@cfg = YAML.load_file("./config.yml") #PLEASE ADD ERROR HANDLING
		if(args.length == 3) #if there are 3 args
			@n = args[0].to_i
			@x = args[1].to_i
			@y = args[2].to_i
			@driversList = YAML.load_file("drivers/drivernames.yml") #PLEASE ADD ERROR HANDLING
			@selected = @driversList.keys.sample(@cfg.drivers)
			@drivers = {}
			@driversCoor = []
			@selected.each do |driver|
				loop do
					@driverPos = [1+rand(@n), 1+rand(@n)]
					break unless @driversCoor.include? @driverPos
				end
				@drivers[driver] = @driversList[driver]
				@drivers[driver].x = @driverPos[0]
				@drivers[driver].y = @driverPos[1]
				@driversCoor.push(@driverPos)
			end
		elsif(args.length == 1) #if there is an arg
			@mapFile = YAML.load_file("maps/"+args[0]) #PLEASE ADD ERROR HANDLING
			@n = @mapFile.n
			@x = @mapFile.userX
			@y = @mapFile.userY
			@drivers = @mapFile.drivers
			@driversCoor = @mapFile.driversCoor
		else #if no args
			@n=20
			@x=1+rand(20)
			@y=1+rand(20)
			@driversList = YAML.load_file("drivers/drivernames.yml") #PLEASE ADD ERROR HANDLING
			@selected = @driversList.keys.sample(@cfg.drivers)
			@drivers = {}
			@driversCoor = []
			@selected.each do |driver|
				loop do
					@driverPos = [1+rand(@n), 1+rand(@n)]
					break unless @driversCoor.include? @driverPos
				end
				@drivers[driver] = @driversList[driver]
				@drivers[driver].x = @driverPos[0]
				@drivers[driver].y = @driverPos[1]
				@driversCoor.push(@driverPos)
			end
		end
		print "\nInsert username: "
		@uName = STDIN.gets.chomp
		@user = User.new(@uName + ".yml", @x, @y)
		
		@map = Map.new(@n, @n, [@x, @y], @driversCoor)
		self.mainMenu
	end
	def mainMenu
		@exit = false
		loop do
			Gem.win_platform? ? (system "cls") : (system "clear")
			puts <<~BANNER
				================================================
					   _____              _____ _ _ 
					  / ____|            / ____| (_)
					 | |  __  ___ ______| |    | |_ 
					 | | |_ |/ _ \\______| |    | | |
					 | |__| | (_) |     | |____| | |
					  \\_____|\\___/       \\_____|_|_|v.0.1.
														
				=================== MAIN MENU ==================
			BANNER
			puts "\nUser\t\t: #{@user.profileName}"
			puts "Your rating\t: #{@user.rating}"
			puts "Accumulated Debt: Rp. #{@user.debt.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}\n\n"
			puts "1. Show Map"
			puts "2. Order Go-Ride"
			puts "3. View History"
			puts "4. Exit"

			@inpt = STDIN.gets.chomp.to_i
			case @inpt
			when 1
				@map.show
			when 2
				Gem.win_platform? ? (system "cls") : (system "clear")
				loop do
					puts "Your current location: (#{@x}, #{@y})"
					puts "Enter destination (x,y): "
					@dest = STDIN.gets.chomp.tr('()','').split(",").collect! { |i| i.to_i }  #CREATE ERROR HANDLING

					#IF LOCATION == USER
					#IF OUT OF BOUNDS
					Gem.win_platform? ? (system "cls") : (system "clear")
					break unless (@dest[0] == @x and @dest[1] == @y) or (@dest[0]<1 or @dest[0]>@n) or (@dest[1]<1 or @dest[1]>@n)
					puts "Invalid coordinate or input!"
					Gem.win_platform? ? (system "cls") : (system "clear")
				end
				puts "===We have found you a driver!====\n\n"
				@newRoute = @map.showRoute([@x, @y], @dest)
				puts("\nRoute:")
				puts @newRoute
				@shortest = -1
				@selected.each do |driver|
					if( ((@x - @drivers[driver].x).abs + (@y - @drivers[driver].y).abs) < @shortest or @shortest == -1)
						@shortest = ((@x - @drivers[driver].x).abs + (@y - @drivers[driver].y).abs)
						@closestDriver = @drivers[driver]
					end

				end
				@shortest = (@x-@dest[0]).abs + (@y-@dest[1]).abs
				# puts "\nYour position: (#{@user.x}, #{@user.y})"
				puts "\nName: #{@closestDriver.driverName}"
				puts "Driver rating: #{@closestDriver.rating}"
				puts "Position: (#{@closestDriver.x}, #{@closestDriver.y})"
				puts "Arrival estimation: #{@shortest} minutes"
				puts "Fare: Rp. #{(@shortest * @cfg.rate).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"

				puts "\nAccept the ride? (y/n): "
				inpt = STDIN.gets.chomp
				if(inpt == "y") #ERROR HANDLING FOR not y/n
					#create new history
					puts "Ride accepted! Your driver will pick you up soon!"
					system "pause"
					Gem.win_platform? ? (system "cls") : (system "clear")
					puts "Ride completed! Please rate your driver (1-5): "
					driverRate = STDIN.gets.chomp.to_f
					@closestDriver.rating = (( (@closestDriver.rating.to_i * @closestDriver.driveCount) + driverRate).to_f / (@closestDriver.driveCount+1).to_f).round(2)
					@user.debt += @shortest * @cfg.rate
					userRate = rand(driverRate.to_i..5)
					@user.rating = ((@user.rating.to_i * @user.rideCount + userRate).to_f / (@user.rideCount+1).to_f).round(2)
					@user.rideCount += 1
					@user.logRides(@shortest, "#{@x},#{@y}", "#{@dest[0]},#{@dest[1]}", @shortest * @cfg.rate, @closestDriver.driverName, driverRate.to_i, userRate.to_i, @newRoute)
					@x = @dest[0]
					@y = @dest[1]
					output = File.new("drivers/drivernames.yml", 'w')
					output.puts YAML.dump(@drivers)
				end
			when 3
				@user.showHistory
			when 4
				puts "Thank you for using Go-Cli!"
				system "pause"
				@exit = true
				Gem.win_platform? ? (system "cls") : (system "clear")
			end
			break if @exit == true
		end
	end
end