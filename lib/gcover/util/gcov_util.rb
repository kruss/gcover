
class GcovUtil

	# check, eg: src#xcp#XcpProcessor.o##..#^#Logger#include#logger#Logger.h.gcov
	# for containing "#^#"
	def GcovUtil.isExternGcovFile(gcovFile)
	
		return File.basename(gcovFile).index("#^#") != nil
	end

	# extract extern gcof-file, eg: src#xcp#XcpProcessor.o##..#^#Logger#include#logger#Logger.h.gcov
	# to "Logger"
	def GcovUtil.getProjectName(gcovFile)
	
		if isExternGcovFile(gcovFile) then
			return File.basename(gcovFile).split("##")[1].split("#")[2]
		else
			raise "no extern-gcov: "+gcovFile
		end
	end

	# extract intern gcof-file, eg: src#xcp#XcpProcessor.o##..#include#xcp#XcpPacket.h.gcov
	# to include/xcp/XcpPacket.h
	# extract extern gcof-file, eg: src#xcp#XcpProcessor.o##..#^#Logger#include#logger#Logger.h.gcov
	# to ../Logger/include/logger/Logger.h
	def GcovUtil.getSourcePath(gcovFile)
	
		return File.basename(gcovFile).split("##")[1].gsub(/\^/, "..").gsub(/\#/, "/").chomp(".gcov").reverse.chomp("/..").reverse
	end

	# extract gcof-file, eg: src#xcp#XcpProcessor.o##..#include#xcp#XcpPacket.h.gcov
	# to src/xcp/XcpProcessor.o
	def GcovUtil.getObjectPath(gcovFile)
	
		return File.basename(gcovFile).split("##")[0].gsub(/\#/, "/")
	end
end