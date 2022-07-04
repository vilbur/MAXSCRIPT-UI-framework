filein( getFilenamePath(getSourceFileName()) + "/../Menu/Menu.ms" )

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
	
	--/** Create
	-- */
	--function create =
	--(
	--	format "\n"; print "Menu_v.create()"
	--	--format "menu	= % \n" menu
	--	if quad_menu != undefined then
	--		return this
	--		
	--	quad_menu = menuMan.createQuadMenu name (name+"_"+1 as string )(name+"_"+2 as string )(name+"_"+3 as string )(name+"_"+4 as string )
	--	
	--	this._setQuads()
	--	
	--	this --return
	--),
		
	/** Create quad_menu menu
	  * 
	  * @return	this	 
	 */
	function _setQuad =
	(
		--format "\n"; print "QuadMenu_v._setQuad()"
		----format "name	= % \n" name
		if (quad_menu = menuMan.findQuadMenu this.name) == undefined then 
			quad_menu = menuMan.createQuadMenu this.name (this.name+"_"+1 as string )(this.name+"_"+2 as string )(this.name+"_"+3 as string )(this.name+"_"+4 as string )
			
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
				append Quads (Menu_v menu:(quad_menu.getMenu(i)))
	),
	
	/** Add menu
	 */
	function addMenu menu_name quad_index =
	(
		format "\n"; print "QuadMenu_v.addMenu()"
		Quads[quad_index].addMenu (menu_name)
	),

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
	

	
	private


	/**  
	 */
	on create do
	(
		--print("QuadMenu_v.onCreate()")
		--ConstructPropeties test:this
		this._setQuad()
		
		this._setQuads()
		
		--this._loadMacroscripts()
	)
	
)
