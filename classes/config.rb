class Config
	attr_accessor :rate
	attr_accessor :drivers
	attr_accessor :rush_hour_start
	attr_accessor :rush_hour_end
	attr_accessor :finishedTimeDiff
	def initialize(rate, drivers, rush_hour_start, rush_hour_end, finishedTimeDiff)
		@rate = rate
		@drivers = drivers
		@rush_hour_start = rush_hour_start
		@rush_hour_end = rush_hour_end
		@finishedTimeDiff = finishedTimeDiff
	end
end