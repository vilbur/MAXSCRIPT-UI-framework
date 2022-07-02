



struct Menu_v
(
	--__construct = #( #property_name ),
	
	/* construct */
	name,
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	menu,
	
	
	/** Add menu item
	 */
	function addItem menu_name macro_script_name category title: =
	(
		--format "\n"; print "QuadMenuCreator_v.addItem()"
		--format "title	= % \n" title 

		
		if( (item = this.getItem(menu)(title)) == undefined ) then
		(
			format "CREATE ITEM	= % \n" item
			
			item = menuMan.createActionItem (macro_script_name) (category)
		
			menu.addItem item (menu.numItems() +1)
		)
	),
	
	/** Get existing item from menu
	 */
	function getItem menu item_title =
	(
		--format "\n"; print "QuadMenu_v.getItem()"
		--format "menu	= % \nitem_title	= % \n\n" menu item_title
		
		menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)
		--format "menu_items	= % \n" menu_items
		menu_item_found = for menu_item in menu_items where menu_item.getTitle() == item_title collect menu_item
		--format "menu_item_found	= % \n" menu_item_found
		menu_item_found[1] --return
	),
	
	private
	
	
	/** Set menu
	 */
	function _setMenu =
	(
		format "\n"; print "Menu_v._setMenu()"
		if( this.name != undefined  and ( menu = menuMan.findMenu this.name ) == undefined ) then 
			menu = menuMan.createMenu this.name
	),
		
	/**  
	 */
	on create do
	(
		print("Menu_v.onCreate()")
		--ConstructPropeties test:this
		this._setMenu()
		--format "name	= % \n" name
		--format "test	= % \n" test
	)
	
)
