# generates xml output for gcov-data of an workspace

require "core/gcov_analyzer"
require "data/tested_project"
require "statistic/workspace_statistic"
require "statistic/project_statistic"
require "util/sys_logger"

class WorkspaceXml

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
	end
	
	def outputFile
		return @outputFolder+"/"+Feedback::Feedback.OUTPUT_FILE
	end
	
	def createXmlOutput(testedProjects)

    feedback = Feedback::Feedback.new()
    testedProjects = testedProjects.sort_by{|item| item.projectName}
    testedProjects.each do |testedProject|
      projectResult = Feedback::Result.new(testedProject.projectName)
      projectStatistic = ProjectStatistic.new(testedProject.testedSources)
      projectResult.values["coverage"] = projectStatistic.getCoverRatio.to_s+" %"
      projectResult.values["lines executed"] = projectStatistic.getExecutedLines.to_s
      projectResult.values["lines missed"] = projectStatistic.getMissedLines.to_s
      feedback.results << projectResult
    end
    feedback.serialize(outputFile)
    
	end
end