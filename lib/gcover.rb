# generates gcov code-coverage for cppunit-tests

require "core/gcov_runner"
require "core/gcov_analyzer"
require "html/workspace_html"
require "util/logger"

$applicationName = "gcover"
$applicationVersion = "0.1.0"
$outputFolderName = ".gcover"
$excludeTestSources = true

class GCover

	def initialize()
		@workspaceFolder = nil			# workspace-folder path
		@outputFolder = nil				# output-folder path
	end
	
	attr_accessor :workspaceFolder
	attr_accessor :outputFolder
	
	# setup class with commandline-args
	def setParameter(args)
	
		if args.size == 1 then
		
			@workspaceFolder = cleanPath(args[0])
			@outputFolder = cleanPath(args[0])+"/"+$outputFolderName
			
		elsif args.size == 2 then
		
			@workspaceFolder = cleanPath(args[0])
			@outputFolder = cleanPath(args[1])+"/"+$outputFolderName
		end
	end
	
	# generate code-coverage
	def run()

		if validParameter() then

			createOutputFolder()
			Logger.setLogfile(@outputFolder+"/"+$applicationName+".log")
	
			Logger.info $applicationName+" ("+$applicationVersion+")"
			Logger.log "workspace-folder: "+@workspaceFolder
			Logger.log "output-folder: "+@outputFolder
			
			runApplication()
			exit(0)
		else
		
			Logger.log "usage: gcover <workspace-folder> [<output-folder>]"
			exit(-1)
		end
	end
	
private
	
	def cleanPath(path)
	
		if path == "." then
			return Dir.getwd
		elsif path == ".." then
			return Pathname.new(Dir.getwd+"/..").cleanpath.to_s
		else
			return Pathname.new(path.gsub(/\\/, "/")).cleanpath.to_s
		end
	end
	
	def validParameter()
	
		if 
			@workspaceFolder != nil && @outputFolder != nil && 
			FileTest.directory?(@workspaceFolder) 
		then
			return true
		else
			return false
		end
	end
	
	def createOutputFolder
	
		if FileTest.directory?(@outputFolder) then 
			FileUtils.rm_rf(@outputFolder) 		
		end
		FileUtils.mkdir_p(@outputFolder)
		
	end

	def runApplication()
		
		gcovRunner = GcovRunner.new(@workspaceFolder, @outputFolder)
		gcovRunner.fetchUnitTests
		gcovRunner.runGcov
		
		gcovAnalyzer = GcovAnalyzer.new(@workspaceFolder, @outputFolder)
		gcovAnalyzer.analyzeUnitTests(gcovRunner)
		gcovAnalyzer.createCodeCoverage
	
		htmlOutput = WorkspaceHtml.new(@workspaceFolder, @outputFolder)
		htmlOutput.createHtmlOutput(gcovAnalyzer)

	end
end