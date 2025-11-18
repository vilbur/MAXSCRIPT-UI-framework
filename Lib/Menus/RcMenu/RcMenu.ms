
filein( getFilenamePath(getSourceFileName()) + "/MenuItem.ms" )	--"./MenuItem.ms"

filein( getFilenamePath(getSourceFileName()) + "/../XmlParser/XmlParser.ms" )	--"./../XmlParser/XmlParser.ms"

/** Menu for rollout
 */
struct RcMenu_v
(
	/* properties */
	name = "MainRcMenu",

	self	= this,
	type	= "RCmenu",
	items	= #(),
	
	XmlParser,

	--menu, -- <MixinInterface:menu>

	/** Load existing menu to Rightclick menu
	 */
	function loadMenu menu_name =
	(
		format "\n"; print "RcMenu_v.loadMenu()"
		format "menu_name: %\n" menu_name
		--this.setName menu_name

		/* RC menu must has different name then classic menu */ 
		--this.name += "Rc"
		format "this.name: %\n" this.name
		/* Path to *.mnux file */ 
		menus_xml_file = ((getDir #temp)+"\\XmlParser-Test.mnux")

		/* SAVE MENUS TO FILE */ 
		menuMan.saveMenuFile menus_xml_file
		
		/* LOAD FILE TO PARSER */ 
		this.XmlParser = XmlParser_v(menus_xml_file)
		
		/* ADD MENU ITEMS */ 
		this.addMenuXML menu_name this
		
		/* CLEANUP */ 
		deleteFile menus_xml_file
	),
	
	/** Add menu
	 */
	function addMenuXML menu_name &MenuRc =
	(
		--format "\n"; print "RcMenu_v.addMenuXML()"
		
		/* LOAD Menu from xml */ 
		menu_xml = this.XmlParser.getElement "Menu" attr:"title" val:menu_name
		
		if menu_xml != undefined then
		(
			menu_items = this.XmlParser.getChildren menu_xml
			
			/* ADD ITEMS TO MENU */ 
			for item in menu_items do
			(
				--format "\n"
				customTitle = this.XmlParser.getAttribute item "customTitle"
				
				actionID = this.XmlParser.getAttribute item "actionID"

				if actionID != undefined then
					macro_category_and_name	= filterString actionID "`"
				
				case this.XmlParser.getAttribute item "modeName" of
				(
					"AM_ITEM":	MenuRc.item customTitle ("macros.run \""+macro_category_and_name[2]+"\" \""+macro_category_and_name[1]+"\"" )

					"AM_SUBMENU":	MenuRc.addMenuXML (customTitle) (MenuRc.menu customTitle)
					
					"AM_SEPARATOR":	MenuRc.separator()
				)
			)
		)
		else
			FORMAT "\nWARNING: RcMenu_v.addMenuXML() -> MENU DOES NOT EXISTS: RcMenu_v: \"%\"\n" menu_name
		
		
		MenuRc --return
	),
	
	/** Pop up
	 */
	function popUp =
	(
		--format "\n"; print "RcMenu_v.popUp()"
		
		popUpMenu (this.create())
	),
	
	/** Add submenu to rc menu
	 */
	function menu _name =
	(
		local _menu =  RcMenu_v name:_name type:"submenu" XmlParser:XmlParser

		this._addItem _menu

		_menu --return
	),

	/** Add item to menu
	  *
	  * @param	string	title	Title of item
	  * @param	string	command	Command of item
	  * @param	string	[id]	Id of item, if empoty, then sanitized title is used
	 */
	function item title command id: =
	(
		--format "\n"; print "RcMenu_v.item()"
		--format "title	= % \n" title
		--format "command	= % \n" command
		this._addItem (MenuItem_v title:( title as string ) command:command id:id)
	),

	/** Set separator item
	 */
	function separator =
	(
		this.item "separator" ""
	),

	/** Create menu
	  *
	  * [rcmenu ]](https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_17DBC9E3_5B61_4738_B78B_D3D57A515CE8_htm)
	  *
	  * @return	RcMenu class|string	Return RcMenu for 'CreateDialog menu:RcMenu' or definition of submenu
	 */
	function create =
	(
		--format "\n"; print "RcMenu_v.create()"
		menu_def	= this._getMenuDefinition()
		subitems	= this._getDefinitionsOfMenuItems()
		commands	= this._getAllCommandsDefinitions()
		--format "menu_def: %\n" menu_def
		--format "subitems: %\n" subitems
		--format "commands: %\n" commands

		definition = menu_def + "\n(\n" + subitems + commands + "\n)"
		--format "\n\nDefinition = \n% \n" definition
		if( type == "RCmenu" ) then
			(execute definition) -- return if menu
		else
			definition -- return if submenu
	),
	
	/** Set name of menu - avoid whitespace
	 */
	function setName menu_name =
	(
		--format "\n"; print "RcMenu_v.setName()"
		this.name = substituteString menu_name " " ""
	),

	/** Add item
	 */
	function _addItem item =
	(
		append items item
	),

	/** Get menu definition
	 */
	function _getMenuDefinition =
	(
		if( type == "submenu" ) then
			"\nsubMenu \"" + name + "\"" -- return
		else
			"RcMenu " + name -- return
	),

	/** Get definitions of items
	 */
	function _getDefinitionsOfMenuItems =
	(
		_definition	= ""
		--format "items.count = % \n" items.count
		for item in items do
			_definition += item.create()

		_definition -- return
	),

	/** Get all commands definitions in RcMenu
	 */
	function _getAllCommandsDefinitions =
	(
		commands	= ""

		if( type != "submenu" ) then
			commands	= this._getCommandDefinition()

		commands -- return
	),

	/** Get commands definition of items in menu
	 */
	function _getCommandDefinition =
	(
		commands	= ""

		for item in items do
			commands += item._getCommandDefinition()

		commands --return
	),

	/** Rem
	  ove double separators and separators on start or end of menu
	 */
	function clearSeparators =
	(
		--format "\n"; print "Menu_v.clearSeparators()"
		indexes_to_remove 	= #()
		next_item_is_separator	= false

		--items = this._getMenuItems()
		--format "items.count	= % \n" items.count
		for i = 1 to items.count do
		(
			local item = items[i]
			--format "item: %\n" item

			item_is_separator = item.isSeparator()

			next_item_is_separator = i < items.count and (items[i + 1]).isSeparator()

			if (SEPARATOR_IS_FIRST = (item_is_separator and i == 1 ) or
			  (SEPARATOR_IS_LAST  = (item_is_separator and i == items.count) )) or
			  (SEPARATOR_IS_TWICE = (item_is_separator and next_item_is_separator )) then
				append indexes_to_remove i

		)

		for i = indexes_to_remove.count to 1 by -1 do
			deleteItem items i
			--menu.removeItemByPosition (indexes_to_remove[i])
	),

	/**
	 */
	on create do
	(
		this.setName this.name
	)
)