
/** Xml parser
  
 */
struct XmlParser_v
(
	/* construct */
	file_path,
	
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

	/** Get element
		
		@return XmlElement 
	 */
	function getElement tag_name attr: val:  =
	(
		--format "\n"; print "XmlParser_v.getElement()"
		( this.getElements tag_name attr:attr val:val )[1]
	),
	
	/** Get elements

		@return Array of elements
	 */
	function getElements tag_name attr: val: =
	(
		format "\n"; print "XmlParser_v.getElements()"
		format "attr: %\n" attr
		/* GET XML ELEMENTS */ 
		elements_xml = xml_doc.GetElementsByTagName (tag_name as string )

		/* GETELEMENTS */ 
		elements = for i = 0 to elements_xml.count - 1 where ( element = (elements_xml.item i)) != undefined collect element
		format "elements.count: %\n" elements.count
		
		/* RETURN ELEMENTS BY ATTRIBUTE VALUE */ 
		if attr != unsupplied then
			this.filterElementsByAttribute elements attr:attr val:val --return
		--(
		--	elemnets_matching_attr =  this.filterElementsByAttribute elements attr:attr val:val --return
		--	
		--	/*  return array of elements OR single element if parameter attribute is defined and count of founded elements is 1 */ 
		--	if elemnets_matching_attr.count == 1 then elemnets_matching_attr[1] else elemnets_matching_attr --return
		--)
		/* RETURN ALL ELEMENTS */ 
		else
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
		--format "\n"; print "XmlParser_v.getElement()"
		val = undefined

		for a = 0 to element.Attributes.count - 1 while val == undefined do
		(
			attr_item = element.Attributes.ItemOf[a]
			
			if matchPattern attr_item.Name pattern:attr then
				val = attr_item.Value
		)
		
		val --return
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
	--		file_path = file_path_xml.InnerXML
	--		
	--		find_in_blacklist = false
	--
	--		for mask in blacklist while not find_in_blacklist where matchPattern file_path  pattern:( "*\\" + mask + ".max" ) do
	--			find_in_blacklist = true
	--
	--		if not find_in_blacklist then
	--			return file_path
	--	)
	--
	--	undefined --return
	--),

	private


	/**
	 */
	on create do
	(
		--format "\n"; print "RecentFile.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
		xml_doc.load file_path
	)

)

