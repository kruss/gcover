
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
		html << "</head><body><a name='top'/></a> \n"
		html << "<hr> \n"
		return html
	end
	
	def HtmlUtil.getFooter
	
		html =  "<p class='small'><a href='#top'>^-</a></p> \n"
		html << "<hr> \n"
		html << "</body></html> \n"
		return html
	end
	
end
