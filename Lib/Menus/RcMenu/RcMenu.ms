filein( getFilenamePath(getSourceFileName()) + "/MenuItem.ms" )	--"./MenuItem.ms"

filein( getFilenamePath(getSourceFileName()) + "/MenuToRcLoader/MenuToRcLoader.ms" )	--"./MenuToRcLoader/MenuToRcLoader.ms"

/** Menu for rollout
 */
struct RcMenu_v
(
	/* properties */
	name = "MainRcMenu",

	type	= "RCmenu",
	items	= #(),
	
	/** Pop up
	 */
	function popUp =
	(
		--format "\n"; print "RcMenu_v.popUp()"
		--format "items.count: %\n" items.count
		try(
			
			if items.count > 0 then
			(
				menu_definition = this.create()

				popUpMenu( menu_definition )
			)
			else
				FORMAT "\nWARNING: RcMenu_v HAS NOT ANY ITEMS. -> RcMenu.name: \"%\"\n" name
				
		)
		catch
		(
			FORMAT "\n************ EXCEPTION ************\n%\n***********************************\n" (getCurrentException())
			FORMAT "\n**************** EXCEPTION File: % ****************\n\n%\n\n**************************************************************************************************************************************\n" filein_path (getCurrentException())
		)
	),
	
	/** Add submenu to rc menu
	 */
	function menu _name =
	(
		local _menu =  RcMenu_v name:_name type:"submenu" --XmlParser:XmlParser

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
		--format "type: %\n" type

		menu_def	= this._getMenuDefinition()
		subitems	= this._getDefinitionsOfMenuItems()
		commands	= this._getAllCommandsDefinitions()
		--format "menu_def: %\n" menu_def
		--format "subitems: %\n" subitems
		--format "commands: %\n" commands

		definition = menu_def + "\n(\n" + subitems + commands + "\n)"
		--format "\n\n\n\nDefinition = \n% \n" definition
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
		--format "\n"; print "RcMenu_v._addItem()"
		append items item
	),

	/** Get menu definition
	 */
	function _getMenuDefinition =
	(
		menu_name = substituteString this.name " " ""
		
		
		if( type == "submenu" ) then
			"\nsubMenu \"" + menu_name + "\"" -- return
		else
			"RcMenu " + menu_name -- return
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
		--format "\n"; print "RcMenu_v.onCreate()"
		
		MenuToRcLoader_v(this)
		
		--if ( MenuRc = (MenuToRcLoader_v(this)).loadMenu() ) != undefined then
		--(
		--	
		--)
		--	format "MenuRc: %\n" MenuRc
		--
		--this.setName this.name
		
	)
)


