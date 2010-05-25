# a project with associated gcov-files

require "data/tested_source"
require "util/gcov_util"

class TestedProject

	def initialize(projectName, projectFolder, outputFolder)
		@projectName = projectName			# name of project
		@projectFolder = projectFolder		# project-folder path
		@outputFolder = outputFolder		# output-folder path
		
		@internGcov = false					# answers if tested directly
		@gcovFiles = Array.new				# associated gcov-file paths
		@testedSources = Array.new			# sources with code-coverage
		@excludedSources = Array.new		# excluded sources with code-coverage
		@untestedSources = Array.new		# path of sources without code-coverage
	end
	
	attr_accessor :projectName
	attr_accessor :projectFolder
	attr_accessor :outputFolder
	
	attr_accessor :internGcov
	attr_accessor :gcovFiles
	attr_accessor :testedSources
	attr_accessor :excludedSources
	attr_accessor :untestedSources
	
	def fetchTestedSources
		
		# extract tested-sources and map gcov files 
		@gcovFiles.each do |gcovFile|
		
			sourcePath = GcovUtil.getSourcePath(gcovFile)
			sourceFile = Pathname.new(@projectFolder+"/"+sourcePath).cleanpath.to_s
			if !FileTest.file?(sourceFile) then 
				raise "not a file: "+sourceFile
			end
			
			if !isExcludedSource(sourceFile) then
			
				testedSource = @testedSources.find{ |item| item.sourceFile.eql?(sourceFile) }
				if testedSource == nil then
					testedSource = TestedSource.new(@projectName, @projectFolder, sourceFile, @outputFolder+"/html")
					@testedSources << testedSource
				end
				testedSource.gcovFiles << gcovFile
				
			else
				@excludedSources << sourceFile
			end
		end
	end
	
	def fetchUntestedSources
	
		sourceFiles = FileList.new(@projectFolder+"/**/*.{h,hpp,c,cpp}")
		sourceFiles.each do |sourceFile|
			filePath = sourceFile.to_s
			if 
				@testedSources.find{ |item| item.sourceFile.eql?(filePath) } == nil &&
				!@excludedSources.include?(filePath)
			then
				@untestedSources << filePath
			end
		end
	end
	
	def createCodeCoverage
	
		@testedSources.each do |testedSource|
			testedSource.createCodeCoverage
		end
	end
	
	def createOutputFolder
	
		if !FileTest.directory?(outputFolder) then 
			Dir.mkdir(outputFolder) 
		end
		if !FileTest.directory?(outputFolder+"/html") then 
			Dir.mkdir(outputFolder+"/html") 
		end
	end
	
private

	def isExcludedSource(sourceFile)
	
		if $AppOptions[:all] then
			return false
		else
			relFolder = Pathname.new(File.dirname(sourceFile)).relative_path_from(Pathname.new(@projectFolder)).cleanpath.to_s
			return relFolder.match(/^test/)
		end
	end
end