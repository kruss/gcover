
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

  def FileUtil.openBrowser(path)
    realpath = Pathname.new(path).realpath
    platform = RUBY_PLATFORM.downcase
    done = false
    if platform.include?("mswin") || platform.include?("mingw") then      # windows  
      done = system("rundll32 url.dll,FileProtocolHandler \"#{realpath}\"") 
    elsif platform.include?("linux") then                                 # linux
      browsers = Array[
        "gnome-open", "kfmclient" , "exo-open", "htmlview",               # dektop browsers
        "firefox", "seamonkey", "opera", "mozilla", "netscape", "galeon"  # system browsers
      ]
      browsers.each do |browser|
        if system("#{browser} #{realpath}") then
          done = true
          break
        end
      end   
    elsif platform.include?("mac") || platform.include?("darwin") then   # mac
      done = system("open", realpath)   
    else
      raise "unsupported platform: #{RUBY_PLATFORM}"
    end 
    if !done then
      raise "unable to open browser: #{path}"
    end
  end
  
end
