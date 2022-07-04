


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
	
	--/** Create
	-- */
	--function create =
	--(
	--	--format "\n"; print "Menu_v.create()"
	--	this._getMenu()
	--	
	--	--if menu == undefined then 
	--		--menu = menuMan.createMenu this.name
	--	
	--	this --return
	--),
	
	/** Add menu item
	 */
	function addItem category macro_script_name title: =
	(
		--format "\n"; print "Menu_v.addItem()"
		
		item = menuMan.createActionItem (macro_script_name) (category)
		
		--format "item	= % \n" item
		--format "item.getTitle()	= % \n" (item.getTitle())
		--format "menu.getTitle()	= % \n" (menu.getTitle())
		
		if( title != unsupplied ) then 
			this._setTitle(item)(title)
		else
			title = item.getTitle()


		--if( title == unsupplied ) then 
			--title = item.getTitle()
		
		exists = this._itemExists(title)
		--format "exists	= % \n" exists
		if not this._itemExists(title) then
			menu.addItem item (menu.numItems() +1)
	),
	
	
	/** Add quad from 'menus' to quad
	  *
	  * return Menu_v
	 */
	function addMenu menu_name flat:true =
	(
		format "\n"; print "Menu_v.addMenu()"
		--exists = this._itemExists(menu_name)
		--format "exists	= % \n" exists
		format "menu_name	= % \n" menu_name
		format "menu.getTitle()	= % \n" (menu.getTitle())

	
		if not this._itemExists(menu_name) then
		(
			menu_item = menuMan.createSubMenuItem (menu_name) (this._getMenu(menu_name))
			--format "menu	= % \n" menu
			--format "menu_item	= % \n" menu_item
			format "menu.getTitle()	= % \n" (menu.getTitle())
			format "menu_item.getTitle()	= % \n" (menu_item.getTitle())
			
			--if flat then 
				--menu_item.setDisplayFlat(true)
			
			menu.addItem menu_item (menu.numItems() +1)
		)
		
		Menu_v menu:menu --return
	),
	
	
	
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
	
	private
	
	
	/** Set menu
	 */
	function _getMenu menu_name =
	(
		format "\n"; print "Menu_v._getMenu()"
		format "menu_name	= % \n" menu_name
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
		--format "\n"; print "Menu_v._setTiitle()"
		if( title != unsupplied ) then 
		(
			item.setTitle title
			item.setUseCustomTitle true
		)
		item --return	
	),
	
	--/** Set flat
	-- */
	--function setFlat menu_name =
	--(
	--	--format "\n"; print "QuadMenu_v.setFlat()"
	--	Menu = this.getMenu(menu_name)
	--	--format "Menu	= % \n" Menu
	--	--Menu.setDisplayFlat(true)
	--	menu_item = getItem Menu menu_name
	--	
	--	--format "menu_name	= % \n" menu_name
	--	
	--	this --return
	--),
	--
	
	/**  
	 */
	on create do
	(
		--print("Menu_v.onCreate()")
		
		if menu == undefined then 
			menu = this._getMenu(this.name)
	)
	
)
