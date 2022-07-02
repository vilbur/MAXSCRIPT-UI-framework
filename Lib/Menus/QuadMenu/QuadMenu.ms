/** Quad menu
  
  https://forums.cgsociety.org/t/mxs-adding-custom-item-to-convert-to-quad_menu-menu/1870495
  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-6E21C768-7256-4500-AB1F-B144F492F055
 */
struct QuadMenu_v
(
	--__construct = #( #property_name ),
	
	/* construct */
	name,
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	quad_menu,
	quads = #("quad1", "quad2", "quad3", "quad4"), -- names of sections
	
	/** Create
	 */
	function create =
	(
		format "\n"; print "Menu_v.create()"
		format "menu	= % \n" menu
		if menu == undefined then 
			quad_menu = menuMan.createQuadMenu name quads[1] quads[2] quads[3] quads[4]
		
		this --return
	),
		
	/** Create quad_menu menu
	  * 
	  * @return	this	 
	 */
	function _setQuad =
	(
		--format "\n"; print "QuadMenu_v._setQuad()"
		----format "name	= % \n" name
		if this.name != undefined then 
			quad_menu = menuMan.findQuadMenu this.name
		
		this --return
	),
	
	/** Add menu
	 */
	function addMenu menu_name quad_index =
	(
		format "\n"; print "QuadMenu_v.addMenu()"

		menu = quad_menu.getMenu quad_index
		
		if this._menuExists(menu_name) == false then
			menu = this._createMenu(menu_name)
		
		
		format "MENU_EXISTS	= % \n" menu_exists
		if( (menu_item = this.getItem menu menu_name) == undefined ) then 
		(
			menu_item = menuMan.createSubMenuItem menu_name menu
			
			menu_item.setDisplayFlat(true)
		
			menu.addItem menu_item 1
		)
			
	),

	/** Get or _setQuad new context menu
	 */
	function getQuadMenu menu_name =
	(
		--format "\n"; print "QuadMenu_v.getMenu()"
		--format "menu_name	= % \n" menu_name

		
	),
	
	
	
	
	
	/*------------------------------------------------------------------------------
		CONTEXT MENU
	--------------------------------------------------------------------------------*/
	
	
	
	/** Add menu item
	 */
	function addItem menu_name macro_script_name category title: =
	(
		--format "\n"; print "QuadMenuCreator_v.addItem()"
		--format "title	= % \n" title 
		menu = this.getMenu (menu_name)
		--format "menu	= % \n" menu
		
		if( (item = this.getItem(menu)(title)) == undefined ) then
		(
			--format "CREATE ITEM	= % \n" item
			
			item = menuMan.createActionItem (macro_script_name) (category)
		
			menu.addItem item (menu.numItems() +1)
		)
		--format "item	= % \n" item
		menu --return
	),
	
	/** Get existing item from menu
	 */
	function getItem menu item_title =
	(
		format "\n"; print "QuadMenu_v.getItem()"
		--format "menu	= % \n" menu
		--format "menu.numItems()	= % \n" (menu.numItems())
		--format "menu	= % \nitem_title	= % \n\n" menu item_title
		
		menu_items = for i = 1 to menu.numItems() collect menu.getItem(i)
		--format "menu_items	= % \n" menu_items
		menu_item_found = for menu_item in menu_items where menu_item.getTitle() == item_title collect menu_item
		--format "menu_item_found	= % \n" menu_item_found
		menu_item_found[1] --return
	),
	 

	/** Get or _setQuad new context menu
	 */
	function getMenu menu_name =
	(
		--format "\n"; print "QuadMenu_v.getMenu()"
		--format "menu_name	= % \n" menu_name

		--if( menu_name != undefined and ( menu = menuMan.findMenu menu_name ) == undefined ) then
		--(
		--	print "create new menu"
		--	
		--	menu = menuMan.createMenu menu_name
		--)
		--format "menu	= % \n" menu
		menu --return 
	),
	
	
	
	
	
	
	/** Show all quads
	 */
	function showAllQuads switch:true =
	(
		----format "\n"; print "QuadMenu_v.showAllQuads()"
		menuMan.setShowAllQuads quad_menu switch

		this --return
	),
	
	/** Set right click
	  *
	  * @param	name	which	#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed
	  *
	 */
	function setRightClick which:#nonePressed  =
	(
		--format "\n"; print "QuadMenu_v.setRightClick()"
		--format "quad_menu	= % \n" quad_menu
		menuMan.setViewportRightClickMenu which quad_menu
		
		this --return
	),
	
	/** Reset right click
	 */
	function resetRightClick =
	(
		----format "\n"; print "QuadMenu_v.resetRightClick()"
		this.setRightClick("Default Viewport Quad")	which:#nonePressed
		
		this.setRightClick("Modeling 1 [Cntrl+RMB]")	which:#controlPressed
		
		this --return
	),
	
	/** Set flat
	 */
	function setFlat menu_name =
	(
		--format "\n"; print "QuadMenu_v.setFlat()"
		Menu = this.getMenu(menu_name)
		--format "Menu	= % \n" Menu
		--Menu.setDisplayFlat(true)
		menu_item = getItem Menu menu_name
		
		--format "menu_name	= % \n" menu_name
		
		this --return
	),
	
	
	private
	
	/** Menu exists
	 */
	function _menuExists menu_name =
	(
		--format "\n"; print "QuadMenu_v._menuExists()"
		 menuMan.findMenu menu_name != undefined
	),
	
	/** Create
	 */
	function _createMenu menu_name =
	(
		--format "\n"; print "QuadMenu_v.create()"
		menuMan.createMenu menu_name
	),
	/**  
	 */
	on create do
	(
		--print("QuadMenu_v.onCreate()")
		--ConstructPropeties test:this
		this._setQuad()
		
	)
	
)
