
filein( getFilenamePath(getSourceFileName()) + "/MenuItem.ms" )	--"./MenuItem.ms"

filein( getFilenamePath(getSourceFileName()) + "/../XmlParser/XmlParser.ms" )	--"./../XmlParser/XmlParser.ms"

/** Menu for rollout
 */
struct RcMenu_v
(
	/* properties */
	name = "MainMenu",

	self	= this,
	type	= "RCmenu",
	items	= #(),

	--menu, -- <MixinInterface:menu>

	/** Load menu
	 */
	function loadMenu menu_name =
	(
		format "\n"; print "RcMenu_v.loadMenu()"
		format "menu_name: %\n" menu_name
		this.setName menu_name
		--this.name = menu_name
		this.name += "Rc"
		
		menus_xml_file = ((getDir #temp)+"\\XmlParser-Test.mnux")
		format "menus_xml_file:\n%\n" menus_xml_file
		menuMan.saveMenuFile menus_xml_file
		
		XmlParser = XmlParser_v(menus_xml_file)
		
		menu_found = XmlParser.getElement "Menu" attr:"title" val:menu_name

		if menu_found != undefined then
		(

			menu_items = XmlParser.getChildren menu_found
			
			for item in menu_items do
			(
				format "\n"
				--format "item: %\n" item
				 --format "modeName: %\n" (XmlParser.getAttribute item "modeName")
				customTitle = XmlParser.getAttribute item "customTitle"
				format "customTitle: %\n" customTitle
				
				actionID = XmlParser.getAttribute item "actionID"
				--format "actionID: %\n" actionID
				format "modeName: %\n" ( XmlParser.getAttribute item "modeName")
				
				case XmlParser.getAttribute item "modeName" of
				(
					"AM_SEPARATOR":	this.separator()
					"M_SUBMENU":	this.menu customTitle
					"AM_ITEM":	this.item customTitle "messagebox \"Item 1\""
					--default: ""
				)
			)
		)
	),
	
	
	/** Submenu
	 */
	function menu _name =
	(
		local _menu =  RcMenu_v name:_name type:"submenu"

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
		--print "RcMenu_v.item()"
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
		print "RcMenu_v.create()"
		menu_def	= this._getMenuDefinition()
		subitems	= this._getDefinitionsOfMenuItems()
		commands	= this._getAllCommandsDefinitions()
		format "menu_def: %\n" menu_def
		format "subitems: %\n" subitems
		format "commands: %\n" commands

		definition = menu_def + "\n(\n" + subitems + commands + "\n)"
		--format "\n\nDefinition = \n% \n" definition
		if( type == "RCmenu" ) then
			(execute definition) -- return if menu
		else
			definition -- return if submenu
	),
	
	/** Set name
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