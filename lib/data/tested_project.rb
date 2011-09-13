# a project with associated gcov-files

require "data/tested_source"
require "util/gcov_util"

class TestedProject

	def initialize(projectName, projectFolder, outputFolder, logger)
		@projectName = projectName			    # name of project
		@projectFolder = projectFolder		  # project-folder path
		@outputFolder = outputFolder		    # output-folder path
    @logger = logger
		
		@internGcov = false					        # answers if tested directly
		@gcovFiles = Array.new				      # associated gcov-file paths
		@testedSources = Array.new			    # sources with code-coverage
		@excludedSources = Array.new		    # excluded sources with code-coverage
		@untestedSources = Array.new		    # path of sources without code-coverage
	end
	
	attr_accessor :projectName
	attr_accessor :projectFolder
	attr_accessor :outputFolder
	
	attr_accessor :internGcov
	attr_accessor :gcovFiles
	attr_accessor :testedSources
	attr_accessor :excludedSources
	attr_accessor :untestedSources
	
	# extract tested-sources and map gcov files 
	def fetchTestedSources
		@logger.debug "search source-files"
		@gcovFiles.each do |gcovFile|
			sourcePath = GcovUtil.getSourcePath(gcovFile)
			sourceFile = Pathname.new(@projectFolder+"/"+sourcePath).cleanpath.to_s
			if FileTest.file?(sourceFile) then 
  			if !isExcludedSource(sourceFile) then
  				testedSource = @testedSources.find{ |item| item.sourceFile.eql?(sourceFile) }
  				if testedSource == nil then
            @logger.debug "=> adding: #{sourceFile}"    
  					testedSource = TestedSource.new(@projectName, @projectFolder, sourceFile, "#{@outputFolder}/html")
  					@testedSources << testedSource
  				end
  				testedSource.gcovFiles << gcovFile
  			else
          @logger.debug "=> excluded: #{sourceFile}"
          @excludedSources << sourceFile
  			end
      else   
				@logger.warn "not a file: #{sourceFile}"
			end
	  end
    @logger.debug "=> source-files: #{@testedSources.size}"
    @logger.debug "=> excluded: #{@excludedSources.size}"
	end
	
	def fetchUntestedSources
    @logger.debug "search untested sources"
		sourceFiles = FileList.new("#{@projectFolder}/**/*.{h,hpp,c,cpp}")
		sourceFiles.each do |sourceFile|
			filePath = sourceFile.to_s
			if 
				@testedSources.find{ |item| item.sourceFile.eql?(filePath) } == nil &&
				!@excludedSources.include?(filePath)
			then
        @logger.debug "=> adding: #{filePath}"
				@untestedSources << filePath
			end
		end
    @logger.debug "=> untested: #{@excludedSources.size}"
  end
	
	def createCodeCoverage
		@testedSources.each do |testedSource|
			testedSource.createCodeCoverage
		end
	end
	
	def createOutputFolder
		if !FileTest.directory?(@outputFolder) then 
			FileUtils.mkdir_p(@outputFolder) 
		end
		if !FileTest.directory?("#{@outputFolder}/html") then 
			FileUtils.mkdir_p("#{@outputFolder}/html") 
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