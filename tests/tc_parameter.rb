$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'test/unit'
require 'gcover'

class TcParameter < Test::Unit::TestCase

	def setup	
		@gcover = GCover.new()
	end
	
	def teardown
	end
	
	def test_no_param
	
		args = []
		@gcover.setParameter(args)
		assert_equal(nil, @gcover.workspaceFolder)
		assert_equal(nil, @gcover.outputFolder)
	end
	
	def test_one_param
	
		args1 = ["workspace"]
		@gcover.setParameter(args1)
		assert_equal("workspace", @gcover.workspaceFolder)
		assert_equal("workspace/"+$outputFolderName, @gcover.outputFolder)
		
		args2 = ["C:/workspace"]
		@gcover.setParameter(args2)
		assert_equal("C:/workspace", @gcover.workspaceFolder)
		assert_equal("C:/workspace/"+$outputFolderName, @gcover.outputFolder)
		
		args3 = ["C:\\workspace"]
		@gcover.setParameter(args3)
		assert_equal("C:/workspace", @gcover.workspaceFolder)
		assert_equal("C:/workspace/"+$outputFolderName, @gcover.outputFolder)
		
		args4 = ["."]
		@gcover.setParameter(args4)
		assert_equal(Dir.getwd, @gcover.workspaceFolder)
		assert_equal(Dir.getwd+"/"+$outputFolderName, @gcover.outputFolder)
		
		args5 = [".."]
		@gcover.setParameter(args5)
		parent = Pathname.new(Dir.getwd+"/..").cleanpath.to_s
		assert_equal(parent, @gcover.workspaceFolder)
		assert_equal(parent+"/"+$outputFolderName, @gcover.outputFolder)
	end
	
	def test_two_param
	
		args1 = ["workspace", "output"]
		@gcover.setParameter(args1)
		assert_equal("workspace", @gcover.workspaceFolder)
		assert_equal("output/"+$outputFolderName, @gcover.outputFolder)
		
		args2 = ["C:/workspace", "C:/output"]
		@gcover.setParameter(args2)
		assert_equal("C:/workspace", @gcover.workspaceFolder)
		assert_equal("C:/output/"+$outputFolderName, @gcover.outputFolder)
		
		args3 = ["C:\\workspace", "C:\\output"]
		@gcover.setParameter(args3)
		assert_equal("C:/workspace", @gcover.workspaceFolder)
		assert_equal("C:/output/"+$outputFolderName, @gcover.outputFolder)
		
		args4 = [".", "."]
		@gcover.setParameter(args4)
		assert_equal(Dir.getwd, @gcover.workspaceFolder)
		assert_equal(Dir.getwd+"/"+$outputFolderName, @gcover.outputFolder)
		
		args5 = ["..", ".."]
		@gcover.setParameter(args5)
		parent = Pathname.new(Dir.getwd+"/..").cleanpath.to_s
		assert_equal(parent, @gcover.workspaceFolder)
		assert_equal(parent+"/"+$outputFolderName, @gcover.outputFolder)
	end

	def test_too_much_param
	
		args = ["a", "b", "c"]
		@gcover.setParameter(args)
		assert_equal(nil, @gcover.workspaceFolder)
		assert_equal(nil, @gcover.outputFolder)
	end
end