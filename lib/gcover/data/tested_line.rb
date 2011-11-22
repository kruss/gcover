
class TestedLine

	def initialize(idx, content)
		@idx = idx
		@content = content
		@ignored = 0
		@executed = 0
		@missed = 0
	end

	attr_accessor :idx
	attr_accessor :content
	attr_accessor :ignored
	attr_accessor :executed
	attr_accessor :missed
	
	def isIgnored
		return @ignored > 0 && @executed == 0 && @missed == 0
	end
	
	def isExecuted
		return @executed > 0
	end
	
	def isMissed
		return @missed > 0 && @executed == 0
	end
end