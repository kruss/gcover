# a unit-test project with gcov instrumented object-files

require "util/logger"
require "util/status"

class UnitTest

	def initialize(projectName, projectFolder, outputFolder, testExecutable)
		@projectName = projectName			    # name of project
		@projectFolder = projectFolder		  # project-folder path
		@outputFolder = outputFolder		    # project output-folder path
    @testExecutable = testExecutable    # test executable file path
    
    @status = Status::UNDEFINED
	end
	
	attr_accessor :projectName
	attr_accessor :projectFolder
	attr_accessor :outputFolder
  attr_accessor :testExecutable
  attr_accessor :status
	
	def runUnitTest

		configName = Pathname.new(@testExecutable).relative_path_from(Pathname.new(@projectFolder)).cleanpath.to_s.split("/")[0]
		configFolder = @projectFolder+"/"+configName	

		command = File.basename(@testExecutable)+" > cppunit.log"
		Logger.debug "... calling: "+command
		cd configFolder do
			sh command
		end
    FileUtils.mv(FileList.new(@projectFolder+"/"+configName+"/cppunit.log"), outputFolder)
  end
	
  def getTestResults
    
    file = File.new(outputFolder+"/cppunit.log", "r")
    if file
      failPattern = false
      while (line = file.gets)
          if line.include?("!!!FAILURES!!!") then
            failPattern = true
            break
          end
      end
      file.close
      
      if failPattern then
        Logger.log "Test FAILED !"
        @status = Status::ERROR
      else
        Logger.log "Test OK !"
        @status = Status::SUCCEED
      end
    else
        Logger.log " NO Test-Results !"   
    end
    
  end
  
	def createOutputFolder
	
		if !FileTest.directory?(outputFolder) then 
			Dir.mkdir(outputFolder) 
		end
	end
end