/** Quad menu
  
  https://forums.cgsociety.org/t/mxs-adding-custom-item-to-convert-to-quad-menu/1870495
  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-6E21C768-7256-4500-AB1F-B144F492F055
 */
struct QuadMenu_v
(
	--__construct = #( #property_name ),
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	

	/** Add menu item
	 */
	function addItem menu_name macro_script_name category title: =
	(
		--format "\n"; print "QuadMenuCreator_v.addItem()"
		menu = this.getMenu (menu_name)
		--format "menu	= % \n" menu
		--format "item	= % \n" item
		if( (item = this.getItem(menu)(title)) == undefined ) then
		(
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
		
		menu_item_found = for menu_item in menu_items where menu_item.getTitle() == item_title collect menu_item
		--format "menu_item_found	= % \n" menu_item_found
		menu_item_found[1] --return
	),
	 
	
	
	/** Get or create new context menu
	 */
	function getMenu _name =
	(
		--format "\n"; print "QuadMenu_v.getMenu()"
		--format "_name	= % \n" _name

		if( (menu = menuMan.findMenu(_name) ) == undefined ) then
			menu = menuMan.createMenu _name
			
		menu --return 
	),
	
	
	private
	
	
	
	/**  
	 */
	on create do
	(
		--print("QuadMenu_v.onCreate()")
		--ConstructPropeties test:this
	)
	
)
