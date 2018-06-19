require 'YAML'
require_relative 'driver'
require_relative 'user'
require_relative 'map'
require_relative 'genMap'

class System
	def initialize(*args)
		if(args.length == 3) #if there are 3 args
			@n = args[0]
			@x = args[1]
			@y = args[2]
			@driversList = YAML.load_file("../drivers/drivernames.yml")
			@selected = @driversList.keys.sample(5)
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
			@mapFile = YAML.load_file("../maps/"+args[0])
			@n = @mapFile.n
			@x = @mapFile.userX
			@y = @mapFile.userY
			@drivers = @mapFile.drivers
			@driversCoor = @mapFile.driversCoor
		else #if no args
			@n=20
			@x=1+rand(20)
			@y=1+rand(20)
			@driversList = YAML.load_file("../drivers/drivernames.yml")
			@selected = @drivers.keys.sample(5)
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
				@routeCoor = @map.showRoute([@x, @y], @dest)
				@changingX = false
				@changingY = false
				@changeDetect = false
				@lastX = @routeCoor[0][0]
				@lastY = @routerCoor[0][1]
				@newRoute = []
				@newRoute.push([@lastX, @lastY])
				@routeCoor.each do |x, y|
					if (@lastX!=x and @changingX == false)
						@changingX = true
						@changingY = false
						@changeDetect = true
					end
					if (@lastY!=y and @changingY == false)
						@changingY = true
						@changingX = false
						@changeDetect = true
					end
					if @changeDetect == true
						# newRoute.push("Move to ("+lastX.to_s +","+lastY.to_s+")")
						@newRoute.push([@lastX, @lastY])
						@changeDetect = false
					end
					@lastX = x
					@lastY = y
				end
				@newRoute.push([@routeCoor[@routeCoor.length-1][0], @routeCoor[@routeCoor.length-1][1]])
				puts @newRoute
				system "pause"
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