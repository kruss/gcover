
require "data/tested_project"
require "statistic/project_statistic"

class WorkspaceStatistic

	def initialize(gcovAnalyzer)
	
		@testedProjects = gcovAnalyzer.testedProjects 			# projects with code-coverage
	end
	
	def getCoverRatio
	
		total = getExecutedLines + getMissedLines
		ratio = getExecutedLines.to_f / total.to_f * 100
		return sprintf("%.2f", ratio).to_f
	end
	
	def getTotalLines
	
		sum = 0
		@testedProjects.each do |testedProject|
			sum = sum + ProjectStatistic.new(testedProject).getTotalLines
		end
		return sum
	end
	
	def getIgnoredLines
	
		sum = 0
		@testedProjects.each do |testedProject|
			sum = sum + ProjectStatistic.new(testedProject).getIgnoredLines
		end
		return sum
	end
	
	def getExecutedLines
	
		sum = 0
		@testedProjects.each do |testedProject|
			sum = sum + ProjectStatistic.new(testedProject).getExecutedLines
		end
		return sum
	end
	
	def getMissedLines
	
		sum = 0
		@testedProjects.each do |testedProject|
			sum = sum + ProjectStatistic.new(testedProject).getMissedLines
		end
		return sum
	end
end