class GeneratedMap
	attr_accessor :n
	attr_accessor :userX
	attr_accessor :userY
	attr_accessor :drivers
	attr_accessor :driversCoor
	def initialize
		puts "n?"
		@n = gets.chomp.to_i
		puts "User position? (x,y)"
		@pos = gets.chomp.tr('()','').split(",").collect! { |i| i.to_i }
		@userX = @pos[0]
		@userY = @pos[1]
		@driversCoor = []
		@driversList = YAML.load_file("drivers/drivernames.yml")
			@selected = @driversList.keys.sample(5)
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
end