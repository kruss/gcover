# creates output for gcov-data

require "html/workspace_html"
require "xml/workspace_xml"

class GcovOutput

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
	end
	
	def createOutput(gcovAnalyzer)
	
		Logger.info "create output"
		outputFile = nil
		
		if !$AppOptions[:xml] then
			outputFile = createHtmlOutput(gcovAnalyzer)
			Logger.log "html-output: "+outputFile
		else
			outputFile = createXmlOutput(gcovAnalyzer)
			Logger.log "xml-output: "+outputFile
		end
		
		if outputFile != nil && $AppOptions[:browser] then
		
			Logger.info "open browser"
			begin 
				FileUtil.openBrowser(outputFile)
			rescue 
				Logger.error $!
			end
		end
	end
	
	def createHtmlOutput(gcovAnalyzer)
	
		htmlOutput = WorkspaceHtml.new(@workspaceFolder, @outputFolder)
		htmlOutput.createHtmlOutput(gcovAnalyzer.testedProjects, gcovAnalyzer.untestedProjects)
		return htmlOutput.outputFile
	end
	
	def createXmlOutput(gcovAnalyzer)
	
		xmlOutput = WorkspaceXml.new(@workspaceFolder, ".") # output to current directory
		xmlOutput.createXmlOutput(gcovAnalyzer.testedProjects)
		return xmlOutput.outputFile
	end

end