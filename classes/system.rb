require 'YAML'
require_relative 'driver'
require_relative 'user'
require_relative 'map'
require_relative 'genMap'
require_relative 'config'

class System
	def initialize(*args)
		if File.exists?("./config.yml")
				@cfg = YAML.load_file("./config.yml")
			else
				Gem.win_platform? ? (system "cls") : (system "clear")
				puts "Can't find config data! Generate a new config with generateConfig.rb!"
				system "pause"
				exit
			end
		if(args.length == 3) #if there are 3 args
			@n = args[0].to_i
			@x = args[1].to_i
			@y = args[2].to_i
			@driversList = {}
			if Dir.glob("drivers/*.yml").length>=@cfg.drivers
				Dir.glob("drivers/*.yml") do |driverFile|
					driverObj = YAML.load_file(driverFile)
					@driversList[driverObj.driverName] = driverObj
				end
			else
				Gem.win_platform? ? (system "cls") : (system "clear")
				puts "Can't find enough driver data! Please generate more with createDriver.rb!"
				system "pause"
				exit
			end
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
			if File.exists?("maps/"+args[0])
				@mapFile = YAML.load_file("maps/"+args[0])
			else
				Gem.win_platform? ? (system "cls") : (system "clear")
				puts "Can't find any map data! Generate a new map with generateMap.rb!"
				system "pause"
				exit
			end
			@n = @mapFile.n
			@x = @mapFile.userX
			@y = @mapFile.userY
			@drivers = @mapFile.drivers
			@driversCoor = @mapFile.driversCoor
		else #if no args
			@n=20
			@x=1+rand(20)
			@y=1+rand(20)
			@driversList = {}
			if Dir.glob("drivers/*.yml").length>=@cfg.drivers
				Dir.glob("drivers/*.yml") do |driverFile|
					driverObj = YAML.load_file(driverFile)
					@driversList[driverObj.driverName] = driverObj
				end
			else
				Gem.win_platform? ? (system "cls") : (system "clear")
				puts "Can't find enough driver data! Please generate more with createDriver.rb!"
				system "pause"
				exit
			end
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
		loop do
			@uName = STDIN.gets.chomp
			break if(@uName.length > 2)
			puts "Invalid username! Minimal 2 characters long!"
		end
		@user = User.new(@uName, @x, @y)
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
					@dest = STDIN.gets.chomp.tr('()','').split(",").collect! { |i| i.to_i }
					Gem.win_platform? ? (system "cls") : (system "clear")
					break unless @dest.length<2 or ((@dest[0] == @x and @dest[1] == @y) or (@dest[0]<1 or @dest[0]>@n) or (@dest[1]<1 or @dest[1]>@n))
					if(@dest[0]==@x and @dest[1]==@y)
						puts"Why do you want to go there when you are already there?"
					else
						puts "Invalid coordinate or input!"
					end	
				end
				puts "===We have found you a driver!====\n\n"
				@shortest = -1
				@bestRating = 0.0
				@selected.each do |driver|
					if( ( (@x - @drivers[driver].x).abs + (@y - @drivers[driver].y).abs) < @shortest or @shortest == -1 or (@drivers[driver].rating > @bestRating and ( (@x - @drivers[driver].x).abs + (@y - @drivers[driver].y).abs ) == @shortest))
						@shortest = ((@x - @drivers[driver].x).abs + (@y - @drivers[driver].y).abs)
						@closestDriver = @drivers[driver]
						@bestRating = @drivers[driver].rating
					end
				end
				@newRoute = @map.showRoute([@x, @y], @dest, [@closestDriver.x, @closestDriver.y])
				puts("\nRoute:")
				puts @newRoute
				@shortestDriver = @shortest
				@shortest = (@x-@dest[0]).abs + (@y-@dest[1]).abs
				# puts "\nYour position: (#{@user.x}, #{@user.y})"
				puts "\nName: #{@closestDriver.driverName}"
				puts "Driver rating: #{@closestDriver.rating}"
				puts "Position: (#{@closestDriver.x}, #{@closestDriver.y})"
				puts "Pickup estimation: #{@shortestDriver} minutes"
				puts "Arrival to destination estimation: #{@shortestDriver + @shortest} minutes"
				puts "Fare: Rp. #{(@shortest * @cfg.rate).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse}"

				puts "\nAccept the ride? (y/n): "
				loop do
					@inpt = STDIN.gets.chomp
					break if(@inpt == "y" or @inpt=="n")
				end
				if(@inpt == "y") #ERROR HANDLING FOR not y/n
					#create new history
					puts "Ride accepted! Your driver will pick you up soon!"
					system "pause"
					Gem.win_platform? ? (system "cls") : (system "clear")
					puts "Ride completed! Please rate your driver (1-5): "
					loops do
						driverRate = STDIN.gets.chomp.to_f
						break if(driverRate.to_i>0)
						puts "Please enter a valid rating!"
					end
					@closestDriver.rating = (( (@closestDriver.rating.to_i * @closestDriver.driveCount) + driverRate).to_f / (@closestDriver.driveCount+1).to_f).round(2)
					@user.debt += @shortest * @cfg.rate
					userRate = rand(driverRate.to_i..5)
					@user.rating = ((@user.rating.to_i * @user.rideCount + userRate).to_f / (@user.rideCount+1).to_f).round(2)
					@user.rideCount += 1
					@user.logRides(@shortest+@shortestDriver, "#{@x},#{@y}", "#{@dest[0]},#{@dest[1]}", @shortest * @cfg.rate, @closestDriver.driverName, driverRate.to_i, userRate.to_i, @newRoute)
					@x = @dest[0]
					@y = @dest[1]
					output = File.new("drivers/"+@closestDriver.driverName+".yml", 'w')
					output.puts YAML.dump(@closestDriver)
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