# creates output for gcov-data

require "gcover/html/workspace_html"
require "gcover/xml/workspace_xml"

class GcovOutput

	def initialize(workspaceFolder, outputFolder, logger)
		@workspaceFolder = workspaceFolder		    # workspace-folder path
		@outputFolder = outputFolder			        # output-folder path
    @logger = logger 
	end
	
	def createOutput(gcovAnalyzer)
		@logger.emph "output"
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
      require "feedback/feedback"
    rescue LoadError => error
      @logger.warn "could not create xml: #{error.message}"
      return nil
    end
    
		xmlOutput = WorkspaceXml.new(@workspaceFolder, outputFolder)
		xmlOutput.createXmlOutput(gcovAnalyzer.testedProjects)
		@logger.info "xml-output: "+xmlOutput.outputFile
		return xmlOutput.outputFile
	end

end