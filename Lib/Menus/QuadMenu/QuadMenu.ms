filein( getFilenamePath(getSourceFileName()) + "/Menu/Menu.ms" )

/** Wrapper for <MixinInterface:quadMenu>
  *
  * HELP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3#GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3__GUID-B997CD35-721D-41F9-B011-304446C3F482
  *
 */
struct QuadMenu_v
(	
	/* construct */
	name,
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	quadMenu, -- <MixinInterface:quadMenu> 
	Quads	= #(),
	
	macroscripts = #(),	

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
		menuMan.setShowAllQuads quadMenu switch

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
		menuMan.setViewportRightClickMenu which quadMenu
	),
	
	/** Reset right click to default
	  * 
	  * Quad Menu "Default Viewport Quad" is set to right click
	 */
	function resetRightClick =
	(
		----format "\n"; print "QuadMenu_v.resetRightClick()"
		this.setRightClick("Default Viewport Quad")	which:#nonePressed
		
		this.setRightClick("Modeling 1 [Cntrl+RMB]")	which:#controlPressed
	),
	
	
	private


	/** Create quadMenu menu
	  * 
	  * @return	this	 
	 */
	function _setQuad =
	(
		--format "\n"; print "QuadMenu_v._setQuad()"
		----format "name	= % \n" name
		if (quadMenu = menuMan.findQuadMenu this.name) == undefined then 
			quadMenu = menuMan.createQuadMenu this.name (this.name+"_"+1 as string )(this.name+"_"+2 as string )(this.name+"_"+3 as string )(this.name+"_"+4 as string )
			
		this --return
	),
	
	/** Create quadMenu menu
	  * 
	  * @return	this	 
	 */
	function _setQuads =
	(
		--format "\n"; print "QuadMenu_v._setQuad()"
		----format "name	= % \n" name
		if quadMenu != undefined then
			for i = 1 to 4 do
				append Quads (Menu_v menu:(quadMenu.getMenu(i)))
	),
	
	/**  
	 */
	on create do
	(
		--print("QuadMenu_v.onCreate()")
		this._setQuad()
		
		this._setQuads()
	)
)