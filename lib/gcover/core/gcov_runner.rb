# runs gcov on unit-tests within a workspace

require "rake"
require "pathname"
require "gcover/data/unit_test"

class GcovRunner

	def initialize(workspaceFolder, outputFolder, logger)
		@workspaceFolder = workspaceFolder		  # workspace-folder path
		@outputFolder = outputFolder			      # output-folder path
    @logger = logger 
		
		@unitTests = Array.new					        # unit-tests within workspace
	end
	
	attr_accessor :unitTests

	# get gcov data-files and extract unit-tests
	def fetchUnitTests
    gcda_pattern = "#{@workspaceFolder}/**/*.gcda" 
    @logger.info "search gcda-files: #{gcda_pattern}" 
		gcdaFiles = FileList.new(gcda_pattern)
		@logger.info "=> gcda-files: #{gcdaFiles.size}"
    
		gcdaFiles.each do |gcdaFile|
			gcdaFilePath = gcdaFile.to_s
			@logger.info "gcda-file: #{gcdaFilePath}"
			projectName = Pathname.new(gcdaFilePath).relative_path_from(Pathname.new(@workspaceFolder)).to_s.split("/")[0]
			projectFolder = @workspaceFolder+"/"+projectName
			
			unitTest = @unitTests.find{ |item| item.projectName.eql?(projectName) }
			if unitTest == nil then
        @logger.debug "=> adding unit-test: #{projectFolder}"
				outputFolder = @outputFolder+"/"+projectName
				unitTest = UnitTest.new(projectName, projectFolder, outputFolder, @logger)
				@unitTests << unitTest
			end
			configName = Pathname.new(gcdaFilePath).relative_path_from(Pathname.new(projectFolder)).to_s.split("/")[0]
			fetchObjectFiles(unitTest, configName)
		end
		@logger.info "=> unit-tests: #{@unitTests.size}"
	end
	
	# run gcov on collected unit-tests
	def runGcov
		@unitTests.each do |unitTest|
			@logger.emph unitTest.projectName
			unitTest.createOutputFolder
			unitTest.runGcov
			unitTest.moveGcovFiles
			unitTest.mapGcovFiles
		end
	end
	
private

	# fetch unit-test object-files
	def fetchObjectFiles(unitTest, configName)
    configFolder = unitTest.projectFolder+"/"+configName 
	  @logger.debug "search object-files: #{configFolder}" 
		objectFiles = FileList.new("#{configFolder}/**/*.o")
    @logger.debug "=> object-files: #{objectFiles.size}"
    
		objectFiles.each do |objectFile|
			if !unitTest.objectFiles.include?(objectFile) then
				unitTest.objectFiles << objectFile
        @logger.debug "adding object-file: #{objectFile}"
			end
		end
	end
end