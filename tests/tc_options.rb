$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require 'gcover'

class TcOptions < Test::Unit::TestCase

	def setup	
	end
	
	def teardown
	end
	
	def test_no_option
	
		ARGV.clear()
		gcover = GCover.new()
		assert_equal(nil, $AppOptions[:workspace])
		assert_equal(nil, $AppOptions[:output])
	end
	
	def test_option_workspace
	
		ARGV.clear()
		ARGV << "-w" << "workspace"
		GCover.new()
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal("workspace/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << "C:/workspace"
		GCover.new()
		assert_equal("C:/workspace", $AppOptions[:workspace])
		assert_equal("C:/workspace/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << "C:\\workspace"
		GCover.new()
		assert_equal("C:/workspace", $AppOptions[:workspace])
		assert_equal("C:/workspace/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << "."
		GCover.new()
		current = Dir.getwd
		assert_equal(current, $AppOptions[:workspace])
		assert_equal(current+"/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << ".."
		GCover.new()
		parent = Pathname.new(Dir.getwd+"/..").cleanpath.to_s
		assert_equal(parent, $AppOptions[:workspace])
		assert_equal(parent+"/"+$AppOutput, $AppOptions[:output])
		
	end
	
	def test_option_output
	
		ARGV.clear()
		ARGV << "-w" << "workspace"
		ARGV << "-o" << "output"
		GCover.new()
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal("output/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << "workspace"
		ARGV << "-o" << "C:/output"
		GCover.new()
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal("C:/output/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << "workspace"
		ARGV << "-o" << "C:\\output"
		GCover.new()
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal("C:/output/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << "workspace"
		ARGV << "-o" << "."
		GCover.new()
		current = Dir.getwd
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal(current+"/"+$AppOutput, $AppOptions[:output])
		
		ARGV.clear()
		ARGV << "-w" << "workspace"
		ARGV << "-o" << ".."
		GCover.new()
		parent = Pathname.new(Dir.getwd+"/..").cleanpath.to_s
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal(parent+"/"+$AppOutput, $AppOptions[:output])
		
	end
	
	def test_option_all

		ARGV.clear()
		ARGV << "-w" << "workspace"
		GCover.new()
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal("workspace/"+$AppOutput, $AppOptions[:output])
		assert(!$AppOptions[:all])
			
		ARGV.clear()
		ARGV << "-w" << "workspace"
		ARGV << "-a"
		GCover.new()
		assert_equal("workspace", $AppOptions[:workspace])
		assert_equal("workspace/"+$AppOutput, $AppOptions[:output])
		assert($AppOptions[:all])
		
	end
end