
require "data/tested_source"
require "statistic/source_statistic"

class ProjectStatistic

	def initialize(testedProject)
	
		@testedSources = testedProject.testedSources		# sources with code-coverage
	end
	
	def getCoverRatio
		total = getExecutedLines + getMissedLines
		ratio = getExecutedLines.to_f / total.to_f * 100
		return sprintf("%.2f", ratio).to_f
	end
	
	def getTotalLines
		sum = 0
		@testedSources.each do |testedSource|
			sum = sum + SourceStatistic.new(testedSource).getTotalLines
		end
		return sum
	end
	
	def getIgnoredLines
		sum = 0
		@testedSources.each do |testedSource|
			sum = sum + SourceStatistic.new(testedSource).getIgnoredLines
		end
		return sum
	end
	
	def getExecutedLines
		sum = 0
		@testedSources.each do |testedSource|
			sum = sum + SourceStatistic.new(testedSource).getExecutedLines
		end
		return sum
	end
	
	def getMissedLines
		sum = 0
		@testedSources.each do |testedSource|
			sum = sum + SourceStatistic.new(testedSource).getMissedLines
		end
		return sum
	end
end