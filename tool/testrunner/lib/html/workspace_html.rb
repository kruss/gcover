# generates html output for test-results of an workspace

require "core/cppunit_runner"
require "util/html_util"
require "util/file_util"
require "util/logger"

class WorkspaceHtml

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
	end
	
	def outputFile
		return @outputFolder+"/index.htm"
	end
	
	def createHtmlOutput(cppunitRunner)
		
    unitTests = cppunitRunner.unitTests
    
		# header
		html = HtmlUtil.getHeader($AppName)
		html << "<h1>"+$AppNameUI+" [ "+@workspaceFolder+" ] - "+Status::getHtml(cppunitRunner.status)+"</h1> \n"
    html << "<hr> \n"

    # tested projects
    html << "<h2>Unit Tests</h2> \n"
    unitTests = unitTests.sort_by{|item| item.projectName}
    if unitTests.size() > 0 then
      html << "<table cellspacing=0 cellpadding=5 border=1> \n"
      html << "<tr>"
      html << " <td width=150><b>Project</b></td>"
      html << " <td width=75><b>Status</b></td>"
      html << "</tr> \n"
      idx = 0
      unitTests.each do |unitTest|
        idx = idx + 1
        
        projectName = unitTest.projectName
        testStatus = unitTest.status
        
        html << "<tr>"
        html << "<td>"+idx.to_s+".) <b>"
        if FileTest.file?(@outputFolder+"/"+projectName+"/cppunit.log") then
          html << "<a href='"+projectName+"/cppunit.log'>"+projectName+"</a>"
        else
          html << projectName
        end
        html << "</b></td>"
        html << "<td>"+Status::getHtml(testStatus)+"</td>"
        html << "<tr> \n"
      end
      html << "</table> \n"
    else
      html << "<ul><i>empty</i></ul> \n"
    end
		
		# footer
		html << HtmlUtil.getFooter
		
		# output
		FileUtil.writeFile(outputFile, html)
	end
end