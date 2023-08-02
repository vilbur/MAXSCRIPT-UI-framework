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
			return false


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
	  * IMPORTANT: Menu does not show, if does not contain any items
	  *
	  * @param	Menu_V|string|<MixinInterface:menu>	menu_or_name	menu or name of menu which will be added as sub menu
	  * @param	string	title	custom title of menu displayed in quad
	  * @param	boolean	flat	menu will be flat or not
	  *
	  * @return Menu_v
	 */
	function addMenu menu_or_name title: index: flat:this.flat =
	(
		--format "\n"; print "Menu_v.addMenu()"

		if menu_or_name == "" then
			return false

		if classOf menu_or_name == MixinInterface then  -- IF <MixinInterface:menu>
		(
			submenu = menu_or_name

			if title == unsupplied then
				title = menu_or_name.getTitle()
		)
		else if classOf menu_or_name == string then  -- IF "Menu Name" is string
		(
			submenu = this._getOrCreateMenu(menu_or_name)

			if title == unsupplied then
				title = menu_or_name
		)

		else if superClassOf menu_or_name == StructDef then  -- IF Menu_v()
		(
			flat = menu_or_name.flat

			submenu =  menu_or_name.menu

			if title == unsupplied then
				title = menu_or_name.name
		)


		if index == unsupplied then
			index = menu.numItems() + 1


		if this.getItem( title ) == undefined then -- if item with title does not exists yet
		(
			menu_item = menuMan.createSubMenuItem (title) (submenu)

			this._setTitleToItem(menu_item)(title)

			if flat then
				menu_item.setDisplayFlat(true)

			menu.addItem menu_item (index)
		)

		--format "submenu = % \n" submenu

		Menu_v menu:submenu --return
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
			this.addMenu (titles_and_menus[i+1]) title:(titles_and_menus[i])  --index:index

			if separator then
				this.addSeparator()
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
			items_count = this.numItems()

			if index > items_count then
			(
				format "%.getItem(%) -- WARNING - index % is higher then count of items %\n" this.name index index items_count

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
	  * @param	#()|<MixinInterface:menuItem>|string|integer|	index_title_item MenuItem, title string or index of item, can be array of these
	  *
	  * @return	menuItem
	 */
	function removeItem index_title_item =
	(
		--format "\n"; print "Menu_v.removeItem()"

		if classOf index_title_item != Array then
		(
			menu_item = if classOf index_title_item != MixinInterface then this.getItem(index_title_item) else index_title_item

			if menu_item != undefined then
				menu.removeItem menu_item

			menu_item --return

		)
		else
			for single_parameter in this._reverseArray(index_title_item) do
				this.removeItem (single_parameter)


	),

	/** Move item in menu
	  *
	  * @param	integer|-1	index desired position of item, i -1 then item is moved on end of menu
	 */
	function moveItem index_or_title index =
	(
		format "\n"; print "Menu_v.moveItem()"
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
	function cleanSeparators =
	(
		--format "\n"; print "Menu_v.cleanSeparators()"
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

	/** Get menu items
	 */
	function numItems =
	(
		--format "\n"; print "Menu_v._getMenuItems()"
		menu.numItems()
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

	--/** Create empty menu which ca be add as single quad to QUad Menu
	--  *
	--  * Max cannot create <MixinInterface:menu> which is not saved in menus
	--  * In this way new
	-- */
	--function _createEmptyQuad =
	--(
	--	format "\n"; print "Menu_v._createEmptyQuad()"
	--
	--	function quadTitle index = this.name+"-"+index as string --return
	--
	--	temp_menu_file = (GetDir #temp) + "\\temp_menu_save.mnux"
	--
	--	menuMan.saveMenuFile(temp_menu_file)
	--
	--	quad_menu = menuMan.createQuadMenu "X TEMP QUAD" ( quadTitle 1 ) ( quadTitle 2 ) ( quadTitle 3 ) ( quadTitle 4 )
	--
	--	format "quad_menu	= % \n" quad_menu
	--
	--	EMPTY_QUAD =  deepCopy (quad_menu.getMenu(1))
	--
	--	menuMan.loadMenuFile (temp_menu_file)
	--
	--	deleteFile(temp_menu_file)
	--
	--	menu = deepCopy EMPTY_QUAD
	--
	--
	--	menu.setTitle (this.name)
	--
	--	menu--return
	--),

	/**
	  *
	  */
	function _addSeparator index =
	(
		--format "\n"; print "Menu_v._addSeparator()"
		add_on_end_of_menu = index == unsupplied or index > menu.numItems()

		if index != unsupplied and index > (menu.numItems() +1 ) or menu.numItems() == 0 then
			format "\n\n----------- WARNING -----------\nSEPARATOR IS ADDED ON END OF MENU\nMenu: \"%\"\nindex: % \nitems in menu: %\n\n" this.name index (menu.numItems())

		if add_on_end_of_menu then
			index = menu.numItems() +1

		this._isSeparator( if add_on_end_of_menu then menu.numItems() else index  )
			menu.addItem (menuMan.createSeparatorItem()) (index)
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
			menu = menuMan.createMenu menu_name

		--format "menu = % \n" menu
		menu --return
	),


	/** Set title to item
	 */
	function _setTitleToItem &item title =
	(
		--format "\n"; print "Menu_v._setTitleToItem()"
		--format "item	= % \n" item
		--format "title	= % \n" title
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