# analyzes gcov-data of a workspace

require "core/gcov_runner"
require "data/unit_test"
require "data/tested_project"
require "util/gcov_util"
require "statistic/project_statistic"

class GcovAnalyzer

	def initialize(workspaceFolder, outputFolder, logger)
		@workspaceFolder = workspaceFolder		  # workspace-folder path
		@outputFolder = outputFolder			      # output-folder path
    @logger = logger 
		
		@testedProjects = Array.new				      # projects with code-coverage
		@untestedProjects = Array.new			      # path of projects without code-coverage
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
		@logger.emph "coverage"
		@testedProjects.each do |testedProject|
      @logger.info "project: #{testedProject.projectName}"  
			testedProject.createOutputFolder
			testedProject.fetchTestedSources
			testedProject.fetchUntestedSources
			testedProject.createCodeCoverage
			
      ratio = ProjectStatistic.new(testedProject.testedSources).getCoverRatio
			@logger.info "=> coverage: #{ratio} %"
		end
    @logger.info "workspace:" 
    ratio = WorkspaceStatistic.new(self.testedProjects).getCoverRatio
		@logger.info "=> coverage: #{ratio} %"
	end
		
private

	def applyInternGcovFiles(unitTest)
      @logger.debug "apply intern-gcov files: #{unitTest.projectName} (#{unitTest.internGcovFiles.size})" 
			testedProject = @testedProjects.find{ |item| item.projectName.eql?(unitTest.projectName) }
      
			if testedProject == nil then
				testedProject = TestedProject.new(unitTest.projectName, unitTest.projectFolder, unitTest.outputFolder, @logger)
				@testedProjects << testedProject
			end
			unitTest.internGcovFiles.each do |gcovFile|
        @logger.debug "=> #{testedProject.projectName}: #{gcovFile}"    
				testedProject.gcovFiles << gcovFile
			end
			testedProject.internGcov = true
	end

	def applyExternGcovFiles(unitTest)
	  @logger.debug "apply extern-gcov files: #{unitTest.projectName} (#{unitTest.externGcovFiles.size})"
		unitTest.externGcovFiles.each do |gcovFile|
			projectName = GcovUtil.getProjectName(gcovFile)
			testedProject = @testedProjects.find{ |item| item.projectName.eql?(projectName) }
			
			if testedProject == nil then
				projectFolder = @workspaceFolder+"/"+projectName 
				outputFolder = @outputFolder+"/"+projectName 
				testedProject = TestedProject.new(projectName, projectFolder, outputFolder)
				@testedProjects << testedProject
			end
			@logger.debug "=> #{testedProject.projectName}: #{gcovFile}" 
      testedProject.gcovFiles << gcovFile
		end
	end
	
	# collects remaining projects with source-files wich are not covered by any test
	def fetchUntestedProjects 
    @logger.debug "search untested projects: #{@workspaceFolder}"
		projectFolders = FileList.new(@workspaceFolder+"/*/")
		projectFolders.exclude(@workspaceFolder+"/.*/") # no meta-data		
		projectFolders.each do |projectFolder|
			sourceFiles = FileList.new(projectFolder+"/**/*.{h,hpp,c,cpp}")
			if sourceFiles.size() > 0 then
			
				projectPath = Pathname.new(projectFolder).cleanpath.to_s
				if @testedProjects.find{ |item| item.projectFolder.eql?(projectPath) } == nil then
          @logger.debug "=> untested project: #{File.basename(projectPath)}"    
					@untestedProjects << projectPath
				end
			end
		end
	end
end