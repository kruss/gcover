# generates gcov code-coverage for cppunit-tests

require "optparse"
require "core/gcov_runner"
require "core/gcov_analyzer"
require "html/workspace_html"
require "util/logger"

$AppName = "gcover"
$AppVersion = "0.1.0"
$AppOutput = ".gcover"
$AppOptions = {}

class GCover

	def initialize()

		setOptions()
	end
	
	# generate code-coverage
	def run()

		if validOptions() then

			createOutputFolder()
			Logger.setLogfile($AppOptions[:output]+"/"+$AppName+".log")
	
			Logger.info $AppName+" ("+$AppVersion+")"
			Logger.log "workspace-folder: "+$AppOptions[:workspace]
			Logger.log "output-folder: "+$AppOptions[:output]
			if $AppOptions[:all] then 
				Logger.log "including: all sources"
			end
			
			runApplication()
			exit(0)
		else
		
			puts "try "+$AppName+" --help"
			exit(-1)
		end
	end
	
private
	
	def setOptions()
		
		optparse = OptionParser.new do |opts|
			opts.banner = $AppName+" options"
			
			$AppOptions[:workspace] = nil
				opts.on("-w", "--workspace FOLDER", "Run code-coverage on FOLDER") do |folder|
				$AppOptions[:workspace] = cleanPath(folder)
			end
			
			$AppOptions[:output] = nil
				opts.on("-o", "--output FOLDER", "Output code-coverage to FOLDER") do |folder|
				$AppOptions[:output] = cleanPath(folder)+"/"+$AppOutput
			end
			
			$AppOptions[:all] = false
				opts.on("-a", "--all", "All sources (include 'test' folders)") do
				$AppOptions[:all] = true
			end
	
			opts.on("-h", "--help", "Display this screen") do
				puts opts
				exit(0)
			end
		end
		
		optparse.parse!
		if 
			$AppOptions[:workspace] != nil && 
			$AppOptions[:output] == nil 
		then
			$AppOptions[:output] = $AppOptions[:workspace]+"/"+$AppOutput
		end
		
	end
	
	def validOptions()
	
		if 
			$AppOptions[:workspace] != nil && 
			$AppOptions[:output] != nil && 
			FileTest.directory?($AppOptions[:workspace]) 
		then
			return true
		else
			return false
		end
	end
	
	def cleanPath(path)
	
		if path == "." then
			return Dir.getwd
		elsif path == ".." then
			return Pathname.new(Dir.getwd+"/..").cleanpath.to_s
		else
			return Pathname.new(path.gsub(/\\/, "/")).cleanpath.to_s
		end
	end
	
	def createOutputFolder
	
		if FileTest.directory?($AppOptions[:output]) then 
			FileUtils.rm_rf($AppOptions[:output])
		end
		FileUtils.mkdir_p($AppOptions[:output])
		
	end

	def runApplication()
		
		gcovRunner = GcovRunner.new($AppOptions[:workspace], $AppOptions[:output])
		gcovRunner.fetchUnitTests
		gcovRunner.runGcov
		
		gcovAnalyzer = GcovAnalyzer.new($AppOptions[:workspace], $AppOptions[:output])
		gcovAnalyzer.analyzeUnitTests(gcovRunner)
		gcovAnalyzer.createCodeCoverage
	
		htmlOutput = WorkspaceHtml.new($AppOptions[:workspace], $AppOptions[:output])
		htmlOutput.createHtmlOutput(gcovAnalyzer)

	end
end