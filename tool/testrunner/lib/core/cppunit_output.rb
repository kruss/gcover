# creates output for gcov-data

require "html/workspace_html"
require "xml/workspace_xml"

class CppUnitOutput

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
	end
	
	def createOutput(cppunitRunner)
	
		Logger.info "create output"
		outputFile = nil
		
		if !$AppOptions[:xml] then
			createXmlOutput(cppunitRunner, @outputFolder)
			outputFile = createHtmlOutput(cppunitRunner, @outputFolder)
		else
			outputFile = createXmlOutput(cppunitRunner, ".")
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
	
	def createHtmlOutput(cppunitRunner, outputFolder)
	
		htmlOutput = WorkspaceHtml.new(@workspaceFolder, outputFolder)
		htmlOutput.createHtmlOutput(cppunitRunner)
		Logger.log "html-output: "+htmlOutput.outputFile
		return htmlOutput.outputFile
	end
	
	def createXmlOutput(cppunitRunner, outputFolder)
	
		xmlOutput = WorkspaceXml.new(@workspaceFolder, outputFolder)
		xmlOutput.createXmlOutput(cppunitRunner)
		Logger.log "xml-output: "+xmlOutput.outputFile
		return xmlOutput.outputFile
	end

end