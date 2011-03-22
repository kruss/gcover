
class HtmlUtil

	def HtmlUtil.getCss
	
		css =  "<style type='text/css'> \n"
		css << "  h1				{ font-family:'Arial,sans-serif'; font-size:14pt; font-weight:bold; } \n"
		css << "  h2				{ font-family:'Arial,sans-serif'; font-size:12pt; font-weight:bold; } \n"
		css << "  h3				{ font-family:'Arial,sans-serif'; font-size:11pt; font-weight:bold; } \n"
		css << "  h4				{ font-family:'Arial,sans-serif'; font-size:10pt; font-weight:bold; } \n"
		css << "  body				{ font-family:'Arial,sans-serif'; font-size:8pt; } \n"
		css << "  p,td,li			{ font-family:'Arial,sans-serif'; font-size:8pt; } \n"
		css << "  a:link 			{ color:blue; text-decoration:none; } \n"
		css << "  a:visited 		{ color:blue; text-decoration:none; } \n"
		css << "  a:focus 			{ color:orange; text-decoration:none; } \n"
		css << "  a:hover 			{ color:orange; text-decoration:none; } \n"
		css << "  a:active 			{ color:orange; text-decoration:none; } \n"
		css << "  .small 			{ font-size:7pt; } \n"
		css << "</style> \n"
		return css
	end
	
	def HtmlUtil.getHeader(title)
	
		html =  "<html><head><title>"+title+"</title> \n"
		html << HtmlUtil.getCss
		html << "</head><body> \n"
		html << "<hr> \n"
		return html
	end
	
	def HtmlUtil.getFooter
	
		html = "<hr> \n"
		html << "</body></html> \n"
		return html
	end
	
	def HtmlUtil.getRatioGraph(ratio)
	
		a = ratio.round
		b = 100 - a
		graph = "<pre style='margin-top=0;margin-left=0;margin-right=0;margin-bottom=1'>"
		graph << "<font style='background-color:green;font-size:7pt'>"
		for i in (1..a)
			graph << " "
		end
		graph << "</font>"
		graph << "<font style='background-color:red;font-size:7pt'>"
		for i in (1..b)
			graph << " "
		end
		graph << "</font>"
		graph << "</pre>"
		return graph
	end
	
	def HtmlUtil.urlencode(str)
		str.gsub(/[^a-zA-Z0-9_\.\-]/n) {|s| sprintf('%%%02x', s[0]) }
	end
	
end
