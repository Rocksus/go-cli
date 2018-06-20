require 'YAML'
require_relative 'driver'
require_relative 'user'
require_relative 'map'
require_relative 'genMap'
require_relative 'config'

class System
	def initialize(*args)
		if(args.length == 3) #if there are 3 args
			@n = args[0]
			@x = args[1]
			@y = args[2]
			@cfg = YAML.load_file("../config.yml") #PLEASE ADD ERROR HANDLING
			@driversList = YAML.load_file("../drivers/drivernames.yml") #PLEASE ADD ERROR HANDLING
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
			@mapFile = YAML.load_file("../maps/"+args[0]) #PLEASE ADD ERROR HANDLING
			@n = @mapFile.n
			@x = @mapFile.userX
			@y = @mapFile.userY
			@drivers = @mapFile.drivers
			@driversCoor = @mapFile.driversCoor
		else #if no args
			@n=20
			@x=1+rand(20)
			@y=1+rand(20)
			@driversList = YAML.load_file("../drivers/drivernames.yml") #PLEASE ADD ERROR HANDLING
			@selected = @drivers.keys.sample(@cfg.drivers)
			@driversCoor = []
			@drivers = {}
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
		Gem.win_platform? ? (system "cls") : (system "clear")
		print "Insert username: "
		@uName = gets.chomp
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
			puts "Accumulated Debt: Rp. #{@user.debt.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}\n\n"
			puts "1. Show Map"
			puts "2. Order Go-Ride"
			puts "3. View History"
			puts "4. Exit"

			@inpt = gets.chomp.to_i
			case @inpt
			when 1
				@map.show
			when 2
				Gem.win_platform? ? (system "cls") : (system "clear")
				puts "Your current location: (#{@x}, #{@y})"
				puts "Enter destination (x,y): "
				@dest = gets.chomp.tr('()','').split(",").collect! { |i| i.to_i }
				Gem.win_platform? ? (system "cls") : (system "clear")
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
				puts "\nName: #{@closestDriver.driverName}"
				puts "Position: (#{@closestDriver.x},#{@closestDriver.y})"
				puts "Arrival estimation: #{@shortest} minutes"
				puts "Fare: Rp. #{(@shortest * @cfg.rate).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"

				puts "\nAccept the ride? (y/n): "
				inpt = gets.chomp
				if(inpt == "y") #ERROR HANDLING FOR not y/n
					#create new history
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

admin = System.new(20, 5, 6)