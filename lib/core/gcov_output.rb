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
			createXmlOutput(gcovAnalyzer, @outputFolder)
			outputFile = createHtmlOutput(gcovAnalyzer, @outputFolder)
		else
			outputFile = createXmlOutput(gcovAnalyzer, ".")
		end
		
		if outputFile != nil && $AppOptions[:browser] then
			Logger.log "open browser"
			begin 
				FileUtil.openBrowser(outputFile)
			rescue 
				Logger.error $!
			end
		end
	end
	
	def createHtmlOutput(gcovAnalyzer, outputFolder)
	
		htmlOutput = WorkspaceHtml.new(@workspaceFolder, outputFolder)
		htmlOutput.createHtmlOutput(gcovAnalyzer.testedProjects, gcovAnalyzer.untestedProjects)
		Logger.log "html-output: "+htmlOutput.outputFile
		return htmlOutput.outputFile
	end
	
	def createXmlOutput(gcovAnalyzer, outputFolder)
	
    begin
      require "feedback"
    rescue Exception => e
      Logger.error e.message
      return nil
    end
    
		xmlOutput = WorkspaceXml.new(@workspaceFolder, outputFolder)
		xmlOutput.createXmlOutput(gcovAnalyzer.testedProjects)
		Logger.log "xml-output: "+xmlOutput.outputFile
		return xmlOutput.outputFile
	end

end