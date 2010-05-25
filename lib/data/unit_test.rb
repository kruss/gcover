# a unit-test project with gcov instrumented object-files

require "util/logger"

class UnitTest

	def initialize(projectName, projectFolder, outputFolder)
		@projectName = projectName			# name of project
		@projectFolder = projectFolder		# project-folder path
		@outputFolder = outputFolder		# project output-folder path
		
		@objectFiles = Array.new			# object-file paths within project-folder
		@internGcovFiles = Array.new		# project's gcov-file paths within output-folder
		@externGcovFiles = Array.new		# other project's gcov-file paths within output-folder
	end
	
	attr_accessor :projectName
	attr_accessor :projectFolder
	attr_accessor :outputFolder
	
	attr_accessor :objectFiles
	attr_accessor :internGcovFiles
	attr_accessor :externGcovFiles
	
	def runGcov

		@objectFiles.each do |objectFile|		
			
			Logger.log "object-file: "+objectFile

			configName = Pathname.new(objectFile).relative_path_from(Pathname.new(@projectFolder)).cleanpath.to_s.split("/")[0]
			configFolder = @projectFolder+"/"+configName	
			relFolder = Pathname.new(File.dirname(objectFile)).relative_path_from(Pathname.new(configFolder)).cleanpath.to_s
			relFile = Pathname.new(objectFile).relative_path_from(Pathname.new(configFolder)).cleanpath.to_s			
			
			command = "gcov -l -p -o "+relFolder+" "+relFile+" > "+File.basename(objectFile)+".log"
			Logger.debug "... calling: "+command
			cd configFolder do
				sh command
			end
		end
	end
	
	def moveGcovFiles
		
		FileUtils.rm(FileList.new(@projectFolder+"/*/*###*.gcov")) # external references
		FileUtils.mv(FileList.new(@projectFolder+"/*/*.gcov"), outputFolder+"/gcov")
		FileUtils.mv(FileList.new(@projectFolder+"/*/*.o.log"), outputFolder)
	end
	
	# map intern and extern gcov-files
	def mapGcovFiles
		
		internFiles = FileList.new(outputFolder+"/gcov/*.gcov")	
		internFiles.exclude(/\^/) # no glob here !
		internFiles.each do |internFile|
			@internGcovFiles << internFile.to_s
		end
		
		externFiles = FileList.new(outputFolder+"/gcov/*#^#*.gcov")
		externFiles.each do |externFile|
			@externGcovFiles << externFile.to_s
		end
	end
	
	def createOutputFolder
	
		if !FileTest.directory?(outputFolder) then 
			Dir.mkdir(outputFolder) 
		end
		if !FileTest.directory?(outputFolder+"/gcov") then 
			Dir.mkdir(outputFolder+"/gcov") 
		end
	end
end