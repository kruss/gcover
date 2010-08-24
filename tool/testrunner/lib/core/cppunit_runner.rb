# runs gcov on unit-tests within a workspace

require "rake"
require "pathname"
require "data/unit_test"
require "util/logger"

class CppUnitRunner

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		      # workspace-folder path
		@outputFolder = outputFolder			          # output-folder path
    
		@unitTests = Array.new					# unit-tests within workspace
    @status = Status::UNDEFINED
	end
	
	attr_accessor :unitTests
  attr_accessor :status

	# get gcov data-files and extract unit-tests
	def fetchUnitTests
		
    testExecutables = FileList.new(@workspaceFolder+"/*/"+$AppOptions[:config]+"/*."+$AppOptions[:extention])
    testExecutables.each do |testExecutable|
      testExecutablePath = testExecutable.to_s
      Logger.debug testExecutablePath
      
      projectName = Pathname.new(testExecutablePath).relative_path_from(Pathname.new(@workspaceFolder)).to_s.split("/")[0]
      projectFolder = @workspaceFolder+"/"+projectName
      
      unitTest = @unitTests.find{ |item| item.projectName.eql?(projectName) }
      if unitTest == nil then
        outputFolder = @outputFolder+"/"+projectName
        unitTest = UnitTest.new(projectName, projectFolder, outputFolder, testExecutable)
        @unitTests << unitTest
      end
    end
    Logger.log "unit-tests: "+@unitTests.size().to_s
	end
	
	# run gcov on collected unit-tests
	def runUnitTests
		
		@unitTests.each do |unitTest|
			Logger.info "unit-test - "+unitTest.projectName
			
			unitTest.createOutputFolder
			unitTest.runUnitTest
      unitTest.getTestResults
      
		end
	end

  def status
    
    if @unitTests.size() > 0 then
      @unitTests.each do |unitTest|
        if unitTest.status != Status::SUCCEED then
          return Status::ERROR
        end
      end
      return Status::SUCCEED
    else
      return Status::UNDEFINED
    end
  end

end