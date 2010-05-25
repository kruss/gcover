# runs gcov on unit-tests within a workspace

require "rake"
require "pathname"
require "data/unit_test"
require "util/logger"

class GcovRunner

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
		
		@unitTests = Array.new					# unit-tests within workspace
	end
	
	attr_accessor :unitTests

	# get gcov data-files and extract unit-tests
	def fetchUnitTests
		
		gcdaFiles = FileList.new(@workspaceFolder+"/**/*.gcda")
		
		Logger.log "gcov-files: "+gcdaFiles.size().to_s
		gcdaFiles.each do |gcdaFile|
			gcdaFilePath = gcdaFile.to_s
			Logger.debug gcdaFilePath
			
			projectName = Pathname.new(gcdaFilePath).relative_path_from(Pathname.new(@workspaceFolder)).to_s.split("/")[0]
			projectFolder = @workspaceFolder+"/"+projectName
			
			unitTest = @unitTests.find{ |item| item.projectName.eql?(projectName) }
			if unitTest == nil then
				outputFolder = @outputFolder+"/"+projectName
				unitTest = UnitTest.new(projectName, projectFolder, outputFolder)
				@unitTests << unitTest
			end
			configName = Pathname.new(gcdaFilePath).relative_path_from(Pathname.new(projectFolder)).to_s.split("/")[0]
			fetchObjectFiles(unitTest, configName)
		end
		Logger.log "unit-tests: "+@unitTests.size().to_s
	end
	
	# run gcov on collected unit-tests
	def runGcov
		
		@unitTests.each do |unitTest|
			Logger.info "unit-test - "+unitTest.projectName
			
			unitTest.createOutputFolder
			unitTest.runGcov
			unitTest.moveGcovFiles
			unitTest.mapGcovFiles
		end
	end
	
private

	# fetch unit-test object-files
	def fetchObjectFiles(unitTest, configName)
	
		objectFiles = FileList.new(unitTest.projectFolder+"/"+configName+"/**/*.o")
		objectFiles.each do |objectFile|
			if !unitTest.objectFiles.include?(objectFile) then
				unitTest.objectFiles << objectFile
			end
		end
	end
end