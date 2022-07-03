/** Quad menu
  
 */
struct Quad_v
(
	/* construct */
	menu,
	title,
	
	/* dependency */
	QuadMenu,
	
	/* reference */
	/* inhered */
	/* properties */
	
	/** Add menu item
	 */
	function addItem macro_script_name category title: =
	(
		format "\n"; print "QuadMenuCreator_v.addItem()"
		
		if( (item = this.getItem(title)) != undefined ) then
			return false
		
		item = menuMan.createActionItem (macro_script_name) (category)
		
		this._setTitle(item)(title)
		
		menu.addItem item (menu.numItems() +1)
		format "item	= % \n" item

		item --return
	),
	
	private
	
	/** Get existing item from menu
	 */
	function getItem item_title =
	(
		format "\n"; print "QuadMenu_v.getItem()"
		
		menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)

		menu_item_found = for menu_item in menu_items where menu_item.getTitle() == item_title collect menu_item
		format "menu_item_found	= % \n" menu_item_found 
		menu_item_found[1] --return
	),
	
	/** Set title
	 */
	function _setTitle &item title =
	(
		--format "\n"; print "Quad_v._setTiitle()"
		if( title != unsupplied ) then 
		(
			item.setTitle title
			item.setUseCustomTitle true
		)
		item --return
	),
	
	/**  
	 */
	on create do
	(
		--print("Quad_v.onCreate()")
		title = menu.getTitle()
	)
	
)
