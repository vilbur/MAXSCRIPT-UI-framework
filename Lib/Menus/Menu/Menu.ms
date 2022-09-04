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
	menu, -- <MixinInterface:menu> HELP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3#mixin-interface-menuman-getmenu-
	
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
	  * @param	string	menu_name	name of menu which will be added as sub menu
	  * @param	string	title	custom title of menu displayed in quad
	  * @param	boolean	flat	menu will be flat or not
	  * 
	  * @return Menu_v
	 */
	function addMenu menu_name title: flat:false =
	(
		--format "\n"; print "Menu_v.addMenu()"
		submenu = this._getOrCreateMenu(menu_name)
		--format "submenu	= % \n" submenu
		--format "title	= % \n" title
		
		if this.getItem(menu_name) == undefined then -- search for menu in quad
		(
			submenu = menuMan.createSubMenuItem (menu_name) (submenu)
			--format "add submenu	= % \n" submenu
			
			if title != unsupplied then
			(
				submenu.setUseCustomTitle(true)
				
				submenu.setTitle(title)
			)
			--format "submenu.getUseCustomTitle() = % \n" (submenu.getUseCustomTitle() )
			if flat then 
				submenu.setDisplayFlat(true)
			
			menu.addItem submenu (menu.numItems() +1)
		)
		
		Menu_v menu:submenu --return
	),
	
	/** Remove given item or by title
	  *
	  * @param	<MixinInterface:menuItem>|string|integer	menu_item|title|index
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
	
	/** Get existing item from menu
	  *
	  * @param	string|integer	title|index
	  
	  * @return	<MixinInterface:menuItem>|undefined
	 */
	function getItem menu_item =
	(
		--format "\n"; print "Menu_v.getItem()"
		if classOf menu_item == string then 
		(
			menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)
	
			menu_item_found = for item in menu_items where item.getTitle() == menu_item collect item
	
			menu_item_found[1] --return
		)
		else
			menu.getItem(menu_item) --return
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
		
		if this.menu == undefined then 
			this.menu = this._getOrCreateMenu(this.name)
		
		if this.menu != undefined  and this.name == undefined then 
			this.name = this.menu.getTitle()
	)
)