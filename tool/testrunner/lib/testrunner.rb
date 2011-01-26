# run cppunit-tests within a workspace

require "optparse"
require "core/cppunit_runner"
require "core/cppunit_output"
require "util/logger"

$AppName = "testrunner"
$AppNameUI = "CppUnit"
$AppVersion = "0.1.0"
$AppOutput = ".testrunner"
$AppOptions = {}

class TestRunner

	def initialize()

		setOptions()
	end
	
	# run unit-tests
	def run()

		if validOptions() then

			createOutputFolder()
			Logger.setLogfile($AppOptions[:output]+"/"+$AppName+".log")
	
			Logger.info $AppName+" ("+$AppVersion+")"
			Logger.log "workspace-folder: "+$AppOptions[:workspace]
			Logger.log "output-folder: "+$AppOptions[:output]
			
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
				opts.on("-o", "--output FOLDER", "Output test-results to FOLDER") do |folder|
				$AppOptions[:output] = cleanPath(folder)+"/"+$AppOutput
			end
			
      $AppOptions[:config] = "UnitTest"
        opts.on("-c", "--config NAME", "Set unit-test configuration NAME (def: UnitTest)") do |name|
        $AppOptions[:config] = name
      end
    
      $AppOptions[:extention] = "exe"
        opts.on("-e", "--extention NAME", "Set unit-test extention NAME (def: exe)") do |name|
        $AppOptions[:extention] = name
      end
    
			$AppOptions[:xml] = false
				opts.on("-x", "--xml", "Dump results as XML only") do
				$AppOptions[:xml] = true
			end
			
			$AppOptions[:browser] = false
				opts.on("-b", "--browser", "Open browser on output") do
				$AppOptions[:browser] = true
			end

      $AppOptions[:fail] = false
        opts.on("-f", "--fail", "Fail on errors") do
        $AppOptions[:fail] = true
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
		
		# run unit-tests
		cppunitRunner = CppUnitRunner.new($AppOptions[:workspace], $AppOptions[:output])
    cppunitRunner.fetchUnitTests
		cppunitRunner.runUnitTests
	
		# create output
		cppunitOutput = CppUnitOutput.new($AppOptions[:workspace], $AppOptions[:output])
		cppunitOutput.createOutput(cppunitRunner)

    # final status
    Logger.info("Status: "+Status::getString(cppunitRunner.status))
    if $AppOptions[:fail] && cppunitRunner.status == Status::ERROR then
      exit(-1)
    end
  
	end
end