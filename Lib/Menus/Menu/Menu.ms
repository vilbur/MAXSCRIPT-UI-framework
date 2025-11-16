
global EMPTY_QUAD


/** Wrapper for <MixinInterface:menu>
  *
  *	HELP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3#GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3__GUID-550885E9-1A73-423C-A837-865E96CF7824
  */
struct Menu_v
(
	/* construct */
	name,

	flat = true,
	--quad = false, -- get menu wich is not saved in menus

	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	menu, -- <MixinInterface:menu>

	quad_index,
	quad_width = 26, -- width of quad menu in characters
	/** Get menu from menus list HELP:https://help.autodesk.com/view/3DSMAX/2022/ENU/?guid=GUID-F8993D95-943E-4031-B1C6-6B2BADE4DB9E#GUID-F8993D95-943E-4031-B1C6-6B2BADE4DB9E__WS73099CC142F4875546792D6511E39D97277-15A5
	 */
	function getMenu menu_name =
	(
		--format "\n"; print "Menu_v.getMenu()"
		--format "menu_name = % \n" menu_name
		if (_menu = menuMan.findMenu menu_name) != undefined then
			(Menu_v menu:_menu) --return
	),

	/** Add menu item
	 *
	 * @return	<MixinInterface:menuItem>|false false if adding fails
	 */
	function addItem category macro_script_name title: group: index: =
	(
		--format "\n"; print "Menu_v.addItem()"
		--format "category	= % \n" category
		--format "macro_script_name	= % \n" macro_script_name
		--format "title	= % \n" title

		item = if( group == unsupplied ) then menuMan.createActionItem (macro_script_name) (category) else menuMan.createMenuItemFromAction ( group ) (macro_script_name) --category:(category)
		--format "item = % \n" item
		if item == undefined then
		(
			format "\n\n----------- WARNING - undefined menu item ---------------------- \n\n(%).addItem(\"%\")(\"%\")\n\n	MENU:   %\n	CATEGORY: %\n	SCRIPT NAME: %\n" this.name category macro_script_name this.name category macro_script_name

			return false
		)

		/* SET TITLE */
		if( title != unsupplied ) then
			this._setTitleToItem(item)(title)
		else
			title = item.getTitle()

		/* GET INDEX */
		if index == unsupplied or index == undefined then
			index = menu.numItems() +1


		/* ADD ITEM TO MENU */
		if this.getItem(title) == undefined then
			menu.addItem (item) (index)

		item --return
	),

	/** Add multiple items at once
	  *
	  * @param string|#name	category
	  * @param #("item"|#item)	macro_script_names
	  *
	  * return this
	 */
	function addItems category macro_script_names =
	(
		--format "\n"; print "Menu_v.addItems()"
		for macro_script_name in macro_script_names do
			this.addItem (category as string ) (macro_script_name as string )

		this --return
	),


	/** Add quad from 'menus' to quad
	  *
	  * 		IMPORTANT: Menu does not show, if does not contain any items
	  *
	  * @param	Menu_V|string|<MixinInterface:menu>	menu_or_name	menu or name of menu which will be added as sub menu
	  * @param	string	title	custom title of menu displayed in quad
	  * @param	boolean	flat	menu will be flat or not
	  *
	  * @return Menu_v
	 */
	function addMenu menu_or_name title: index: flat:this.flat separators:#() =
	(
		--format "\n"; print "Menu_v.addMenu()"
		--format "menu_or_name: %\n" menu_or_name

		if menu_or_name == undefined or menu_or_name == "" then
			return false

		/*------------------------------------------------------------------------------
			IF <MixinInterface:menu>
		--------------------------------------------------------------------------------*/
		if classOf menu_or_name == MixinInterface then
		(
			submenu = menu_or_name

			if title == unsupplied then
				title = menu_or_name.getTitle()
		)
		/*------------------------------------------------------------------------------
			IF "Menu Name" is string
		--------------------------------------------------------------------------------*/
		else if classOf menu_or_name == string then
		(
			submenu = this._getOrCreateMenu(menu_or_name)

			if title == unsupplied then
				title = menu_or_name
		)

		/*------------------------------------------------------------------------------
			IF Menu_v()
		--------------------------------------------------------------------------------*/
		else if superClassOf menu_or_name == StructDef then
		(
			flat = menu_or_name.flat

			submenu =  menu_or_name.menu

			if title == unsupplied then
				title = menu_or_name.name
		)

		/*------------------------------------------------------------------------------
			EXIT IF NO ITEMS EXISTS
		--------------------------------------------------------------------------------*/
		if submenu.numItems() == 0 then
			FORMAT "\n\n\n*********** WARNING: MENU HAS NOT ANY ITEMS **********************\nMenu: \"%\"\n" (submenu.getTitle())
		--(
		--
		--	return false
		--	--return (Menu_v())
		--)

		/* ADD AS LAST ITEM */
		if index == unsupplied then
			index = menu.numItems() + 1

		menu_item	= this.getItem( title )
			
		if menu_item == undefined then -- if item with title does not exists yet
		(
			menu_item = menuMan.createSubMenuItem (title) (submenu)

			this._setTitleToItem(menu_item)(title)

			--if flat then

			menu.addItem menu_item (index)
		)

		menu_item.setDisplayFlat( flat )
		--format "submenu = % \n" submenu

		_Menu = Menu_v menu:submenu

		_Menu.addSeparators ( separators )

		_Menu --return
	),

	/** Add menus at once
	  *
	  * @param #( "Title", Menu_v )	titles_and_menus	pairs of titles and menus
	  * @param boolean 	separator between menus
	  *
	 */
	function addMenus titles_and_menus separator:true =
	(
		--format "\n"; print "QuadMenu_v.addMenus()"
		--Quads[quad_index].addMenu (menu_name)
		for i = 1 to titles_and_menus.count by 2 do
		(
			--Menu_new = this.addMenu (titles_and_menus[i+1]) title:(titles_and_menus[i])  --index:index
			Menu_new = this.addMenu (titles_and_menus[i+1]) title:(titles_and_menus[i])  --index:index

			if separator then
				Menu_new.addSeparator index:1
		)
	),

	/** Get item from menu
	  *
	  * @param	string|integer	index_or_title
	  *
	  * @return	<MixinInterface:menuItem>|undefined
	 */
	function getItem index_or_title =
	(
		--format "\n"; print "Menu_v.getItem()"
		--format "index_or_title = % \n" index_or_title
		--format "classOf index_or_title	= % \n" (classOf index_or_title)

		if classOf index_or_title == string then
		(
			--menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)
			menu_item_found = for item in (this._getMenuItems()) where item.getTitle() == index_or_title collect item

			menu_item_found[1] --return
		)
		else
		(
			index = index_or_title
			
			items_count = menu.numItems()

			if index > items_count then
			(
				FORMAT "	%.getItem(%) -- WARNING - index % is higher then count of items %\n" this.name index index items_count

				undefined --return
			)
			else
			(
				menu_item = menu.getItem(index) --return

			)

		)
	),

	/** Get submenu from menu item
	  *
	  * @return	Menu_v menu:submenu|undefined
	 */
	function getSubMenu index_or_title =
	(
		--format "\n"; print "Menu_v.getSubMenu()"
		--menu_item = this.getItem index_or_title
		--format "menu_item.getTitle()	= % \n" (menu_item.getTitle())
		--submenu = menu_item.getSubMenu()
		--format "menu_item	= % \n" menu_item
		--format "(menu_item.getTitle())	= % \n" (menu_item.getTitle())
		--format "submenu	= % \n" submenu

		if (menu_item = this.getItem index_or_title) != undefined and ( submenu = menu_item.getSubMenu() ) != undefined then
			(Menu_v menu:submenu) --return
	),

	/** Remove given item or by title
	  *
	  * @param	Array|BitArray|<MixinInterface:menuItem>|string|integer|	index_title_item MenuItem, title string or index of item, can be array of these
	  *
	  * @return	menuItem
	 */
	function removeItem index_title_item =
	(
		--format "\n"; print "Menu_v.removeItem()"
		--format "classOf index_title_item: %\n" ( classOf index_title_item )

		if classOf index_title_item == BitArray then
			index_title_item = index_title_item as Array

		if classOf index_title_item != Array then
		(
			menu_item = if classOf index_title_item == MixinInterface then index_title_item else this.getItem(index_title_item) 
			--format "menu_item: %\n" menu_item
			if menu_item != undefined then
				menu.removeItem menu_item

			menu_item --return

		)
		else
			for single_parameter in this._reverseArray(index_title_item) do
				this.removeItem (single_parameter)
	),

	/** Remove all itens in menu
	  *
	  */
	function clearMenu =
	(
		--format "\nMenu_v.clearMenu(): %\n" this.name
		--format "this.menu: %\n" this.menu
		--format "this.numItems(): %\n" (this.numItems())
		--format "\n"; print "Menu_v.clearMenu()"
		--format "this: %\n" this
		--format "\n"; ( print "Menu_v.clearMenu() " + (menu.getTitle()) )
		format "\n"; print ( "Menu_v.clearMenu() " + this.name )
		
		for i = menu.numItems() to 1 by -1 do
			this.removeItem(i)
			
		--format "this.numItems(): %\n" (this.numItems())
	),

	/** Move item in menu
	  *
	  * @param	integer|-1	index desired position of item, i -1 then item is moved on end of menu
	 */
	function moveItem index_or_title index =
	(
		--format "\n"; print "Menu_v.moveItem()"
		menu_item = this.removeItem (index_or_title)

		 if index == -1 then
			index = menu.numItems() + 1

		if menu_item != undefined then
			menu.addItem (menu_item) (index)
	),

	/** Add separator on index or end of menu
	  *
	  * @param integer|#(integer) index or array of indexes where add separator, if UNSUPPLIED then add separator on the end of menu
	  *
	  * If separator on this index exists already, then will not be added
	 */
	function addSeparator index: =
	(
		--format "\n"; print "Menu_v.addSeparator()"
		this._addSeparator (index)
	),

	/** Wrapper for this.addSeparator()
	 */
	function addSeparators indexes =
	(
		--format "\n"; print "Menu_v.addSeparators()"
		for index in this._reverseArray(indexes) do
			this._addSeparator (index)
	),

	/** Add separator on index or end of menu
	  *
	  * @param integer|#(integer) index or array of indexes where add separator, if UNSUPPLIED then add separator on the end of menu
	  *
	  * If separator on this index exists already, then will not be added
	 */
	function addSeparator index: =
	(
		--format "\n"; print "Menu_v.addSeparator()"
		--format "index = % \n" index
		if classOf index == Array then
			for _index in this._reverseArray(index) do
				this._addSeparator (_index)
		else
			this._addSeparator (index)
	),

	/** Remove separator on index
	  *
	  * @return	false if separator has not been deleted
	 */
	function removeSeparator index =
	(
		if index <= (menu.numItems()) and (menu.getItem(index)).getIsSeparator() then
			menu.removeItemByPosition(index)
		else
			false --return
	),


	/** Remove double separators and separators on start or end of menu
	 */
	function clearSeparators =
	(
		--format "\n"; print "Menu_v.clearSeparators()"
		indexes_to_remove 	= #()
		next_item_is_separator	= false

		menu_items = this._getMenuItems()
		--format "menu_items.count	= % \n" menu_items.count
		for i = 1 to menu_items.count do
		(
			item = menu_items[i]

			item_is_separator = item.getIsSeparator()

			next_item_is_separator = i < menu_items.count and (menu_items[i + 1]).getIsSeparator()

			if (SEPARATOR_IS_FIRST = (item_is_separator and i==1 ) or
			  (SEPARATOR_IS_LAST  = (item_is_separator and i==menu_items.count) )) or
			  (SEPARATOR_IS_TWICE = (item_is_separator and next_item_is_separator )) then
				append indexes_to_remove i

		)

		for i = indexes_to_remove.count to 1 by -1 do
			menu.removeItemByPosition (indexes_to_remove[i])
	),

	/** Set title to menu
	 */
	function setTitle title =
	(
		--format "\n"; print "Menu_v.setTitle()"
		--format "title	= % \n" title
		/** Kind of center quad title
		  *
		  * Default title is aligned to opposite sides that i like to be ;)
		 */
		function flipAlign title =
		(
			--format "\n"; print "QuadMenu_v.flipAlign()"

			empty_space = ""

			for i = 1 to ( this.quad_width - title.count) / 2 do
				empty_space += "   "

			if this.quad_index < 3 then --
				title += empty_space --return "Title       "

			else
				empty_space + title --return  "       Title"

			--title --return
		)

		--format "quad_index	= % \n" quad_index
		if this.quad_index != undefined then
			title = flipAlign (title)

		menu.setTitle title


	),

	/** Set submenu item flat
	 */
	function setFlat index_or_title state =
	(
		if( submenu = this.getItem(index_or_title) ) != undefined then
			submenu.setDisplayFlat (state)
	),

	/** Print menu items to script listener
	  * Useful to look into hidden subemnus
	 */
	function showItems =
	(
		--format "\n"; print "Menu_v.showItems()"
		menu_items = this._getMenuItems()
		--format "menu_items.count	= % \n" menu_items.count
		for i = 1 to menu_items.count do
		(
			item = menu_items[i]

			format "\nitem %:	" i

			format "%" ( if item.getIsSeparator() then "--------" else item.getTitle() )
		)
		format "\n"
	),

	--/** Get menu items
	-- */
	--function numItems =
	--(
	--	--format "\n"; print "Menu_v._getMenuItems()"
	--	menu.numItems()
	--),

	/** Get menu items
	 */
	function getItems =
	(
		--format "\n"; print "Menu_v.getMenuItems()"
		this._getMenuItems()
	),
	
	private

	--/** Get item
	-- */
	--function _getItem index =
	--(
	--	--format "\n"; print "Menu_v._getItem()"
	--	if index > menu.numItems() then
	--	(
	--		format "Menu_v._getItem() index:% IS HIGHER THEN NUMBER OF ITEMS\n\n" index
	--
	--		undefined  --return
	--	)
	--	else
	--		menu.getItem(index)
	--),

	/** Set menu
	 */
	function _setMenu =
	(
		--format "\n"; print "Menu_v._setMenu()"
		if this.menu == undefined then
			this.menu = this._getOrCreateMenu(this.name)

		if this.menu != undefined  and this.name == undefined then
			this.name = this.menu.getTitle()
	),


	/** Add separator behind item of given index
	  *
	  * @param integer index of item before separator E.G.: index:3 place separator behind 3. item in menu
	  */
	function _addSeparator index =
	(
		--format "\n"; print "Menu_v._addSeparator()"
		if (items_count = menu.numItems()) > 0 then-- if menus has some items
		(
			add_on_end_of_menu = index == unsupplied or index > items_count 
			
			--format "items_count:	% \n" (items_count)
			--format "index:	% \n" index
			--format "add_on_end_of_menu:	% \n" add_on_end_of_menu
			
			if index != unsupplied and index > items_count then
				FORMAT "\n\n----------- WARNING ----------------------\n\nSEPARATOR IS ADDED ON END OF MENU\n\n\tMenu: \"%\"\n\tindex: % \n\titems in menu: %\n\n" this.name index (items_count)
			
			if add_on_end_of_menu then
				index = items_count
			
			--this._isSeparator( if add_on_end_of_menu then items_count else index  )
			
			menu.addItem (menuMan.createSeparatorItem()) (index +1 )
			
		)
	),

	/** Is separator
	 */
	function _isSeparator index =
	(
		--format "\n"; print "Menu_v._isSeparator()"
		(menu.getItem(index)).getIsSeparator()
	),

	/** Get menu items
	 */
	function _getMenuItems =
	(
		--format "\n"; print "Menu_v._getMenuItems()"
		for i = 1 to menu.numItems() collect menu.getItem(i)
	),

	/** Set menu
	 */
	function _getOrCreateMenu menu_name =
	(
		--format "\n"; print "Menu_v._getOrCreateMenu()"
		local menu

		if (menu = menuMan.findMenu menu_name) == undefined then
			menu = this._createNewMenu (menu_name)
		
		menu --return
	),
	
	/** Create new menu
	 */
	function _createNewMenu menu_name =
	(
		--format "\n"; print "Menu_v._createNewMenu()"
		format "NEW MENU CREATED: \"%\" -- Menu_v._createNewMenu()\n\n" menu_name
		
		menuMan.createMenu menu_name --return
	),

	/** Set title to item
	 */
	function _setTitleToItem &item title =
	(
		--format "\n"; print "Menu_v._setTitleToItem()"
		--format "item	= % \n" item
		--format "title	= % \n" title

		--title = toUpper title

		item.setTitle title


		item.setUseCustomTitle true

		item --return
	),


	/** Sort, make unique and reverse array
	 */
	function _reverseArray arr =
	(
		--print("Menu_v._reverseArray()")
		--format "arr = % \n" arr
		arr = makeUniqueArray ( sort arr)

		for i = arr.count to 1 by -1 collect arr[i]
	),


	/**
	 */
	on create do
	(
		--print("Menu_v.onCreate()")
		--format "this.name = % \n" this.name

		this._setMenu()
	)

)