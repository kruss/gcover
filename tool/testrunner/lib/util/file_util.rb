
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
		rc = false
		
		if os.include?("win") then
		
			rc = system("rundll32 url.dll,FileProtocolHandler \""+realpath+"\"")
			
		elsif os.include?("linux") then
		
			browsers = Array[
				"gnome-open", "kfmclient" , "exo-open", "htmlview", 				# dektop browsers
				"firefox", "seamonkey", "opera", "mozilla", "netscape", "galeon" 	# system browsers
			]
			browsers.each do |browser|
				cmd = browser+" "+realpath
				if system(cmd) then
					rc = true
					break
				end
			end
			
		elsif os.include?("mac") then
		
			rc = system("open", realpath)
			
		else
			raise "unsupported os: "+os
		end
		
		if !rc then
			raise "unable to open browser"
		end
	end
end
