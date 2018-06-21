class Map
	attr_accessor :width
	attr_accessor :height
	attr_accessor :user
	attr_accessor :drivers
	def initialize(w, h, you, drivers)
		@width = w+2 #for edges
		@height = h+2 #for edges
		@user = you
		@drivers = drivers
	end
	def show
		Gem.win_platform? ? (system "cls") : (system "clear")
		puts "Displaying map..."
		puts "Map size: #{@width}x#{@height}\n"
		print "\n"
		(0...@height).each do |i|
			(0...@width).each do |j|
				@whitespace = true
				if (i==0 and j==0) or (i==@height-1 and j==@width-1) or (i==0 and j==@width-1) or (i==@height-1 and j==0)
					print "+"
				elsif ((i==0 or i==@height-1) and (j>0 and j<@width-1))
					print "-"
				elsif ((j==0 or j==@width-1) and (i>0 and i<@height-1))
					print "|"
				elsif i==@user[0] and j==@user[1]
					print "Y"
				else
					@drivers.each do |dx, dy| 
						@whitespace = (dx == j and dy==i) ? false : true
						if(@whitespace == false)
							print "D"
							break
						end
					end
					if (@whitespace == true)
						print " "
					end
				end
			end
			print "\n"
		end
		system "pause"
	end
	def showRoute(from, to)
		@from = from
		@to = to
		@coors = []
		if(@from[1] > @to[1])
			@lastx = from[0]-1
		else
			@lastx = from[0]+1
		end
		@noX=false
		@noY=false

		if(@from[0] == @to[0])
			@noX = true
		end
		if(@from[1] == @to[1])
			@noY = true
		end
		if(@noX == false)
			if(@from[0] > @to[0]) #horizontally  o    y
				(0..(@from[0]-@to[0]).abs-1).each do |i|
					@coors.push([@from[0]-i, @from[1]])
					@lastx=@from[0]-i
				end
			else # y    o 
				(0..(@from[0]-@to[0]).abs-1).each do |i|
					@coors.push([@from[0]+i, @from[1]])
					if(@from[1]>@to[1])
						@lastx=@from[0]+i
					else
						@lastx=@from[0]+i+2
					end
				end
			end
		end
		if(@noY == false)
			if(@from[1]>@to[1]) #vertically   o      y
				(0..(@from[1]-@to[1]).abs).each do |i|
					if(@from[0]>@to[0])
					@coors.push([@lastx-1, @from[1]-i])
					else
					@coors.push([@lastx+1, @from[1]-i])
					end
				end
			else #y       o
				(0..(@from[1]-@to[1]).abs).each do |i|
					@coors.push([@lastx-1, @from[1]+i])
				end
			end
		end
		puts "Showing Route..."
		(0...@height).each do |i|
			(0...@width).each do |j|
				@whitespace = true
				if (i==0 and j==0) or (i==@height-1 and j==@width-1) or (i==0 and j==@width-1) or (i==@height-1 and j==0)
					print "+"
				elsif ((i==0 or i==@height-1) and (j>0 and j<@width-1))
					print "-"
				elsif ((j==0 or j==@width-1) and (i>0 and i<@height-1))
					print "|"
				elsif j==@to[0] and i==@to[1]
					print "O"
				elsif j==@from[0] and i==@from[1]
					print "Y"
				else
					if(@coors.length>0)
						@coors.each do |dx, dy| 
							@whitespace = (dx == j and dy==i) ? false : true
							if(@whitespace == false)
								print "•"
								break
							end
						end
					end
					if (@whitespace == true)
						print " "
					end
				end
			end
			print "\n"
		end
		@routeList = []
		@routeList.push("Start at ("+@from[0].to_s+","+@from[1].to_s+")")
		if(@from[0]<@to[0])
			@routeList.push("Move to ("+(@from[0]+(@from[0]-@to[0]).abs).to_s+","+@from[1].to_s+")")
			if(@from[1]<@to[1])
				@routeList.push("Turn right")
				@routeList.push("Move to ("+(@from[0]+(@from[0]-@to[0]).abs).to_s+","+(@from[1]+(@from[1]-@to[1]).abs).to_s+")")
			elsif(@from[1]>@to[1])
				@routeList.push("Turn left")
				@routeList.push("Move to ("+(@from[0]+(@from[0]-@to[0]).abs).to_s+","+(@from[1]-(@from[1]-@to[1]).abs).to_s+")")
			end
		elsif(@from[0]>@to[0])
			@routeList.push("Move to ("+(@from[0]-(@from[0]-@to[0]).abs).to_s+","+@from[1].to_s+")")
			if(@from[1]<@to[1])
				@routeList.push("Turn left")
				@routeList.push("Move to ("+(@from[0]-(@from[0]-@to[0]).abs).to_s+","+(@from[1]+(@from[1]-@to[1]).abs).to_s+")")
			elsif(@from[1]>@to[1])
				@routeList.push("Turn right")
				@routeList.push("Move to ("+(@from[0]-(@from[0]-@to[0]).abs).to_s+","+(@from[1]-(@from[1]-@to[1]).abs).to_s+")")
			end
		else
			if(@from[1]<@to[1])
				@routeList.push("Move to ("+@from[0].to_s+","+(@from[1]+(@from[1]-@to[1]).abs).to_s+")")
			elsif(@from[1]>@to[1])
				@routeList.push("Move to ("+@from[0].to_s+","+(@from[1]-(@from[1]-@to[1]).abs).to_s+")")
			end
		end
		@routeList.push("Finish at ("+@to[0].to_s+","+@to[1].to_s+")")
		@routeList
	end
end


# map = Map.new(20, 20, [5, 6], [[2,3], [6,2], [3,9], [16,3], [17,17]])

# map.showRoute([8,7], [8,2])
# map.showRoute([8,7], [16,2])
# map.showRoute([8,7], [16,7])
# map.showRoute([8,7], [16,16])
# map.showRoute([8,7], [8,16])
# map.showRoute([8,7], [4,16])
# map.showRoute([8,7], [4,7])
# map.showRoute([8,7], [4,2])

# map.showRoute([8,2],[8,7])
# map.showRoute([16,2],[8,7])
# map.showRoute([16,7],[8,7])
# map.showRoute([16,16],[8,7])
# map.showRoute([8,16],[8,7])
# map.showRoute([4,16],[8,7])
# map.showRoute([4,7],[8,7])
# map.showRoute([4,2],[8,7])