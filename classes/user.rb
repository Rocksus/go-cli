require_relative 'history'
require 'io/console'
# require 'YAML'

class User
	attr_accessor :profileName
	attr_accessor :x
	attr_accessor :y
	attr_accessor :debt
	attr_accessor :rideCount
	attr_accessor :rating
	attr_accessor :history
	attr_accessor :password
	def initialize(filename, x, y)
		if File.file?("users/"+filename)
			puts "User found in database! Loading files..."
			@history = YAML.load_file("users/"+filename)
			print "Input password(hidden): "
			@password = @history.password
			@inpt = STDIN.noecho(&:gets).chomp
			if(@inpt == @password)
				puts "\nPassword accepted!"
			else
				puts "Wrong password! Please try again"
				system "pause"
				#DO SOMETHING ADD SOMETHING HERE
				exit
			end
		else
			Gem.win_platform? ? (system "cls") : (system "clear")
			print "New user detected!\nInput name: "
			@uName = STDIN.gets.chomp
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
		end
		system("pause")
		@profileName = @history.profileName
		@x = x
		@y = y
		@debt = @history.debt
		@rideCount = @history.rideCount
		@rating = @history.rating
		@outputFile = File.new('users/'+@profileName+'.yml', 'w')
		@outputFile.puts YAML.dump(@history)
	end
	def showHistory
		@iterator=0
		@exit = false
		Gem.win_platform? ? (system "cls") : (system "clear")
		if(@history.rides.length==0)
			puts "\nNo rides yet! Start ordering your ride!\n"
			system "pause"
		else
			while(@exit != true)
				puts "\nDate\t\t: #{@history.rides[@iterator].date}"
				puts "Position\t: (#{@history.rides[@iterator].pos[0]}, #{@history.rides[@iterator].pos[1]})"
				puts "Destination\t: (#{@history.rides[@iterator].dest[0]}, #{@history.rides[@iterator].dest[1]})"
				puts "Start Time\t: #{@history.rides[@iterator].start}"
				puts "Finish Time\t: #{@history.rides[@iterator].finish}"
				puts "Fare\t\t: Rp. #{@history.rides[@iterator].fare}"

				puts "\nRoute:"
				@history.rides[@iterator].routes.each do |s|
					puts "-"+s
				end

				puts "\nYour ride was with #{@history.rides[@iterator].driverName}"
				puts "Your rating to driver: #{@history.rides[@iterator].uToD} stars"
				puts "Driver rating to you: #{@history.rides[@iterator].dToU} stars"

				puts "\nprevious(p) #{@iterator+1}/#{@history.rides.length} next(n) | exit(q)"
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
					if(@iterator<@history.rides.length-1)
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
	def logRides(duration, pos, dest, fare, driverName, uToD, dToU, routes)
		newHistory = History.new(@profileName, @password, @debt, @rideCount, @rating)
		newHistory.rides = @history.rides #just go through it
		newHistory.addRides(duration, pos, dest, fare, driverName, uToD, dToU, routes)
		output = File.new("users/"+@profileName+'.yml', 'w')
		output.puts YAML.dump(@history)	
	end
end

# userBaru = User.new("farhan.yml", 5, 6)
# puts userBaru.profileName
# puts userBaru.x
# puts userBaru.y
# puts userBaru.debt
# puts userBaru.rideCount
# puts userBaru.rating
# userBaru.showHistory
