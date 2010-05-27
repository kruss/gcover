# a simple logger for ruby apps

$logfile = nil

class Logger
	
	def Logger.setLogfile(logfile)
	
		if FileTest.file?(logfile) then 
			FileUtils.rm(logfile) 		
		end
		$logfile = logfile
	end
	
	def Logger.getLogfile
		return $logfile
	end
	
	def Logger.info(text)
		log = "\n\t[ "+text+" ]\n\n"
		writeConsole(log)
		writeFile(log)
	end
	
	def Logger.log(text)
		log = "> "+text+"\n"
		writeConsole(log)
		writeFile(log)
	end
	
	def Logger.debug(text)
		log = "~ "+text+"\n"
		writeFile(log)
	end
	
	def Logger.error(text)
		log = "! "+text+"\n"
		writeFile(log)
	end
	
	def Logger.skipLine
		log = "\n"
		writeConsole(log)
		writeFile(log)
	end

private

	def Logger.writeConsole(text)
		puts text	
	end
	
	def Logger.writeFile(text)
	
		if $logfile != nil then
			file = File.new($logfile, "a")
			if file
				file.syswrite(text)
				file.close
			else
			   raise "unable to write: " + $logfile
			end
		end
	end
end