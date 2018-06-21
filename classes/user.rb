require_relative 'history'
require 'io/console'

class User
	attr_accessor :profileName
	attr_accessor :x
	attr_accessor :y
	attr_accessor :debt
	attr_accessor :rideCount
	attr_accessor :rating
	attr_accessor :history
	attr_accessor :password
	attr_accessor :rides
	def initialize(filename, x, y)
		@rides = []
		if File.file?("users/"+filename+"/"+filename+".yml")
			puts "User found in database! Loading files..."
			@history = YAML.load_file("users/"+filename+"/"+filename+".yml")
			print "Input password(hidden): "
			@password = @history.password
			3.downto(1) do |i|
				@inpt = STDIN.noecho(&:gets).chomp
				break if (@inpt == @password)
				puts "Invalid password! Please try again! Tries left: #{i}"
			end
			if(@inpt == @password)
				puts "\nPassword accepted!"
			else
				puts "Wrong password! Please restart the app!"

				#DO SOMETHING ADD SOMETHING HERE
				exit
			end
		else
			Gem.win_platform? ? (system "cls") : (system "clear")
			print "New user detected!\nInput name: "
			loop do
				@uName = STDIN.gets.chomp.capitalize #REGEX ERROR HANDLING
				break if (@uName.length > 2)
				puts "Error! Please input a name with more than 2 characters!"
			end
			print "Enter password(hidden): "
			@password = STDIN.noecho(&:gets).chomp
			loop do
				puts "\nConfirm password: "
				@confirmPass = STDIN.noecho(&:gets).chomp
				break if @password == @confirmPass
				Gem.win_platform? ? (system "cls") : (system "clear")
				puts "Wrong input! Confirm password by retyping the password"
			end
			Gem.win_platform? ? (system "cls") : (system "clear")
			puts "Welcome aboard, #{@uName}. Enjoy using Go-Cli!"
			@history = History.new(@uName, @password, 0, 0, 0)
			Dir.mkdir("users/"+filename) unless File.exists?("users/"+filename)
			Dir.mkdir("users/"+filename+"/rides") unless File.exists?("users/"+filename+"/rides")
		end
		system("pause")
		@profileName = @history.profileName
		@x = x
		@y = y
		@debt = @history.debt
		@rideCount = @history.rideCount
		@rating = @history.rating
		@outputFile = File.new('users/'+@profileName+"/"+@profileName+'.yml', 'w')
		@outputFile.puts YAML.dump(@history)
		Dir.glob("users/#{@profileName}/rides/*.yml") do |rideLogs|
			@rides.push( YAML.load_file(rideLogs) )
		end
	end
	def showHistory
		@iterator=0
		@exit = false
		Gem.win_platform? ? (system "cls") : (system "clear")
		if(@rides.length==0)
			puts "\nNo rides yet! Start ordering your ride!\n"
			system "pause"
		else
			while(@exit != true)
				puts "\nDate\t\t: #{@rides[@iterator].date}"
				puts "Position\t: (#{@rides[@iterator].pos[0]}, #{@rides[@iterator].pos[1]})"
				puts "Destination\t: (#{@rides[@iterator].dest[0]}, #{@rides[@iterator].dest[1]})"
				puts "Start Time\t: #{@rides[@iterator].start}"
				puts "Finish Time\t: #{@rides[@iterator].finish}"
				puts "Fare\t\t: Rp. #{@rides[@iterator].fare}"

				puts "\nRoute:"
				@rides[@iterator].routes.each do |s|
					puts "-"+s
				end

				puts "\nYour ride was with #{@rides[@iterator].driverName}"
				puts "Your rating to driver: #{@rides[@iterator].uToD} stars"
				puts "Driver rating to you: #{@rides[@iterator].dToU} stars"

				puts "\nprevious(p) #{@iterator+1}/#{@rides.length} next(n) | exit(q)"
				@inpt = STDIN.gets.chomp
				Gem.win_platform? ? (system "cls") : (system "clear")
				case @inpt
				when 'p'
					if(@iterator>0)
						@iterator-=1
					else
						puts "=You are already in the first page!="
					end
				when 'n'
					if(@iterator<@rides.length-1)
						@iterator+=1
					else
						puts "=You are already in the last page!="
					end
				when 'q'
					break
				end
			end
		end
	end
	def addRides(duration, pos, dest, fare, driverName, uToD, dToU, routes)
		ntime = Time.now.to_s.split(" ")
		date = ntime[0]
		start = ntime[1]
		addTime = duration
		finish = (Time.now + addTime*60).to_s.split(" ")[1]
		pos = pos.split(",").each { |e| e.to_i }
		dest = dest.split(",").each { |e| e.to_i }
		fare = fare
		driverName = driverName
		uToD = uToD
		dToU = dToU
		routes = routes
		newRide = Ride.new(date, start, finish, pos, dest, fare, driverName, uToD, dToU, routes)
		@rides.push(newRide)
		output = File.new("users/"+@profileName+"/rides/ride_"+@rideCount.to_s+'.yml', 'w')
		output.puts YAML.dump(newRide)
	end
	def logRides(duration, pos, dest, fare, driverName, uToD, dToU, routes)
		newHistory = History.new(@profileName, @password, @debt, @rideCount, @rating)
		output = File.new("users/"+@profileName+"/"+@profileName+'.yml', 'w')
		output.puts YAML.dump(newHistory)
		addRides(duration, pos, dest, fare, driverName, uToD, dToU, routes)
	end
end