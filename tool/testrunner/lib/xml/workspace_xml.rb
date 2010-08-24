# generates xml output for test-results of an workspace

require "core/cppunit_runner"
require "util/xml_util"
require "util/logger"

class WorkspaceXml

	def initialize(workspaceFolder, outputFolder)
		@workspaceFolder = workspaceFolder		# workspace-folder path
		@outputFolder = outputFolder			# output-folder path
	end
	
	def outputFile
		return @outputFolder+"/"+$AppName+".xml"
	end
	
	def createXmlOutput(cppunitRunner)

  unitTests = cppunitRunner.unitTests

		# create xml
		xml = XmlUtil.getHeader
    xml << XmlUtil.openTag($AppName, {
      "path"=>@workspaceFolder,
      "status"=>Status::getString(cppunitRunner.status)
    })
    unitTests = unitTests.sort_by{|item| item.projectName}
    unitTests.each do |unitTest|
    
      xml << XmlUtil.openTag("unittest", {
        "name"=>unitTest.projectName,
        "status"=>Status::getString(unitTest.status)
      })
      xml << XmlUtil.closeTag("unittest")
    
    end
    xml << XmlUtil.closeTag($AppName)
		
		# output
		FileUtil.writeFile(outputFile, xml)
	end
end