# entry-point for command-line calls to the gem

require "gcover/gcover"

gcover = GCover.new()
gcover.run()