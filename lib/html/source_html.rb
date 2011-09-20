require "data/tested_source"
require "util/html_util"
require "util/file_util"

class SourceHtml

	def initialize(testedSource, testedSiblings)
		@testedSource = testedSource		# tested-source to generate html for
		@testedSiblings = testedSiblings	# tested-source siblings to link in output
	end
	
	def outputFile
		return @testedSource.outputFolder+"/"+@testedSource.outputFileName
	end
	
	def createHtmlOutput
		
		projectName = @testedSource.projectName
		sourceFileName = @testedSource.sourceFileName
		sourceStatistic = SourceStatistic.new(@testedSource.testedLines)
		
		# header
		html = HtmlUtil.getHeader($AppName)
		html << "<h1><a href='../index.htm'>&lt;&lt;</a> File [ "+sourceFileName+" ] - "+sourceStatistic.getCoverRatio.to_s+" %</h1> \n"
		
		# total
		html << "<p><font class='small'> \n"	
		html << HtmlUtil.getRatioGraph(sourceStatistic.getCoverRatio)+" \n"
		html << "<b>Lines</b>: "+sourceStatistic.getTotalLines.to_s+" / "
		html << "<b>Executed</b>: "+sourceStatistic.getExecutedLines.to_s+" / "
		html << "<b>Missed</b>: "+sourceStatistic.getMissedLines.to_s+" \n"
		html << "</font></p> \n"
		html << "<hr> \n"
		
		# source-siblings
		siblings = @testedSiblings.sort_by{|item| item.outputFileName}
		if siblings.size() > 0 then
			html << "<ul class='small'> \n"
			siblings.each do |sibling|
				html << "<li><a href='"+HtmlUtil.mask_link(sibling.outputFileName)+"'>"+sibling.sourceFileName+"</a></li> \n"
			end
			html << "</ul> \n"
			html << "<hr> \n"
		end	
		
		# coverage
		testedLines = @testedSource.testedLines.sort_by{|item| item.idx}
		if testedLines.size() > 0 then
			html << "<pre style='font-family:monospace'>"
			if testedLines.size() > 0 then
				html << "  I   E   M  \n"
			end
			testedLines.each do |testedLine|
				html << 
					"<b>[ "+
						testedLine.ignored.to_s+" | "+testedLine.executed.to_s+" | "+testedLine.missed.to_s+
					" ]</b> "
				if testedLine.isExecuted then
					html << "<font color='green'>"
				elsif testedLine.isMissed then
					html << "<font color='red'>"
				elsif testedLine.isIgnored then
					html << "<font color='blue'>"
				else
					html << "<font color='black'>"
				end			
				html << sprintf("%3d", testedLine.idx)+":"
				html << "<code>"+HtmlUtil.mask_content(testedLine.content)+"</code>"
				html << "</font> \n"
			end
			if testedLines.size() > 0 then
				html << "  |   |   |  \n"
				html << "  |   |   Missed  \n"
				html << "  |   Executed  \n"
				html << "  Ignored  \n"
			end
			html << "</pre> \n"
		else
			html << "<ul><i>empty</i></ul> \n"
		end
		
		# object-files
		gcovFiles = @testedSource.gcovFiles.sort_by{|item| item}
		if gcovFiles.size() > 0 then
			html << "<h2>Object Files</h2> \n"
			html << "<ul> \n"
			gcovFiles.each do |gcovFile|
				projectName = gcovFile.split("/").reverse[2] # get origin of gcov-file
				fileName = File.basename(gcovFile)
				objectFile = GcovUtil.getObjectPath(gcovFile)
				html << "<li><a href='../../"+projectName+"/gcov/"+HtmlUtil.mask_link(fileName)+"'>"+projectName+"::"+objectFile+"</a></li> \n"
			end
			html << "</ul> \n"
		end

		# footer
		html << HtmlUtil.getFooter
		
		# output
		FileUtil.writeFile(outputFile, html)
	end
end