# creates output for gcov-data

require "html/workspace_html"
require "xml/workspace_xml"

class GcovOutput

	def initialize(workspaceFolder, outputFolder, logger)
		@workspaceFolder = workspaceFolder		    # workspace-folder path
		@outputFolder = outputFolder			        # output-folder path
    @logger = logger 
	end
	
	def createOutput(gcovAnalyzer)
		@logger.emph "create output"
		outputFile = nil
		
		if !$AppOptions[:xml] then
			createXmlOutput(gcovAnalyzer, @outputFolder)
			outputFile = createHtmlOutput(gcovAnalyzer, @outputFolder)
		else
			outputFile = createXmlOutput(gcovAnalyzer, ".")
		end
		
		if outputFile != nil && $AppOptions[:browser] then
			@logger.info "open browser"
			begin 
				FileUtil.openBrowser(outputFile)
      rescue => error
        @logger.dump error
			end
		end
	end
	
	def createHtmlOutput(gcovAnalyzer, outputFolder)
		htmlOutput = WorkspaceHtml.new(@workspaceFolder, outputFolder)
		htmlOutput.createHtmlOutput(gcovAnalyzer.testedProjects, gcovAnalyzer.untestedProjects)
		@logger.info "html-output: "+htmlOutput.outputFile
		return htmlOutput.outputFile
	end
	
	def createXmlOutput(gcovAnalyzer, outputFolder)
    begin
      require "feedback"
    rescue error
      @logger.warn e.message
      return nil
    end
    
		xmlOutput = WorkspaceXml.new(@workspaceFolder, outputFolder)
		xmlOutput.createXmlOutput(gcovAnalyzer.testedProjects)
		@logger.info "xml-output: "+xmlOutput.outputFile
		return xmlOutput.outputFile
	end

end