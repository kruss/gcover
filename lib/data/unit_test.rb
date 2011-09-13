# a unit-test project with gcov instrumented object-files

require "util/command"
require "fileutils"

class UnitTest

	def initialize(projectName, projectFolder, outputFolder, logger)
		@projectName = projectName			        # name of project
		@projectFolder = projectFolder		      # project-folder path
		@outputFolder = outputFolder		        # project output-folder path
    @logger = logger
		
		@objectFiles = Array.new			          # object-file paths within project-folder
		@internGcovFiles = Array.new		        # project's gcov-file paths within output-folder
		@externGcovFiles = Array.new		        # other project's gcov-file paths within output-folder
	end
	
	attr_accessor :projectName
	attr_accessor :projectFolder
	attr_accessor :outputFolder
	
	attr_accessor :objectFiles
	attr_accessor :internGcovFiles
	attr_accessor :externGcovFiles
	
	def runGcov
		@objectFiles.each do |objectFile|		
			@logger.info "run gcov: #{objectFile}"
			configName = Pathname.new(objectFile).relative_path_from(Pathname.new(@projectFolder)).cleanpath.to_s.split("/")[0]
			configFolder = @projectFolder+"/"+configName	
			relFolder = Pathname.new(File.dirname(objectFile)).relative_path_from(Pathname.new(configFolder)).cleanpath.to_s
			relFile = Pathname.new(objectFile).relative_path_from(Pathname.new(configFolder)).cleanpath.to_s			
			
      FileUtils.cd(configFolder) do
        begin
			      command = "gcov -l -p -o "+relFolder+" "+relFile+" > "+File.basename(objectFile)+".log"
            Command.call(command, @logger)
        rescue => error
          @logger.dump error
        end
      end
		end
	end
	
	def moveGcovFiles
    begin 
      moveFiles("#{@projectFolder}/*/*.o.log", @outputFolder)
      moveFiles("#{@projectFolder}/*/*###*.gcov", "#{@outputFolder}/gcov/extern") # first move external gcov-files
      moveFiles("#{@projectFolder}/*/*.gcov", "#{@outputFolder}/gcov")            # now move the real ones
    rescue => error
      @logger.dump error
    end
	end
	
	# map intern and extern gcov-files
	def mapGcovFiles
    gcov_pattern = "#{@outputFolder}/gcov/*.gcov"
		@logger.debug "search gcov-files: #{gcov_pattern}"
    
    # intern gcov-files
		internFiles = FileList.new(gcov_pattern)	
		internFiles.exclude(/\^/) # no glob here !
		internFiles.each do |internFile|
			@internGcovFiles << internFile.to_s
		end
		@logger.debug("=> intern gcov-files: #{@internGcovFiles.size}")
    
    # extern gcov-files
		externFiles = FileList.new("#{@outputFolder}/gcov/*#^#*.gcov")
		externFiles.each do |externFile|
			@externGcovFiles << externFile.to_s
	  end
    @logger.debug("=> extern gcov-files: #{@externGcovFiles.size}")
	end
	
	def createOutputFolder
		if !FileTest.directory?(@outputFolder) then 
			FileUtils.mkdir_p(@outputFolder) 
	  end
    if !FileTest.directory?("#{@outputFolder}/gcov") then 
      FileUtils.mkdir_p("#{@outputFolder}/gcov") 
    end
	end
  
private

  def moveFiles(pattern, destination)
    list = FileList.new(pattern)
    @logger.debug "move #{list.size} files: #{pattern} -> #{destination}"
    if list.size > 0 then
      if !FileTest.directory?(destination) then 
        FileUtils.mkdir_p(destination) 
      end
      FileUtils.mv(list, destination)
    end
  end

end