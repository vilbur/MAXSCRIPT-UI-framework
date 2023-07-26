filein( getFilenamePath(getSourceFileName()) + "/Menu/Menu.ms" ) -- "./Menu/Menu.ms"

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


	/** Default quads
	 */
	default_quad_names =
	#(
		--format "\n"; print "QuadMenu_v.defaultQuads()"
		"Default Viewport Quad",
        "Snap                     [Shift+RMB]",
        "Animation                [Alt+RMB]",
        "Modeling                 [Ctrl+RMB]",
        "MassFX                   [Shift+Alt+RMB]",
        "User Defined 1         [Shift+Ctrl+RMB]",
        "Lighting | Render        [Ctrl+Alt+RMB]",
        "User Defined 2         [Shift+Ctrl+Alt+RMB]",
        "Track View Key Quad (Classic)",
        "Trackbar Quad",
        "Viewports",
        "Track View Key Quad",
        "LayerExplorer Quad",
        "SceneExplorer Quad",
        "Lock",
        "Windows",
        "Texture Tools"
	),


	/** Add menu
	 */
	function addMenu menu_name quad_index =
	(
		--format "\n"; print "QuadMenu_v.addMenu()"
		Quads[quad_index].addMenu (menu_name)
	),

	/** Get quad menu
	  *
	  * @param	int	quad_index	of quad menu
	 */
	function getMenu quad_index =
	(
		--format "\n"; print "QuadMenu_v.getQuad()"
		Quads[quad_index] --return
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
	  *
	  * https://help.autodesk.com/view/MAXDEV/2024/ENU/?guid=GUID-258F6015-6B45-4A87-A7F5-BB091A2AE065
	 */
	function resetRightClick =
	(
		quadmenu = menuMan.findQuadMenu "Default Viewport Quad"
		if quadmenu != undefined do menuMan.setViewportRightClickMenu #nonePressed quadmenu

		quadmenu = menuMan.findQuadMenu "Modeling 1 [Cntrl+RMB]"
		if quadmenu != undefined do menuMan.setViewportRightClickMenu #controlPressed quadmenu
	),


	private


	/** Create quadMenu menu
	  *
	  * @return	this
	 */
	function _setQuad =
	(
		--format "\n"; print "QuadMenu_v._setQuad()"
		if ( found_default_quad = this._getDefaultQuad() ) != undefined then
			this.name = found_default_quad

		if (quadMenu = menuMan.findQuadMenu this.name) == undefined then
			quadMenu = menuMan.createQuadMenu this.name (this.name+"_"+1 as string )(this.name+"_"+2 as string )(this.name+"_"+3 as string )(this.name+"_"+4 as string )

		this --return
	),

	/** Get default 3Ds Max quad menu
	 */
	function _getDefaultQuad =
	(
		--format "\n"; print "QuadMenu_v.getDefaultQuad()"
		found_default_quad = for default_quad_name in default_quad_names where matchPattern default_quad_name pattern:( this.name + "*") collect default_quad_name

		if found_default_quad.count > 0 then
			found_default_quad[1] --return
	),

	/** Create quadMenu menu
	  *
	  * @return	this
	 */
	function _setQuads =
	(
		--format "\n"; print "QuadMenu_v._setQuad()"
		if quadMenu != undefined then
			for i = 1 to 4 do
				append Quads (Menu_v menu:(quadMenu.getMenu(i)))
	),

	/**
	 */
	on create do
	(
		--print("QuadMenu_v.onCreate()")
		--format "this.name = % \n" this.name

		this._setQuad()

		this.showAllQuads()

		this._setQuads()
	)
)