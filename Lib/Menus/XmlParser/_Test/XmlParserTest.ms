clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../XmlParser.ms" )	--"./../XmlParser.ms"



/** Create test xml file
 */
function createTestXmlFile xml_path =
(
	--format "\n"; print ".createTestXmlFile()"
	
	xml_lines = #(
		"<?xml version=\"1.0\" encoding=\"utf-8\"?>",
		"<root>",
		"  <item id=\"1\">",
		"    <name>Alpha</name>",
		"    <tag>one</tag>",
		"    <tag>two</tag>",
		"  </item>",
		"</root>"
	)
	
	f = createFile xml_path
	for l in xml_lines do format "%\n" l to:f
	close f	
	
	ShellLaunch xml_path ""

)


/* PREPARE TEST */ 
xml_path = (getDir #temp) + "\\xml_test_ok.xml"

createTestXmlFile(xml_path)


/* GET PARSER ISNTANCE */ 
XmlParser = XmlParser_v(xml_path)


/* GET ELEMENT */ 
element = XmlParser.getElement "tag" content:"one"
format "ELEMENT: %\n" element




/* SET ATTRIBUTE VALUE */ 
XmlParser.setAttribute element "attribute_key" "attribute_value"


/* GET ATTRIBUTE VALUE */ 
attribute_val = XmlParser.getAttribute element "attribute_key"
format "ATTRIBUTE_VAL: %\n" attribute_val
