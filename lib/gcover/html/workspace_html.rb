# generates html output for gcov-data of an workspace

require "gcover/core/gcov_analyzer"
require "gcover/data/tested_project"
require "gcover/statistic/workspace_statistic"
require "gcover/statistic/project_statistic"
require "gcover/html/project_html"
require "gcover/util/html_util"
require "gcover/util/file_util"

class WorkspaceHtml

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			    # output-folder path
	end
	
	def outputFile
		return @outputFolder+"/index.htm"
	end
	
	def createHtmlOutput(testedProjects, untestedProjects)
		
		workspaceStatistic = WorkspaceStatistic.new(testedProjects)
		
		# header
		html = HtmlUtil.getHeader($AppName)
		html << "<h1>"+$AppNameUI+" [ "+@workspaceFolder+" ] - "+workspaceStatistic.getCoverRatio.to_s+" %</h1> \n"

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
		testedProjects = testedProjects.sort_by{|item| item.projectName}
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
				projectStatistic = ProjectStatistic.new(testedProject.testedSources)
				
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
		untestedProjects = untestedProjects.sort_by{|item| item}
		if untestedProjects.size() > 0 then
			html << "<h2>Untested Projects</h2> \n"
			html << "<ol> \n"
			untestedProjects.each do |untestedProject|
				html << "<li>"+File.basename(untestedProject)+"</li> \n"
			end
			html << "</ol> \n"
		end
		
    # logfile
    if FileTest.file?("#{$AppOptions[:output]}/#{$AppName}.log") then
      html << "<p> \n"
      html << "<a href='"+$AppName+".log'>Logfile</a> \n"
      html << "</p> \n"
    end
   
		# footer
		html << HtmlUtil.getFooter
		
		# output
		FileUtil.writeFile(outputFile, html)
		testedProjects.each do |testedProject|
			htmlOutput = ProjectHtml.new(testedProject)
			htmlOutput.createHtmlOutput
		end
	end
end