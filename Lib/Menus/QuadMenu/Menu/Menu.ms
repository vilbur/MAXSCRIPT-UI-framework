/** Wrapper for <MixinInterface:menu>
  *
  *	HELP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3#GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3__GUID-550885E9-1A73-423C-A837-865E96CF7824
  */
struct Menu_v
(	
	/* construct */
	name,
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	menu, -- <MixinInterface:menu> 
	
	
	/** Get menu from menus list HELP:https://help.autodesk.com/view/3DSMAX/2022/ENU/?guid=GUID-F8993D95-943E-4031-B1C6-6B2BADE4DB9E#GUID-F8993D95-943E-4031-B1C6-6B2BADE4DB9E__WS73099CC142F4875546792D6511E39D97277-15A5
	 */
	function getMenu menu_name =
	(
		--format "\n"; print "Menu_v.getMenu()"
		menuMan.findMenu menu_name --return
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

		item = if( group == unsupplied ) then menuMan.createActionItem (macro_script_name) (category) else menuMan.createMenuItemFromAction ( group ) (macro_script_name) category:(category)
		
		if item == undefined then 
			return false
		
		
		/* SET TITLE */ 
		if( title != unsupplied ) then 
			this._setTitleToItem(item)(title)
		else
			title = item.getTitle()
		
		
		/* GET INDEX */ 
		if index == unsupplied then 
			index = menu.numItems() +1
		
		
		/* ADD ITEM TO MENU */ 
		if this.getItem(title) == undefined then
			menu.addItem (item) (index)
			
		item --return
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
		if classOf index_or_title == string then 
		(
			--menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)
			menu_item_found = for item in (this._getMenuItems()) where item.getTitle() == index_or_title collect item
	
			menu_item = menu_item_found[1] --return
		)
		else
			menu_item = menu.getItem(index_or_title) --return
	),


	/** Add quad from 'menus' to quad
	  * IMPORTANT: Menu does not show, if does not contain any items
	  * 
	  * @param	string	menu_name	name of menu which will be added as sub menu
	  * @param	string	title	custom title of menu displayed in quad
	  * @param	boolean	flat	menu will be flat or not
	  * 
	  * @return Menu_v
	 */
	function addMenu menu_name index: title: flat:false =
	(
		--format "\n"; print "Menu_v.addMenu()"
		 if index == unsupplied then
			index = menu.numItems() + 1
		
		submenu = this._getOrCreateMenu(menu_name)
		--format "submenu	= % \n" submenu
		--format "title	= % \n" title
		--format "this.getItem(title)	= % \n" (this.getItem(title))
		--format "this.getItem(menu_name)	= % \n" (this.getItem(menu_name))
		
		if this.getItem( if title == unsupplied then menu_name else title ) == undefined then -- if item with title does not exists yet
		(
			menu_item = menuMan.createSubMenuItem (menu_name) (submenu)
			
			if( title != unsupplied ) then 
				this._setTitleToItem(menu_item)(title)

			if flat then 
				menu_item.setDisplayFlat(true)
			
			menu.addItem menu_item (index)
		)
		
		Menu_v menu:submenu --return
	),
	
	/** Get submenu from menu item
	  *
	  * @return	Menu_v menu:submenu|undefined
	 */
	function getSubMenu index_or_title =
	(
		--format "\n"; print "Menu_v.getSubMenu()"
		if (menuItem = this.getItem index_or_title) != undefined and ( submenu = menuItem.getSubMenu() ) != undefined then
			(Menu_v menu:submenu) --return
	),
	
	/** Remove given item or by title
	  *
	  * @param	<MixinInterface:menuItem>|string|integer	index_title_item MenuItem, title string or index of item
	  *
	  * @return	menuItem	
	 */
	function removeItem index_title_item =
	(
		--format "\n"; print "Menu_v.removeItem()"
		
		menu_item = if classOf index_title_item != MixinInterface then this.getItem(index_title_item) else index_title_item
			
		if menu_item != undefined then 
			menu.removeItem menu_item
			
		menu_item --return
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
	
	/** Add separator
	  *
	  * If separator on this index exists already, then will not be added
	 */
	function addSeparator index: =
	(
		--format "\n"; print "Menu_v.addSeparator()"
		if index == unsupplied then
		(
			index_test	= menu.numItems()
			index	= index_test +1
		)
		else
			index_test = index

		if (menu.getItem(index_test)).getIsSeparator() == false then
			menu.addItem (menuMan.createSeparatorItem()) (index)
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
	
	private
	
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
		--format "menu_name	= % \n" menu_name
		--if( this.name != undefined  and ( menu = menuMan.findMenu this.name ) == undefined ) then
		local menu
		
		if (menu = menuMan.findMenu menu_name) == undefined then 
			menu = menuMan.createMenu menu_name
			
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
	
	/**  
	 */
	on create do
	(
		--print("Menu_v.onCreate()")
		if this.menu == undefined then 
			this.menu = this._getOrCreateMenu(this.name)
		
		if this.menu != undefined  and this.name == undefined then 
			this.name = this.menu.getTitle()
	)
)