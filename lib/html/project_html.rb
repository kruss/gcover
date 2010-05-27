require "data/tested_project"
require "data/tested_source"
require "statistic/project_statistic"
require "statistic/source_statistic"
require "html/source_html"
require "util/html_util"
require "util/file_util"

class ProjectHtml

	def initialize(testedProject)
		@testedProject = testedProject	# tested-project to generate html for
	end
	
	def outputFile
		return @testedProject.outputFolder+"/index.htm"
	end
	
	def createHtmlOutput
		
		projectName = @testedProject.projectName
		projectStatistic = ProjectStatistic.new(@testedProject.testedSources)
		
		# header
		html = HtmlUtil.getHeader($AppName)
		html << "<h1><a href='../index.htm'>&lt;&lt;</a> Project [ "+projectName+" ] - "+projectStatistic.getCoverRatio.to_s+" %</h1> \n"

		# total
		html << "<p><font class='small'> \n"		
		html << HtmlUtil.getRatioGraph(projectStatistic.getCoverRatio)+" \n"
		html << "<b>Lines</b>: "+projectStatistic.getTotalLines.to_s+" / "
		html << "<b>Executed</b>: "+projectStatistic.getExecutedLines.to_s+" / "
		html << "<b>Missed</b>: "+projectStatistic.getMissedLines.to_s+" \n"
		html << "</font></p> \n"
		html << "<hr> \n"
		
		# tested
		html << "<h2>Tested Files</h2> \n"
		testedSources = @testedProject.testedSources.sort_by{|item| item.sourceFileName}
		if testedSources.size() > 0 then
			html << "<table cellspacing=0 cellpadding=5 border=1> \n"
			html << "<tr>"
			html << " <td><b>Source File</b></td>"
			html << " <td colspan=2><b>Coverage</b></td>"
			html << "</tr> \n"
			idx = 0
			testedSources.each do |testedSource|
				idx = idx + 1
				
				sourceFileName = testedSource.sourceFileName
				outputFileName = testedSource.outputFileName
				sourceStatistic = SourceStatistic.new(testedSource.testedLines)

				html << "<tr>"
				html << "<td>"+idx.to_s+".) <a href='html/"+HtmlUtil.urlencode(outputFileName)+"'>"+sourceFileName+"</a></td>"
				html << "<td class='small'>"
					html << HtmlUtil.getRatioGraph(sourceStatistic.getCoverRatio)
					html << "<b>Lines</b>: "+sourceStatistic.getTotalLines.to_s+" / "
					html << "<b>Executed</b>: "+sourceStatistic.getExecutedLines.to_s+" / "
					html << "<b>Missed</b>: "+sourceStatistic.getMissedLines.to_s+" \n"
				html << "</td>"
				html << "<td>"+sourceStatistic.getCoverRatio.to_s+" %</td>"
				html << "<tr> \n"
			end
			html << "</table> \n"
		else
			html << "<ul><i>empty</i></ul> \n"
		end
		
		# untested
		untestedSources = @testedProject.untestedSources.sort_by{|item| item}
		if untestedSources.size() > 0 then
			html << "<h2>Untested Files</h2> \n"
			html << "<ol> \n"
			untestedSources.each do |untestedSource|
			
				filePath = Pathname.new(untestedSource).relative_path_from(Pathname.new(@testedProject.projectFolder)).cleanpath.to_s
				html << "<li>"+filePath+"</li> \n"
			end
			html << "</ol> \n"
		end
		
		# excluded
		excludedSources = @testedProject.excludedSources.sort_by{|item| item}
		if excludedSources.size() > 0 then
			html << "<h2>Excluded Files</h2> \n"
			html << "<ol> \n"
			excludedSources.each do |excludedSource|
			
				filePath = Pathname.new(excludedSource).relative_path_from(Pathname.new(@testedProject.projectFolder)).cleanpath.to_s
				html << "<li>"+filePath+"</li> \n"
			end
			html << "</ol> \n"
		end
		
		# footer
		html << HtmlUtil.getFooter
		
		# output
		FileUtil.writeFile(outputFile, html)
		testedSources = @testedProject.testedSources
		testedSources.each do |testedSource|
			testedSiblings = getTestedSiblings(testedSources, testedSource)
			htmlOutput = SourceHtml.new(testedSource, testedSiblings)
			htmlOutput.createHtmlOutput
		end
	end
	
	# finds the siblings of a tested-source within given list
	def getTestedSiblings(testedSources, testedSource)
	
		sourceName = File.basename(testedSource.sourceFile, File.extname(testedSource.sourceFile))
		sourceFullName = File.basename(testedSource.sourceFile)
			
		siblings = Array.new	
		testedSources.each do |source|
			fullName = File.basename(source.sourceFile)
			name = File.basename(source.sourceFile, File.extname(source.sourceFile))
			if 
				fullName != sourceFullName && name == sourceName  
			then
				siblings << source
			end
		end
		return siblings
	end
end