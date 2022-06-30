/** Quad menu
  
  https://forums.cgsociety.org/t/mxs-adding-custom-item-to-convert-to-quad-menu/1870495
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
	quad,
	quads = #("quad1", "quad2", "quad3", "quad4"), -- names of sections
	
	/** Create quad menu
	  * 
	  * @return	this	 
	 */
	function setQuad =
	(
		--format "\n"; print "QuadMenu_v.setQuad()"
		----format "name	= % \n" name
		if( name != undefined and ( quad = menuMan.findQuadMenu name ) == undefined ) then 
			quad = menuMan.createQuadMenu name quads[1] quads[2] quads[3] quads[4]
		
		----format "quad	= % \n" quad
		this --return
	),
	
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
			--format "item	= % \n" item
			
			item = menuMan.createActionItem (macro_script_name) (category)
		
			menu.addItem item (menu.numItems() +1)
		)
		
		menu --return
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
	 

	/** Get or setQuad new context menu
	 */
	function getMenu menu_name =
	(
		--format "\n"; print "QuadMenu_v.getMenu()"
		--format "menu_name	= % \n" menu_name

		if( menu_name != undefined and ( menu = menuMan.findMenu menu_name ) == undefined ) then 
			menu = menuMan.createMenu menu_name
		
		menu --return 
	),
	
	
	/** Show all quads
	 */
	function showAllQuads switch:true =
	(
		----format "\n"; print "QuadMenu_v.showAllQuads()"
		menuMan.setShowAllQuads quad switch

	),
	
	/** Set right click
	  *
	  * @param	name	which	#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed
	  *
	 */
	function setRightClick which:#nonePressed  =
	(
		--format "\n"; print "QuadMenu_v.setRightClick()"
		--format "quad	= % \n" quad
		menuMan.setViewportRightClickMenu which quad
	),
	
	/** Reset right click
	 */
	function resetRightClick =
	(
		----format "\n"; print "QuadMenu_v.resetRightClick()"
		this.setRightClick("Default Viewport Quad")	which:#nonePressed
		
		this.setRightClick("Modeling 1 [Cntrl+RMB]")	which:#controlPressed
	),
	
	private
	
	
	
	/**  
	 */
	on setQuad do
	(
		--print("QuadMenu_v.onCreate()")
		--ConstructPropeties test:this
		this.setQuad()
		
	)
	
)
