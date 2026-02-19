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

				PopupMenu ( menu_definition )
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
	function item title command id: enabled:true checked:false =
	(
		--format "\n"; print "RcMenu_v.item()"
		----format "title	= % \n" title
		----format "command	= % \n" command
		--format "enabled: %\n" enabled
		--format "checked: %\n" checked
		
		menu_item = MenuItem_v title:( title as string ) command:command id:id enabled:enabled checked:checked
		
		this._addItem ( menu_item )
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
		
		/* ITEMS ORDER */ 		
		if not this._isEmptySpaceExists() then
			this._reverseItemsOrder()

		/* MENU DEFINITION */ 
		menu_def	= this._getMenuDefinition()
		subitems	= this._getDefinitionsOfMenuItems()
		commands	= this._getAllCommandsDefinitions()
		
		definition = menu_def + "\n(\n" + subitems + commands + "\n)"

		/* RETURN DEFINITION */ 
		if( type == "RCmenu" ) then
			(execute definition) -- return if menu
		else
			definition -- return if submenu
	),
	
	/** Is separator
	 */
	function isSeparator =
	(
		--format "\n"; print "MenuItem_v.isSeparator()"
		false --return
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
		/** Remove whitespace
		 */
		function removeWhitespaceFromName = substituteString this.name " " ""
		
		if( type == "submenu" ) then
			"\nsubMenu \"" + this.name + "\"" -- return
		else
			"RcMenu " + ( removeWhitespaceFromName() ) -- return
	),

	/** Get definitions of items
	 */
	function _getDefinitionsOfMenuItems =
	(
		_definition	= ""
		--format "items.count = % \n" items.count
		
		for item in items do
			_definition += item.create()
			
		--for i = items.count to 1 by -1 do 
		--	_definition += items[i].create()

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

			
		--for i = items.count to 1 by -1 do 
		--	commands += items[i]._getCommandDefinition()

			
			
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
	
	/** Reverse items order
	 */
	function _reverseItemsOrder =
	(
		--format "\n"; print "RcMenu_v._reverseItemsOrder()"
		items = for i = items.count to 1 by -1 collect items[i]
	),

	/** Test if empty space for rightclick menu exists between menu pos and bottom pof screen
	 */
	function _isEmptySpaceExists =
	(
		--format "\n"; print "RcMenu_v._isEmptySpaceExists()"
		item_height	= 23
		separator_height	= 9
		
		cursor_to_bottom_space = ( sysInfo.desktopSize.y - mouse.screenpos.y ) as integer
		

		items_count = (for item in items where not item.isSeparator() collect item).count

		separators_count = items.count - items_count
--
		
		menu_height = (items_count * item_height) + ( separators_count * separator_height)
		--format "menu_height: %\n" menu_height
		--format "cursor_to_bottom_space: %\n" cursor_to_bottom_space
		--format "_isEmptySpaceExists: %\n" (menu_height < cursor_to_bottom_space)
		menu_height < cursor_to_bottom_space --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "RcMenu_v.onCreate()"
		
		MenuToRcLoader_v(this)
	)
)