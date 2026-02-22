filein( getFilenamePath(getSourceFileName()) + "/MenuItem.ms" )	--"./MenuItem.ms"

filein( getFilenamePath(getSourceFileName()) + "/MenuToRcLoader/MenuToRcLoader.ms" )	--"./MenuToRcLoader/MenuToRcLoader.ms"

/** RC menu is menu evalutaed on the fly
	
	
	
	@method popUp will popup window on mouse cursor position
  
 */
struct RcMenu_v
(
	/* properties */
	name = "MainRcMenu",

	type	= "RCmenu",
	items	= #(),
	
	/* static */ 
	item_height	= 23,
	separator_height	= 9,
	
	/* private */ 
	
	/** Pop up
	 */
	function popUp pos:mouse.screenpos =
	(
		--format "\n"; print "RcMenu_v.popUp()"
		--format "items.count: %\n" items.count
		try(
			if items.count > 0 then
			(
				menu_definition = this.create pos_y:(pos.y as integer )

				PopupMenu menu_definition pos:pos
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
	  * @param	string	command	Event of item
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
	function create pos_y: =
	(
		format "\n---------------------------------------------\n"
		format "\n"; print "RcMenu_v.create()"
		format "this.name: %\n" this.name
		--format "this.type: %\n" this.type
		format "pos_y: %\n" pos_y

		menu_height = this._getMenuHeight()
		--format "menu_height: %\n" menu_height

		items_order_reversed = not this._isEmptySpaceExists(pos_y)(menu_height)
		--format "items_order_reversed: %\n" items_order_reversed
		/* ITEMS ORDER */ 		
		--if items_order_reversed = not this._isEmptySpaceExists(pos_y) then
		if items_order_reversed then
			this._reverseItemsOrder()

		/* MENU DEFINITION */ 
		menu_def	= this._getMenuDefinition()
		menu_items	= this._getDefinitionsOfMenuItems(pos_y)(menu_height)(items_order_reversed)
		items_events	= this._getEventsDefinition()
		--format "menu_items: %\n" menu_items
		--format "items_events: %\n" items_events
		/* CONCAT DEFINITION */ 
		definition = menu_def + "\n(\n" + menu_items + items_events + "\n)"

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
	  
	  @param integer pos
	  
	 */
	function _getDefinitionsOfMenuItems pos_y menu_height items_order_reversed =
	(
		format "\n"; print "RcMenu_v._getDefinitionsOfMenuItems()"
		format "this.name: %\n" this.name
		format "pos_y: %\n" pos_y
		--format "menu_height: %\n" menu_height
		--format "items_order_reversed: %\n" items_order_reversed
		_definition	= ""
		
		--format "***** REVERSED: %\n" items_order_reversed
		direction = if items_order_reversed then -1 else 1
		
		origin_y = if items_order_reversed then pos_y - menu_height else pos_y
		format "origin_y: %\n" origin_y
		
		for item in items do
		(
			--format "item.isSeparator(): %\n" (item.isSeparator())			
			--_definition += item.create()
			
			height_increment = if item.isSeparator() then separator_height else item_height 
			
			--format "% %\n" origin_y item
			_definition += item.create pos_y:origin_y
			
			--origin_y += height_increment * direction
			origin_y += height_increment
			
			
			--_definition += item.create()
		)

		_definition -- return
	),

	/** Get all events definitions in RcMenu
	 */
	function _getEventsDefinition =
	(
		events	= ""

		if( type != "submenu" ) then
			events	= this._getEventDefinition()

		events -- return
	),

	/** Get events definition of items in menu
	 */
	function _getEventDefinition =
	(
		events	= ""

		for item in items do
			events += item._getEventDefinition()
			
		events --return
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

	/** Set menu height
	 */
	function _getMenuHeight =
	(
		--format "\n"; print "RcMenu_v._getMenuHeight()"
		
		--if this.type == "submenu" then
		--format "items.count: %\n" items.count
		separators_count = (for item in items where item.isSeparator() collect item).count
		--format "separators_count: %\n" separators_count
		items_count = items.count - separators_count
		--format "items_count: %\n" items_count
		
		(items_count * item_height) + ( separators_count * separator_height)
		
	),
	
	/** Test if empty space for rightclick menu exists between menu pos and bottom pof screen
	 */
	function _isEmptySpaceExists pos_y menu_height =
	(
		--format "\n"; print "RcMenu_v._isEmptySpaceExists()"
		--format "pos_y: %\n" pos_y
		--format "menu_height: %\n" menu_height
		
		free_space_for_menu = ( sysInfo.desktopSize.y - pos_y ) as integer

		--format "free_space_for_menu: %\n" free_space_for_menu
		--format "RESULT: %\n" (menu_height <= free_space_for_menu)
		menu_height <= free_space_for_menu --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "RcMenu_v.onCreate()"
		
		MenuToRcLoader_v(this)
	)
)