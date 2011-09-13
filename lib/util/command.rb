
class Command
  
  def Command.call(command, logger)
      logger.debug("call: '#{command}' (#{Dir.getwd()})")
      out = `#{command} 2>&1`
      status = $?.to_i
      logger.debug("=> return: #{status}#{out.size > 0 ? "\n[#{out}]" : ""}")
      if status != 0 then
        raise "CMD failed: #{command} (#{status})"
      end
  end
  
end