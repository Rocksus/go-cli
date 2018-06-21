# Go-cli #
For the compfest software engineering academy.


## Usage
```sh
ruby go-cli.rb "mapName.yml"
```
>Starts the program with a predefined map name.
```sh
ruby go-cli.rb n x y
```
>Starts the program with nxn spaces, and puts the user position in (x,y).
```sh 
ruby go-cli.rb
```
>Starts the program with 20x20 maps, randoms the user position.


## Concept
#### > Assumptions
I assumed that since we are handling with a user, we need a way to store them in an orderly manner. Hence is why I decided to create the database for users. A login username and password would be necessary. The password input should obviously be hidden for privacy (no, I did not go as far as encrypting the password.). A lot of system clears were used to make a clean UI. As the users were all made individual, I also need to save the drivers data. Initially I wanted to create the drivers as a single file. But after I stumped on the limitations of the YAML parser (it tends to fail the parse on a very long list), I decided to create the drivers individually aswell.

For the users, I stored the name, password, ride counts, rating, rides history (in a separate file), and debt. Yes, debt. I assumed that since a payment system was required, and the users has no (or atleast there were no options) way to make money, so I opted to use debt as a currency. Creating a working option would alter its use solely as a gojek App, and adding a top-up option was not required within the 3 options (where's the humor in that anyways?).

A good program needs a good UI, that is why I also focused on making the main menu, maps, and other properties that are displayed to look pleasing. The routes are showed both in text form and inside the map. Calculating the distance between coordinates was done by using Taxicab Geometry, the turning was affixed to a nested if, since there were no collisions. The assignment also did not specify what happens when another driver is in the way of a route. So I opted to just ignore the problem.

Showing the history would never be nice if we were printing all of them at once. So I thought that it's better to make it in a sequence, going next or previous by an iterator.

#### > Design
I will divide this section in 2, UI design and structural design.
##### >>UI Design
UI design, as I mentioned earlier, would be important.

Main menu, for example:
```sh
================================================		
    	   _____              _____ _ _ 
    	  / ____|            / ____| (_)
    	 | |  __  ___ ______| |    | |_ 
    	 | | |_ |/ _ \______| |    | | |
    	 | |__| | (_) |     | |____| | |
    	  \_____|\___/       \_____|_|_|v.0.1.

=================== MAIN MENU ===================
		
		User			: Farhan
		Your rating     : 4.57
		Accumulated Debt: Rp. 39.000

		1. Show Map
		2. Order Go Ride
		3. View History
		4. Exit

		_ <-input
```
Adding the text art would make the main menu look way better. I also displayed the name, rating, and accumulated debt on the main menu, since those are usually displayed in the main menu.

Map design:
```sh
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
```

Map when showing route:
```sh
+----------+
|    •••O  |
|    •     | 
|    •     |
|    •     |
|    •     |
|    Y     |
|          |
|      D   |
|          |
|          |
+----------+
```
It would only show the closest driver possible (if they have the same range, we choose by the rating) 

The rest involved with a lot of system clears and just texts with options.

##### >> Structural Design
Go-Cli.rb itself only accepts the initial arguments, then passes it down the System class. Inside the system class, it generates a map(or loads one), sets the user position, and taking drivers according to the config class (config class contains fare rate, rush hour (unimplemented), max drivers, and so on). The User class has a 2 separate classes inside it, the History class and the Rides class. History class was created to store the User's core data (name, password, debt, etc), while the Rides class stores each individual rides the user has. The way I saved the users class was inside the users folder. Which inside of that folder, I created individual folders for each user. History and rides are kept separate for avoiding the parsing error, and each rides were also separated for avoiding the same problem (It has scarred me with long hours staring blankly at google).

For the drivers, I only store their names, ridecount, and rating. Each driver were saved individually to avoid the parser error. To generate the drivers, I chose to create a new ruby script to convert the names from drivernames.bin into a separate driver data.

As for the map, I chose to show the routes with the bullet alt code •, to make the routes easier to draw. The user position and driver position are ensured to be always different (with an endless loop until they are unique to each other, or if they were specified in the initial start of the program).

The whole program is looping inside the mainMenu method from System, and exits only when the user chooses the exit option.