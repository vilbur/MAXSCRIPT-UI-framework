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
			--format "add submenu	= % \n" submenu
			
			if( title != unsupplied ) then 
				this._setTitleToItem(menu_item)(title)

			if flat then 
				menu_item.setDisplayFlat(true)
			
			menu.addItem menu_item (index)
		)
		
		Menu_v menu:submenu --return
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
			menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)
	
			menu_item_found = for item in menu_items where item.getTitle() == index_or_title collect item
	
			menu_item = menu_item_found[1] --return
		)
		else
			menu_item = menu.getItem(index_or_title) --return
	),
	
	/** Get submenu from menu item
	  *
	  * Return:
	  *		1) Return menuItem 
	  * 		2) Return Menu_v with submenu if menu item is submenu
	  *		3) Return undefined if item with goven title or index does not exist
	  *
	  * @return	<MixinInterface:menuItem>|Menu_v menu:submenu|undefined
	 */
	function getSubMenu index_or_title =
	(
		--format "\n"; print "Menu_v.getSubMenu()"
		menuItem = this.getItem index_or_title 
		
		if menuItem != undefined then
		(
			if( submenu = menuItem.getSubMenu() ) != undefined then
				(Menu_v menu:submenu) --return
			else
				menuItem --return <MixinInterface:menuItem>
		)
	),
	
	/** Remove given item or by title
	  *
	  * @param	<MixinInterface:menuItem>|string|integer	index_or_title|title|index
	  *
	  * @return	menuItem	
	 */
	function removeItem index_or_title =
	(
		--format "\n"; print "Menu_v.removeItem()"
		if classOf index_or_title == string then
			menu_item = this.getItem(index_or_title)

		if menu_item != undefined then 
			menu.removeItem menu_item
			
		menu_item --return
	),
	
	/** Move item in menu
	 */
	function moveItem menu_item index =
	(
		--format "\n"; print "Menu_v.moveItem()"
		menu_item = this.removeItem (menu_item)
		
		if menu_item != undefined then 
			menu.addItem (menu_item) (index)
	),
	
	/** Add separator
	  *
	  * If separator on this index exists already, then will not be added
	 */
	function addSeparator index: =
	(
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
	
	/** Set title to menu
	 */
	function setTitle title =
	(
		--format "\n"; print "Menu_v.setTitle()"
		menu.setTitle title
	),

	
	private


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