/**  
  *	HELP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3
  */
struct Menu_v
(	
	/* construct */
	name,
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	menu,
	
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

		item = if( group == unsupplied ) then menuMan.createActionItem (macro_script_name) (category) else menuMan.createMenuItemFromAction (group) (macro_script_name) category:(category)
		
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
	  *
	  * return Menu_v
	 */
	function addMenu menu_name flat:false =
	(
		--format "\n"; print "Menu_v.addMenu()"
		submenu = this._getOrCreateMenu(menu_name)

		if this.getItem(menu_name) == undefined then
		(
			menu_item = menuMan.createSubMenuItem (menu_name) (submenu)
			
			if flat then 
				menu_item.setDisplayFlat(true)
			
			menu.addItem menu_item (menu.numItems() +1)
		)
		Menu_v menu:submenu --return
	),
	
	/** Remove given item or by title
	  *
	  * @param	<MixinInterface:menuItem>|string	menu_item	menu item or item title
	  *
	 */
	function removeItem menu_item =
	(
		--format "\n"; print "Menu_v.removeItem()"
		
		if classOf menu_item == string then
			menu_item = this.getItem(menu_item)
		
		if menu_item != undefined then 
			menu.removeItem menu_item 
	),
	
	/** Add separator
	 */
	function addSeparator =
	(
		--format "\n"; print "Menu_v.addSeparator()"
		menu.addItem (menuMan.createSeparatorItem()) (menu.numItems() +1)
	),
	
	/** Get existing item from menu
	  *
	  *
	  * @return	<MixinInterface:menuItem>|undefined
	 */
	function getItem title =
	(
		--format "\n"; print "Menu_v.getItem()"
		menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)

		menu_item_found = for menu_item in menu_items where menu_item.getTitle() == title collect menu_item

		menu_item_found[1] --return
	),
	
	/** Set title
	 */
	function setTitle title =
	(
		--format "\n"; print "Menu_v.setTitle()"
		menu.setTitle title
	),
	
	private
	
	
	/** DEPRECATED 
	 */
	function _itemExists title =
	(
		format "\n"; print "Menu_v._itemExists() DEPRECATED: use Menu_v.getItem() instead "
		--format "menu	= % \n" menu
		--format "title	= % \n" title
		menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)
		--format "menu_items	= % \n" menu_items
		
		for menu_item in menu_items do
		(
			--format "menu_item.getTitle()	= % \n" (menu_item.getTitle())
		)
		menu_item_found = for menu_item in menu_items where menu_item.getTitle() == title collect menu_item
		--format "menu_item_found	= % \n" menu_item_found
		menu_item_found[1] != undefined --return
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
		
	/** Set title
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
		
		if menu == undefined then 
			menu = this._getOrCreateMenu(this.name)
	)
)