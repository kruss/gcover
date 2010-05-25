$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require 'gcover'

class TcUtil < Test::Unit::TestCase

	def setup	
	end
	
	def teardown
	end
	
	def test_isExternGcovFile
	
		extFile = "src#xcp#XcpProcessor.o##..#^#Logger#include#logger#Logger.h.gcov"
		assert(GcovUtil.isExternGcovFile(extFile))
		
		intFile = "src#xcp#XcpProcessor.o##..#include#xcp#XcpPacket.h.gcov"
		assert(!GcovUtil.isExternGcovFile(intFile))
	end
	
	def test_getProjectName
	
		extFile = "src#xcp#XcpProcessor.o##..#^#Logger#include#logger#Logger.h.gcov"
		assert_equal("Logger", GcovUtil.getProjectName(extFile))
		
		intFile = "src#xcp#XcpProcessor.o##..#include#xcp#XcpPacket.h.gcov"
		assert_raise(RuntimeError){ GcovUtil.getProjectName(intFile) }
	end
	
	def test_getSourcePath
	
		extFile = "src#xcp#XcpProcessor.o##..#^#Logger#include#logger#Logger.h.gcov"
		assert_equal("../Logger/include/logger/Logger.h", GcovUtil.getSourcePath(extFile))
		
		intFile = "src#xcp#XcpProcessor.o##..#include#xcp#XcpPacket.h.gcov"
		assert_equal("include/xcp/XcpPacket.h", GcovUtil.getSourcePath(intFile))
	end
	
	def test_getObjectPath
	
		extFile = "src#xcp#XcpProcessor.o##..#^#Logger#include#logger#Logger.h.gcov"
		assert_equal("src/xcp/XcpProcessor.o", GcovUtil.getObjectPath(extFile))
		
		intFile = "src#xcp#XcpProcessor.o##..#include#xcp#XcpPacket.h.gcov"
		assert_equal("src/xcp/XcpProcessor.o", GcovUtil.getObjectPath(intFile))
	end
	
end