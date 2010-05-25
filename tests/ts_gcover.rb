# the gem's main test-suite

$:.unshift File.join(File.dirname(__FILE__), "..", "tests")

require 'test/unit/testsuite'
require 'tc_parameter'
require 'tc_statistic'
require 'tc_util'

class TsGCover

	def self.suite
		suite = Test::Unit::TestSuite.new
		
		suite << TcParameter.suite
		suite << TcStatistic.suite
		suite << TcUtil.suite
		
		return suite
	end
end

