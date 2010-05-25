
require "data/tested_line"

class SourceStatistic

	def initialize(testedSource)
		
		@testedLines = testedSource.testedLines				# tested lines of source
	end
	
	def getCoverRatio
		total = getExecutedLines + getMissedLines
		ratio = getExecutedLines.to_f / total.to_f * 100
		return sprintf("%.2f", ratio).to_f
	end
	
	def getTotalLines
		return @testedLines.size()
	end
	
	def getIgnoredLines
		count = 0
		@testedLines.each do |testedLine|
			if testedLine.isIgnored then
				count = count + 1
			end
		end
		return count
	end
	
	def getExecutedLines
		count = 0
		@testedLines.each do |testedLine|
			if testedLine.isExecuted then
				count = count + 1
			end
		end
		return count
	end
	
	def getMissedLines
		count = 0
		@testedLines.each do |testedLine|
			if testedLine.isMissed then
				count = count + 1
			end
		end
		return count
	end
end