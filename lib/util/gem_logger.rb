require "logger"
require "fileutils"

class GemLogger
	
  def initialize(logfile, verbose)

    folder = File.dirname(logfile)
    if !File.directory?(folder) then
      FileUtils.mkdir_p(folder)
    end
    
    @file_logger = Logger.new(logfile)
    @file_logger.level = Logger::DEBUG
    format(@file_logger)
      
    @console_logger = Logger.new(STDOUT)
    if verbose then
      @console_logger.level = Logger::DEBUG
    else
      @console_logger.level = Logger::INFO
    end
    format(@console_logger)
  end

  def emph(msg)
    msg = "\n\n\t\t>>> "+msg.to_s.upcase+" <<<\n" 
    @file_logger.info(msg)
    @console_logger.info(msg)
  end
  
  def info(msg)
    @file_logger.info(msg)
    @console_logger.info(msg)
  end  
  
  def debug(msg)
    @file_logger.debug(msg)
    @console_logger.debug(msg)
  end
  
  def warn(msg)
    @file_logger.warn(msg)
    @console_logger.warn(msg)
  end

  def error(msg)
    @file_logger.error(msg)
    @console_logger.error(msg)
  end
  
  def dump(error)
    msg = error.inspect
    error.backtrace.each do |trace|
      msg << "\n"+trace
    end
    error(msg)
  end
  
private

  def format(logger)
    logger.formatter = proc { |severity, datetime, progname, msg|
      "#{datetime.strftime("%Y-%m-%d %H:%M:%S")} <#{severity}>\t #{msg}\n"
    }
  end
end