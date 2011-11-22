# generates xml output for gcov-data of an workspace

require "gcover/core/gcov_analyzer"
require "gcover/data/tested_project"
require "gcover/statistic/workspace_statistic"
require "gcover/statistic/project_statistic"

class WorkspaceXml

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			    # output-folder path
	end
	
	def outputFile
		return @outputFolder+"/"+Feedback.OUTPUT_FILE
	end
	
	def createXmlOutput(testedProjects)

    feedback = Feedback.new()
    testedProjects = testedProjects.sort_by{|item| item.projectName}
    testedProjects.each do |testedProject|
      projectResult = Result.new(testedProject.projectName)
      projectStatistic = ProjectStatistic.new(testedProject.testedSources)
      projectResult.properties["coverage"] = projectStatistic.getCoverRatio.to_s+" %"
      projectResult.properties["lines executed"] = projectStatistic.getExecutedLines.to_s
      projectResult.properties["lines missed"] = projectStatistic.getMissedLines.to_s
      feedback.results << projectResult
    end
    feedback.serialize(outputFile)
    
	end
end