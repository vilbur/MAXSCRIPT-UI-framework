/**  
  *	
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
	 */
	function addItem category macro_script_name title: =
	(
		format "\n"; print "Menu_v.addItem()"
		format "title	= % \n" title
		item = menuMan.createActionItem (macro_script_name) (category)
		
		if( title != unsupplied ) then 
			this._setTitle(item)(title)
		else
			title = item.getTitle()
		
		exists = this._itemExists(title)
		--format "exists	= % \n" exists
		if not this._itemExists(title) then
			menu.addItem item (menu.numItems() +1)
	),
	
	/** Add quad from 'menus' to quad
	  *
	  * return Menu_v
	 */
	function addMenu menu_name flat:false =
	(
		--format "\n"; print "Menu_v.addMenu()"
		submenu = this._getMenu(menu_name)

		if not this._itemExists(menu_name) then
		(
			menu_item = menuMan.createSubMenuItem (menu_name) (submenu)
			
			if flat then 
				menu_item.setDisplayFlat(true)
			
			menu.addItem menu_item (menu.numItems() +1)
		)
		Menu_v menu:submenu --return
	),
	
	/** Add separator
	 */
	function addSeparator =
	(
		--format "\n"; print "Menu_v.addSeparator()"
		menu.addItem (menuMan.createSeparatorItem()) (menu.numItems() +1)
	),
	
	/** Set title
	 */
	function setTitle title =
	(
		--format "\n"; print "Menu_v.setTitle()"
		menu.setTitle title
	),
	
	private
	
	
	/** Get existing item from menu
	 */
	function _itemExists title =
	(
		--format "\n"; print "Menu_v._itemExists()"
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
	function _getMenu menu_name =
	(
		--format "\n"; print "Menu_v._getMenu()"
		--format "menu_name	= % \n" menu_name
		--if( this.name != undefined  and ( menu = menuMan.findMenu this.name ) == undefined ) then
		local menu
		
		if (menu = menuMan.findMenu menu_name) == undefined then 
			menu = menuMan.createMenu menu_name
			
		menu --return
	),
		
	/** Set title
	 */
	function _setTitle &item title =
	(
		format "\n"; print "Menu_v._setTitle()"
		format "item	= % \n" item
		format "title	= % \n" title
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
			menu = this._getMenu(this.name)
	)
)