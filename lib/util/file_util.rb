
class FileUtil
	
	def FileUtil.writeFile(filePath, html)
	
		file = File.new(filePath, "w")
		if file
			file.syswrite(html)
			file.close
		else
		   raise "unable to write: " + filePath
		end
	end

	def FileUtil.openBrowser(filePath)
		
		realpath = Pathname.new(filePath).realpath
		
		os = Config::CONFIG['target_os'] # require 'rbconfig'
		if os.include?("win") then
			sh "rundll32 url.dll,FileProtocolHandler \""+realpath+"\""
		elsif os.include?("linux") then
			sh "htmlview "+realpath
		elsif os.include?("mac") then
			sh "open "+realpath
		else
			raise "unsupported os: "+os
		end
	end
end
