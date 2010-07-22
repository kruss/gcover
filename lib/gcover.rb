# generates gcov code-coverage for cppunit-tests

require "optparse"
require "core/gcov_runner"
require "core/gcov_analyzer"
require "core/gcov_output"
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
				Logger.log "include: all sources"
			end
			
			begin
				runApplication()
			rescue => exception
				Logger.trace exception
				exit(-1)
			end
			
			if $AppOptions[:xml] then 
				deleteOutputFolder()
			end
			exit(0)
		else
		
			puts "try "+$AppName+" --help"
			exit(-1)
		end
	end
	
private
	
	def setOptions()
		
		$AppOptions.clear
		
		# parse explicit options
		optparse = OptionParser.new do |opts|
			opts.banner = $AppName+" <workspace> [options ...]"
			
			$AppOptions[:output] = nil
				opts.on("-o", "--output FOLDER", "Output code-coverage to FOLDER") do |folder|
				$AppOptions[:output] = cleanPath(folder)+"/"+$AppOutput
			end
			
			$AppOptions[:all] = false
				opts.on("-a", "--all", "All sources (include 'test' folders)") do
				$AppOptions[:all] = true
			end
			
			$AppOptions[:xml] = false
				opts.on("-x", "--xml", "Dump results as XML only") do
				$AppOptions[:xml] = true
			end
			
			$AppOptions[:browser] = false
				opts.on("-b", "--browser", "Open browser on output") do
				$AppOptions[:browser] = true
			end
	
			opts.on("-h", "--help", "Display this screen") do
				puts opts
				exit(0)
			end
		end
		optparse.parse!
		
		# set implicit options
		if 
			$AppOptions[:workspace] == nil && 
			ARGV.size == 1
		then
			$AppOptions[:workspace] = cleanPath(ARGV[0])
		end
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

		deleteOutputFolder
		FileUtils.mkdir_p($AppOptions[:output])
	end
	
	def deleteOutputFolder
	
		if FileTest.directory?($AppOptions[:output]) then 
			FileUtils.rm_rf($AppOptions[:output])
		end
	end

	def runApplication()
		
		# run gcov
		gcovRunner = GcovRunner.new($AppOptions[:workspace], $AppOptions[:output])
		gcovRunner.fetchUnitTests
		gcovRunner.runGcov
		
		# analyze gcov
		gcovAnalyzer = GcovAnalyzer.new($AppOptions[:workspace], $AppOptions[:output])
		gcovAnalyzer.analyzeUnitTests(gcovRunner)
		gcovAnalyzer.createCodeCoverage
	
		# create output
		gcovOutput = GcovOutput.new($AppOptions[:workspace], $AppOptions[:output])
		gcovOutput.createOutput(gcovAnalyzer)

	end
end