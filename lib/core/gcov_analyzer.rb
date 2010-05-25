# analyzes gcov-data of a workspace

require "core/gcov_runner"
require "data/unit_test"
require "data/tested_project"
require "util/gcov_util"
require "statistic/project_statistic"
require "util/logger"

class GcovAnalyzer

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
		
		@testedProjects = Array.new				# projects with code-coverage
		@untestedProjects = Array.new			# path of projects without code-coverage
	end
	
	attr_accessor :testedProjects
	attr_accessor :untestedProjects
	
	def analyzeUnitTests(gcovRunner)

		unitTests = gcovRunner.unitTests

		# extract tested-projects and map gcov-files 
		unitTests.each do |unitTest|
	
			applyInternGcovFiles(unitTest)
			applyExternGcovFiles(unitTest)
		end
		
		# collect untested projects
		fetchUntestedProjects
	end

	def createCodeCoverage

		Logger.info "creating coverage"
		
		@testedProjects.each do |testedProject|
			testedProject.createOutputFolder
			testedProject.fetchTestedSources
			testedProject.fetchUntestedSources
			testedProject.createCodeCoverage
			
			Logger.log testedProject.projectName+": "+ProjectStatistic.new(testedProject).getCoverRatio.to_s+" %"
		end
	end
		
private

	def applyInternGcovFiles(unitTest)
	
			testedProject = @testedProjects.find{ |item| item.projectName.eql?(unitTest.projectName) }
			
			if testedProject == nil then
				testedProject = TestedProject.new(unitTest.projectName, unitTest.projectFolder, unitTest.outputFolder)
				@testedProjects << testedProject
			end
			unitTest.internGcovFiles.each do |gcovFile|
				testedProject.gcovFiles << gcovFile
			end
			
			testedProject.internGcov = true
	end

	def applyExternGcovFiles(unitTest)
	
		unitTest.externGcovFiles.each do |gcovFile|
		
			projectName = GcovUtil.getProjectName(gcovFile)
			testedProject = @testedProjects.find{ |item| item.projectName.eql?(projectName) }
			
			if testedProject == nil then
				projectFolder = @workspaceFolder+"/"+projectName 
				outputFolder = @outputFolder+"/"+projectName 
				testedProject = TestedProject.new(projectName, projectFolder, outputFolder)
				@testedProjects << testedProject
			end
			testedProject.gcovFiles << gcovFile
		end
	end
	
	# collects remaining projects with source-files wich are not covered by any test
	def fetchUntestedProjects 

		projectFolders = FileList.new(@workspaceFolder+"/*/")
		projectFolders.exclude(@workspaceFolder+"/.*/") # no meta-data
		
		projectFolders.each do |projectFolder|
			sourceFiles = FileList.new(projectFolder+"/**/*.{h,hpp,c,cpp}")
			if sourceFiles.size() > 0 then
			
				projectPath = Pathname.new(projectFolder).cleanpath.to_s
				if @testedProjects.find{ |item| item.projectFolder.eql?(projectPath) } == nil then
					@untestedProjects << projectPath
				end
			end
		end
	end
end