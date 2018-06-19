Drivers:
Name
driveCount
rating
x
y

Users:
Each user has self .yml file
Debts: (since we have no clear way to determine how many money a user has, lets just say how many money the user owes the company)
Rides: Amount of rides user has
Rating: User rating from driver (UHHHHH..... weighed random, or attitude minigame)
History: Contains each of the rides user has ever done:
		- initpos
		- destination
		- distance
		- timestamp (start, finish)
		- fare
		- user's rating to driver
		- driver's rating to user
x
y

Admin CFG:
Rates
Amount of drivers
Default map 20
Rush hour start
Rush hour end
timestamp +-

Map Class:
	Self.show:
		system clear
		prints the map for the user
	
	###FORMAT###
	
	Showing Map...

	+----------+
	|          |
	|       D  |
	|          |
	|D       D |
	|          |
	|    Y     |
	|          |
	|      D   |
	|D         |
	|          |
	+----------+

	system "pause"
	Self.showRoute:
		system clear
		prints map with route

Driver class:
	name:
	ratings = []
	rating:
	@x
	@y

	Driver.rate:
		input rating to driver
		driver gives rating to user (either attitude minigame during the trip or just heuristics)


User class:
	name:
	driveTaken:
	rating:
	history (hash):
		initpos
		destination
		distance
		start
		finish
		route (array)
		fare
		userrating
		driverrating
	def showHistory:
		Show all driving history

	###### FORMAT #######

	Date		: 6/9/12
	Position	: (4,5)
	Destination	: (8,16)
	Start Time	: 05:00
	Finish Time	: 05.34
	Fare		: Rp. 34.000
	
	Route:
	-Start at (1,2)
	-Go to (1,4)
	-Turn Right
	-Go to (1,5)
	-Finish at (1,5)

	Your ride was with #{drivername}
	Your rating to #{drivername}: 5
	Driver rating to you: 5

	previous(p) 1/34 next(n) | exit(q)




System class:
	@rate
	@finishtimediff
	@rushHourEnd
	@rushHourStart
	drivers = {} (HASH)
	Map = new Map
	Users = new User("userfile.bin")
	self.mainMenu:
		Show Map
		Order Go Ride
		View History
		Exit
		if(showmap) Map.show
		if(order go ride) Self.findDriver
		if(view history) User.ShowHistory
		if(exit) Self.exit


		###FORMAT###

		================================================		
			   _____              _____ _ _ 
			  / ____|            / ____| (_)
			 | |  __  ___ ______| |    | |_ 
			 | | |_ |/ _ \______| |    | | |
			 | |__| | (_) |     | |____| | |
			  \_____|\___/       \_____|_|_|v.0.1.

		=================== MAIN MENU ===================
		
		User			: Farhan
		Accumulated Debt: Rp. 39.0000

		1. Show Map
		2. Order Go Ride
		3. View History
		4. Exit

		_ <-input


	Self.findDriver:
		Loops through driver list and compares with user range
		Find distance
		calculate fare (distance * rate)
		if(rushhourstart <= time <= rushHourEnd) fare * 1.25
		show fare and distance
		
		###FORMAT###

		===We have found you a driver!===

		+----------+
		|          |
		|       D  | 
		|          |
		|D   --- D |
		|    |     |
		|    Y     |
		|          |
		|      D   |
		|D         |
		|          |
		+----------+

		Route:
		-Start at (1,2)
		-Go to (1,4)
		-Turn Right
		-Go to (1,5)
		-Finish at (1,5)

		Name: #{drivername}
		Position: (x,y)
		Arrival estimation: (just calculate distance of driver to user)
		Fare: 34.000 (if rush hour print("(RUSH HOUR)"))

		Do you accept? (y/n)
		_
		
		####

		Await for confirmation
		if(yes)
			accepted!

			###FORMAT###
			Ride accepted! Please wait for your Go-Ride to arrive!
			
			+----------+
			|          |
			|       D  |
			|          |
			|D   --- D |
			|    |     |
			|    Y     |
			|          |
			|      D   |
			|D         |
			|          |
			+----------+
			
			Route:
			-Start at (1,2)
			-Go to (1,4)
			-Turn Right
			-Go to (1,5)
			-Finish at (1,5)

			Name: #{drivername}
			License Plate: #{plate}
			Vehicle Model: #{vehicle}
			Position: (x,y)
			Arrival estimation: (just calculate distance of driver to user)


			system "pause"
			cls
			Puts "Your driver has arrived!"
			system "pause"
			cls
			###EITHER GO MINIGAME OR JUST FINISH###
			finish, get timestamp +- by a heck percent
			self.drivers[@select].rate
			save changes to file (user and driver)
			go back to home
		else
			go back to main Menu
	Self.exit:
		puts "Thank you for using Go-Cli v.0.1."
		puts "Exiting the app.."
		exit


