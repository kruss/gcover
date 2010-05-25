# entry-point for command-line calls to the gem

require 'gcover'

gcover = GCover.new()
gcover.setParameter(ARGV)
gcover.run()