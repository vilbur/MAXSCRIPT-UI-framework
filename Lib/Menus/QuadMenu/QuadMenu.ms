filein( getFilenamePath(getSourceFileName()) + "/Quad/Quad.ms" )

/** Quad menu
  
  https://forums.cgsociety.org/t/mxs-adding-custom-item-to-convert-to-quad_menu-menu/1870495
  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-6E21C768-7256-4500-AB1F-B144F492F055
 */
struct QuadMenu_v
(	
	/* construct */
	name,
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	quad_menu,
	Quads	= #(),
	
	macroscripts = #(),
	--quad_names = #("quad1", "quad2", "quad3", "quad4"), -- names of sections
	
	/** Create
	 */
	function create =
	(
		format "\n"; print "Menu_v.create()"
		--format "menu	= % \n" menu
		if quad_menu != undefined then
			return this
			
		quad_menu = menuMan.createQuadMenu name (name+"_"+1 as string )(name+"_"+2 as string )(name+"_"+3 as string )(name+"_"+4 as string )
		
		this._setQuads()
		
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
	
	/** Create quad_menu menu
	  * 
	  * @return	this	 
	 */
	function _setQuads =
	(
		--format "\n"; print "QuadMenu_v._setQuad()"
		----format "name	= % \n" name
		if quad_menu != undefined then
			for i = 1 to 4 do
				append Quads (Quad_v menu:(quad_menu.getMenu(i)) QuadMenu:this)
	),
	
	--/** Add menu
	-- */
	--function addMenu menu_name quad_index =
	--(
	--	format "\n"; print "QuadMenu_v.addMenu()"
	--
	--	menu = quad_menu.getMenu quad_index
	--	
	--	if this._menuExists(menu_name) == false then
	--		menu = this._createMenu(menu_name)
	--	
	--	
	--	format "MENU_EXISTS	= % \n" menu_exists
	--	if( (menu_item = this.getItem menu menu_name) == undefined ) then 
	--	(
	--		menu_item = menuMan.createSubMenuItem menu_name menu
	--		
	--		menu_item.setDisplayFlat(true)
	--	
	--		menu.addItem menu_item 1
	--	)
	--		
	--),
	--
	--/*------------------------------------------------------------------------------
	--	CONTEXT MENU
	----------------------------------------------------------------------------------*/


	-- 
	--
	--/** Get or _setQuad new context menu
	-- */
	--function getMenu menu_name =
	--(
	--	--format "\n"; print "QuadMenu_v.getMenu()"
	--	--format "menu_name	= % \n" menu_name
	--
	--	--if( menu_name != undefined and ( menu = menuMan.findMenu menu_name ) == undefined ) then
	--	--(
	--	--	print "create new menu"
	--	--	
	--	--	menu = menuMan.createMenu menu_name
	--	--)
	--	--format "menu	= % \n" menu
	--	menu --return 
	--),
	
	
	
	
	
	
	/** Show all quad_names
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
	),
	
	/** Reset right click
	 */
	function resetRightClick =
	(
		----format "\n"; print "QuadMenu_v.resetRightClick()"
		this.setRightClick("Default Viewport Quad")	which:#nonePressed
		
		this.setRightClick("Modeling 1 [Cntrl+RMB]")	which:#controlPressed
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
	
	private
	
	/** Load macroscripts
	 */
	function _loadMacroscripts =
	(
		format "\n"; print "QuadMenu_v.loadMacroscripts()"
		
		myStringStream = stringStream ""
		macros.list to:myStringStream
		
		seek myStringStream 0

		/*
			!!!! ADD TO KOMODO SNIPPETS: 		while not eof myStringStream do
		*/ 
		while not eof myStringStream do
			append macroscripts (readLine myStringStream)
		format "macroscripts	= % \n" macroscripts
		--format "readvalue myStringStream	= % \n" (readLine myStringStream)
	),
	
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
		
		this._setQuads()
		
		this._loadMacroscripts()
	)
	
)
