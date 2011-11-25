# generates gcov code-coverage for cppunit-tests

require "optparse"
require "gcover/core/gcov_runner"
require "gcover/core/gcov_analyzer"
require "gcover/core/gcov_output"
require "gcover/util/gem_logger"

$AppName = "gcover"
$AppNameUI = "Gcover"
$AppVersion = "0.2.0"
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
      logger = GemLogger.new("#{$AppOptions[:output]}/#{$AppName}.log", $AppOptions[:verbose])
			begin
        logger.emph "#{$AppName} (#{$AppVersion})"   
				runApplication(logger)
			rescue => error
				logger.dump error
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

			$AppOptions[:eclipse] = false
				opts.on("-e", "--eclipse", "Run in build-folder (def: project-folder)") do
				$AppOptions[:eclipse] = true
			end
    
			$AppOptions[:browser] = false
				opts.on("-b", "--browser", "Open browser on output") do
				$AppOptions[:browser] = true
			end

			$AppOptions[:verbose] = false
				opts.on("-v", "--verbose", "Print additional logging") do
				$AppOptions[:verbose] = true
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

	def runApplication(logger)
		
		# run gcov
		gcovRunner = GcovRunner.new($AppOptions[:workspace], $AppOptions[:output], logger)
		gcovRunner.fetchUnitTests
		gcovRunner.runGcov
		
		# analyze gcov
		gcovAnalyzer = GcovAnalyzer.new($AppOptions[:workspace], $AppOptions[:output], logger)
		gcovAnalyzer.analyzeUnitTests(gcovRunner)
		gcovAnalyzer.createCodeCoverage
	
		# create output
		gcovOutput = GcovOutput.new($AppOptions[:workspace], $AppOptions[:output], logger)
		gcovOutput.createOutput(gcovAnalyzer)

	end
end