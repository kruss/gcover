# generates xml output for gcov-data of an workspace

require "core/gcov_analyzer"
require "data/tested_project"
require "statistic/workspace_statistic"
require "statistic/project_statistic"
require "util/xml_util"
require "util/logger"

class WorkspaceXml

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
	end
	
	def outputFile
		return @outputFolder+"/"+$AppName+".xml"
	end
	
	def createXmlOutput(testedProjects)

		# create xml
		xml = XmlUtil.getHeader
		workspaceStatistic = WorkspaceStatistic.new(testedProjects)
		xml << XmlUtil.openTag("workspace", {
			"path"=>@workspaceFolder,
			"lines"=>workspaceStatistic.getTotalLines.to_s,
			"executed"=>workspaceStatistic.getExecutedLines.to_s,
			"missed"=>workspaceStatistic.getMissedLines.to_s,
			"coverage"=>workspaceStatistic.getCoverRatio.to_s
		})
		testedProjects = testedProjects.sort_by{|item| item.projectName}
		testedProjects.each do |testedProject|
		
			projectStatistic = ProjectStatistic.new(testedProject.testedSources)
			xml << XmlUtil.openTag("project", {
				"name"=>testedProject.projectName,
				"lines"=>projectStatistic.getTotalLines.to_s,
				"executed"=>projectStatistic.getExecutedLines.to_s,
				"missed"=>projectStatistic.getMissedLines.to_s,
				"coverage"=>projectStatistic.getCoverRatio.to_s
			})
			testedSources = testedProject.testedSources.sort_by{|item| item.sourceFileName}
			testedSources.each do |testedSource|
			
				sourceStatistic = SourceStatistic.new(testedSource.testedLines)
				xml << XmlUtil.openTag("source", {
					"path"=>testedSource.sourceFileName,
					"lines"=>sourceStatistic.getTotalLines.to_s,
					"executed"=>sourceStatistic.getExecutedLines.to_s,
					"missed"=>sourceStatistic.getMissedLines.to_s,
					"coverage"=>sourceStatistic.getCoverRatio.to_s
				})
				xml << XmlUtil.closeTag("source")
			end
			xml << XmlUtil.closeTag("project")
		
		end
		xml << XmlUtil.closeTag("workspace")
		
		# output
		FileUtil.writeFile(outputFile, xml)
	end
end