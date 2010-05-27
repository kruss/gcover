
class XmlUtil
	
	def XmlUtil.getHeader()
	
		return "<?xml version=\"1.0\" encoding=\"UTF-8\"?> \n"
	end
	
	def XmlUtil.openTag(name, attributes)
	
		if attributes.size == 0 then
			return "<"+name+"> \n"
		else
			xml = "<"+name+" \n"
			attributes.each {|key, value| 
				xml << "\t"+key+"=\""+value+"\" \n"
			}
			xml << "> \n"
			return xml
		end
	end
	
	def XmlUtil.closeTag(name)
	
		return "</"+name+"> \n"
	end
	
end
