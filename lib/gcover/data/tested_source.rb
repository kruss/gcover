# a source-file with associated gcov-files

require "gcover/data/tested_line"

class TestedSource

	def initialize(projectName, projectFolder, sourceFile, outputFolder)
		@projectName = projectName			# name of project
		@projectFolder = projectFolder		# project-folder path
		@sourceFile = sourceFile			# source-file path
		@outputFolder = outputFolder		# output-folder path
		
		@gcovFiles = Array.new				# associated gcov-file paths
		@testedLines = Array.new			# tested lines of source
	end

	attr_accessor :projectName
	attr_accessor :projectFolder
	attr_accessor :sourceFile
	attr_accessor :outputFolder
	
	attr_accessor :gcovFiles
	attr_accessor :testedLines
	
	# creates, eg: include/util/endian.h
	def sourceFileName
		return Pathname.new(@sourceFile).relative_path_from(Pathname.new(@projectFolder)).cleanpath.to_s
	end
	
	# creates, eg: include#util#endian.h.htm
	def outputFileName
		return sourceFileName.gsub(/\//, "#").gsub(/\.\./, "^") + ".htm"
	end
	
	def createCodeCoverage
	
		@gcovFiles.each do |gcovFile|
			evaluateGcovFile(gcovFile)
		end
	end
	
	def evaluateGcovFile(gcovFile)
	
		fileLines = IO.readlines(gcovFile)
		lines = fileLines.grep(/^(\s)/)
		lines.each do |line| 
			idx = getLineIndex(line)
			if idx > 0 then		
				cover = getLineCover(line)
				content = getLineContent(line)
				if !content.eql?("/*EOF*/") then
					testedLine = @testedLines.find{ |item| item.idx == idx }
					if testedLine == nil then
						testedLine = TestedLine.new(idx, content)
						@testedLines << testedLine
					end
					applyCover(testedLine, cover)
				end
			end
		end
	end
	
	def applyCover(testedLine, cover)
	
		if cover.eql?("-") then
			testedLine.ignored = testedLine.ignored + 1
		elsif cover.eql?("#####") then
			testedLine.missed = testedLine.missed + 1
		elsif cover.match(/^(\d)+$/) then
			testedLine.executed = testedLine.executed + 1
		else
			raise "undefined token: " + cover
		end
	end
	
	# format, eg: "        -:   13:namespace xcp"
	def getLineCover(line)
		a = line.index(":")
		return line[0..a-1].strip
	end
	
	# format, eg: "        -:   13:namespace xcp"
	def getLineIndex(line)
		a = line.index(":")
		b = line.index(":", a+1)
		return line[a+1..b-1].strip.to_i
	end
	
	# format, eg: "        -:   13:namespace xcp"
	def getLineContent(line)
		a = line.index(":")
		b = line.index(":", a+1)
		return line[b+1..line.length()].chomp
	end
end