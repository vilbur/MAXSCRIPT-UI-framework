
/** Xml parser
  
 */
struct XmlParser_v
(
	/* construct */
	xml_file_path,
	
	/* required */	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */


	/* properties */
	xml_doc	= dotNetObject "System.Xml.XmlDocument",


	/* dependency */
	/* reference */
	/* inhered */

	/** Open
	 */
	function fileOpen =
	(
		--format "\n"; print "XmlParser_v.fileOpen()"
		ShellLaunch xml_file_path ""
	),
	
	/** Get element
		
		@return XmlElement 
	 */
	function getElement tag_name attr: val: content: ignoreCase:true =
	(
		format "\n"; print "XmlParser_v.getElement()"
		
		element_found = undefined 
		
		elements = this.getElements tag_name attr:attr val:val
		format "elements: %\n" elements
		if content != unsupplied then
			for element in elements \
				where matchPattern element.InnerXML pattern:content ignoreCase:true \
					while element_found == undefined do
						element_found = element
		else
			element_found = elements[1]
		
		element_found --return
	),
	
	/** Get elements

		@return Array of elements
	 */
	function getElements tag_name attr: val: =
	(
		format "\n"; print "XmlParser_v.getElements()"
		--format "tag_name: %\n" tag_name
		--format "attr: %\n" attr
		/* GET XML ELEMENTS */ 
		elements_xml = xml_doc.GetElementsByTagName (tag_name as string )
		format "elements_xml: %\n" elements_xml
		/* GETELEMENTS */ 
		elements = for i = 0 to elements_xml.count - 1 where ( element = (elements_xml.item i)) != undefined collect element
		format "elements: %\n" elements
		if attr != unsupplied then
			/* RETURN ELEMENTS BY ATTRIBUTE VALUE */ 
			this.filterElementsByAttribute elements attr:attr val:val --return
	
		else
			/* RETURN ALL ELEMENTS */ 
			elements --return
	),
	
	
	/** Filter elements by attribute
	 */
	function filterElementsByAttribute elements attr: val:  =
	(
		--format "\n"; print "XmlParser_v.filterElementsByAttribute()"
		elements_found = #()
		
		--for element in elements where ( element_inner = element.InnerXML) != "" do
		for element in elements do
		(
			found_element = this.getElementByAttribute element attr:attr val:val
			
			if found_element != undefined then
				append elements_found found_element
		)

		elements_found --return
	),
	
	/** Get children
	 */
	function getChildren element =
	(
		--format "\n"; print "XmlParser_v.getChildren()"
		for c = 0 to element.ChildNodes.count - 1 collect
			element.ChildNodes.ItemOf[c]
	),

	/** Get attribute
	 */
	function getElementByAttribute element attr: val: =
	(
		--format "\n"; print "XmlParser_v.getElement()"
		found_element = undefined
		
		attr_val = this.getAttribute element attr

		if matchPattern attr_val pattern:val  then
			found_element = element
		
		found_element --return
	),
	
	/** Get attribute
	 */
	function getAttribute element attr =
	(
		format "\n"; print "XmlParser_v.getAttribute()"
		val = undefined

		for a = 0 to element.Attributes.count - 1 while val == undefined do
		(
			attr_item = element.Attributes.ItemOf[a]
			
			if matchPattern attr_item.Name pattern:attr then
				val = attr_item.Value
		)
		
		val --return
	),
	
	/** Set attribute
	 */
	function setAttribute element attr val =
	(
		--format "\n"; print "XmlParser_v.setAttribute()"

		attr = xml_doc.CreateAttribute attr
		
		attr.Value = val
		
		element.Attributes.Append attr

		xml_doc.Save xml_file_path

	),
	
	--/** Get most recent file
	-- */
	--function getMostRecentFile =
	--(
	--	--format "\n"; print "RecentFile_v.getMostRecentFile()"
	--	xml_doc.load recent_file
	--
	--	file_paths = xml_doc.GetElementsByTagName "FilePath"
	--
	--	(file_paths.item 0).InnerXML --return
	--),

	--/** Get recent file not matching mask in blacklist
	--  * @param Array blacklist aray of directories which not should be opened
	--  */
	--function getRecentFileNotMatching blacklist:#() =
	--(
	--	--format "\n"; print "RecentFile_v.getRecentFileNotBackup()"
	--
		--xml_doc.load recent_file
	--
	--	file_paths = xml_doc.GetElementsByTagName "FilePath"
	--
	--	for i = 0 to file_paths.count - 1 where ( file_path_xml = (file_paths.item i)) != undefined  do
	--	(
	--		xml_file_path = file_path_xml.InnerXML
	--		
	--		find_in_blacklist = false
	--
	--		for mask in blacklist while not find_in_blacklist where matchPattern xml_file_path  pattern:( "*\\" + mask + ".max" ) do
	--			find_in_blacklist = true
	--
	--		if not find_in_blacklist then
	--			return xml_file_path
	--	)
	--
	--	undefined --return
	--),

	private


	/**
	 */
	on create do
	(
		format "\n"; print "RecentFile.onCreate()"

		format "xml_file_path: %\n" xml_file_path
		file_exists = doesFileExist xml_file_path
		format "file_exists: %\n" file_exists
		
		if doesFileExist xml_file_path then
			xml_doc.load xml_file_path
	)

)

