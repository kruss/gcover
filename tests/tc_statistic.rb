$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require 'gcover'

class TcStatistic < Test::Unit::TestCase

	def setup	
	end
	
	def teardown
	end
	
	def test_line_status
	
		line1 = TestedLine.new(-1, nil)
		assert(line1.isIgnored == false)
		assert(line1.isExecuted == false)
		assert(line1.isMissed == false)
		
		line1.ignored = 1
		assert(line1.isIgnored == true)
		assert(line1.isExecuted == false)
		assert(line1.isMissed == false)
		
		line1.missed = 1
		assert(line1.isIgnored == false)
		assert(line1.isExecuted == false)
		assert(line1.isMissed == true)
		
		line1.executed = 1
		assert(line1.isIgnored == false)
		assert(line1.isExecuted == true)
		assert(line1.isMissed == false)
	end
	
	def test_source_statistic
	
		source = TestedSource.new("src-1", nil, nil, nil)
		
		statistic = SourceStatistic.new(source)
		verifyStatistic(statistic, 0, 0, 0, 0, 0.00)
		
		source.testedLines << getSourceLine()
		verifyStatistic(statistic, 1, 0, 0, 0, 0.00)
		
		source.testedLines << getIgnoredSourceLine()
		verifyStatistic(statistic, 2, 1, 0, 0, 0.00)
		
		source.testedLines << getExecutedSourceLine()
		verifyStatistic(statistic, 3, 1, 1, 0, 100.00)
		
		source.testedLines << getMissedSourceLine()
		verifyStatistic(statistic, 4, 1, 1, 1, 50.00)
		
		source.testedLines << getMissedSourceLine()
		verifyStatistic(statistic, 5, 1, 1, 2, 33.33)
		
		source.testedLines << getIgnoredSourceLine()
		verifyStatistic(statistic, 6, 2, 1, 2, 33.33)
	
	end
	
	def test_project_statistic
	
		source1 = TestedSource.new("src-1", nil, nil, nil)
		source2 = TestedSource.new("src-2", nil, nil, nil)
		
		project = TestedProject.new("prj-1", nil, nil)
		project.testedSources << source1
		project.testedSources << source2
		
		statistic = ProjectStatistic.new(project)
		verifyStatistic(statistic, 0, 0, 0, 0, 0.00)
		
		source1.testedLines << getSourceLine()
		verifyStatistic(statistic, 1, 0, 0, 0, 0.00)
		
		source2.testedLines << getIgnoredSourceLine()
		verifyStatistic(statistic, 2, 1, 0, 0, 0.00)
		
		source1.testedLines << getExecutedSourceLine()
		verifyStatistic(statistic, 3, 1, 1, 0, 100.00)
		
		source2.testedLines << getMissedSourceLine()
		verifyStatistic(statistic, 4, 1, 1, 1, 50.00)
		
		source1.testedLines << getMissedSourceLine()
		verifyStatistic(statistic, 5, 1, 1, 2, 33.33)
		
		source2.testedLines << getIgnoredSourceLine()
		verifyStatistic(statistic, 6, 2, 1, 2, 33.33)
	end
	
	def test_workspace_statistic
	
		source11 = TestedSource.new("src-11", nil, nil, nil)
		source12 = TestedSource.new("src-12", nil, nil, nil)
		source21 = TestedSource.new("src-11", nil, nil, nil)
		source22 = TestedSource.new("src-12", nil, nil, nil)
		
		project1 = TestedProject.new("prj-1", nil, nil)
		project1.testedSources << source11
		project1.testedSources << source12
		
		project2 = TestedProject.new("prj-3", nil, nil)
		project2.testedSources << source21
		project2.testedSources << source22
		
		analyzer = GcovAnalyzer.new(nil, nil)
		analyzer.testedProjects << project1
		analyzer.testedProjects << project2
		
		statistic = WorkspaceStatistic.new(analyzer)
		verifyStatistic(statistic, 0, 0, 0, 0, 0.00)
		
		source11.testedLines << getSourceLine()
		verifyStatistic(statistic, 1, 0, 0, 0, 0.00)
		
		source12.testedLines << getIgnoredSourceLine()
		verifyStatistic(statistic, 2, 1, 0, 0, 0.00)
		
		source21.testedLines << getExecutedSourceLine()
		verifyStatistic(statistic, 3, 1, 1, 0, 100.00)
		
		source22.testedLines << getMissedSourceLine()
		verifyStatistic(statistic, 4, 1, 1, 1, 50.00)
		
		source11.testedLines << getMissedSourceLine()
		verifyStatistic(statistic, 5, 1, 1, 2, 33.33)
		
		source22.testedLines << getIgnoredSourceLine()
		verifyStatistic(statistic, 6, 2, 1, 2, 33.33)
	end
	
private

	def getSourceLine()
		line = TestedLine.new(-1, nil)
		return line
	end
	
	def getIgnoredSourceLine()
		line = TestedLine.new(-1, nil)
		line.ignored = 1
		return line
	end
	
	def getExecutedSourceLine()
		line = TestedLine.new(-1, nil)
		line.executed = 1
		return line
	end
	
	def getMissedSourceLine()
		line = TestedLine.new(-1, nil)
		line.missed = 1
		return line
	end
	
	def verifyStatistic(statistic, totalLines, ignoredLines, executedLines, missedLines, coverRatio)
	
		assert_equal(totalLines, statistic.getTotalLines)
		assert_equal(ignoredLines, statistic.getIgnoredLines)
		assert_equal(executedLines, statistic.getExecutedLines)
		assert_equal(missedLines, statistic.getMissedLines)
		assert_equal(coverRatio, statistic.getCoverRatio)
	end
end