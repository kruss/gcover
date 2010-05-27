# generates html output for gcov-data of an workspace

require "core/gcov_analyzer"
require "data/tested_project"
require "statistic/workspace_statistic"
require "statistic/project_statistic"
require "html/project_html"
require "util/html_util"
require "util/logger"

class WorkspaceHtml

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
	end
	
	def outputFile
		return @outputFolder+"/index.htm"
	end
	
	def createHtmlOutput(gcovAnalyzer)
	
		Logger.info "creating output"
		
		workspaceStatistic = WorkspaceStatistic.new(gcovAnalyzer)
		testedProjects = gcovAnalyzer.testedProjects.sort_by{|item| item.projectName}
		untestedProjects = gcovAnalyzer.untestedProjects.sort_by{|item| item}
		
		# header
		html = HtmlUtil.getHeader($AppName)
		html << "<h1>Workspace [ "+@workspaceFolder+" ] - "+workspaceStatistic.getCoverRatio.to_s+" %</h1> \n"

		# total
		html << "<p><font class='small'> \n"	
		html << HtmlUtil.getRatioGraph(workspaceStatistic.getCoverRatio)+" \n"
		html << "<b>Lines</b>: "+workspaceStatistic.getTotalLines.to_s+" / "
		html << "<b>Executed</b>: "+workspaceStatistic.getExecutedLines.to_s+" / "
		html << "<b>Missed</b>: "+workspaceStatistic.getMissedLines.to_s+" \n"
		html << "</font></p> \n"
		html << "<hr> \n"
		
		# tested projects
		html << "<h2>Tested Projects</h2> \n"
		if testedProjects.size() > 0 then
			html << "<table cellspacing=0 cellpadding=5 border=1> \n"
			html << "<tr>"
			html << " <td><b>Project</b></td>"
			html << " <td colspan=2><b>Coverage</b></td>"
			html << "</tr> \n"
			idx = 0
			testedProjects.each do |testedProject|
				idx = idx + 1
				
				projectName = testedProject.projectName
				projectStatistic = ProjectStatistic.new(testedProject)
				
				html << "<tr>"
				if testedProject.internGcov then
					html << "<td>"+idx.to_s+".) <b><a href='"+projectName+"/index.htm'>"+projectName+"</a></b></td>"
				else
					html << "<td>"+idx.to_s+".) <i><a href='"+projectName+"/index.htm'>"+projectName+"</a></i></td>"
				end
				html << "<td class='small'>"
					html << HtmlUtil.getRatioGraph(projectStatistic.getCoverRatio)
					html << "<b>Lines</b>: "+projectStatistic.getTotalLines.to_s+" / "
					html << "<b>Executed</b>: "+projectStatistic.getExecutedLines.to_s+" / "
					html << "<b>Missed</b>: "+projectStatistic.getMissedLines.to_s+" \n"
				html << "</td>"
				html << "<td>"+projectStatistic.getCoverRatio.to_s+" %</td>"
				html << "<tr> \n"
			end
			html << "</table> \n"
		else
			html << "<ul><i>empty</i></ul> \n"
		end
		
		# untested projects
		if untestedProjects.size() > 0 then
			html << "<h2>Untested Projects</h2> \n"
			html << "<ol> \n"
			untestedProjects.each do |untestedProject|
				html << "<li>"+File.basename(untestedProject)+"</li> \n"
			end
			html << "</ol> \n"
		end
		
		# footer
		html << HtmlUtil.getFooter
		
		# output
		HtmlUtil.writeFile(outputFile, html)
		testedProjects.each do |testedProject|
			htmlOutput = ProjectHtml.new(testedProject)
			htmlOutput.createHtmlOutput
		end
	end
end