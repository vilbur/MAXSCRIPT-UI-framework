/** Wrapper for <MixinInterface:QuadMenu>
  *
  * HELP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3#GUID-1374EDCA-CC8B-4B43-81A5-6ED98DBE01D3__GUID-B997CD35-721D-41F9-B011-304446C3F482
  *
 */
struct QuadMenu_v
(
	/* construct */
	menu_name,
	prefix = "_", -- menu name prefix
	
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	QuadMenu, -- <MixinInterface:QuadMenu>
	Quads	= #(),

	private
	
	macroscripts = #(),
	
	/** Long names of 3Ds Max default quads
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
        "Texture Tools",
		
		"ActiveShade Quad",
		"Unwrap UVW Quad",
		"Schematic View Quad",
		"Track View Quad",
		"Asset Tracking Quad",
		"Retimer Span Type"
			
            --"Track View Key Quad (Classic)",
            --"Trackbar Quad",
            --"Track View Key Quad",

	),
	
	--hotkeys = #( #nonePressed, #RightClick, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),
	hotkeys = #( #nonePressed, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),

	public
	
	/** Add menu
	  *
	  * @param	Menu_V|string|<MixinInterface:menu>	menu_or_name	menu or name added as quad
	  * @param	1|2|3|4|#BOTTOM_LEFT|#BOTTOM_RIGHT|#TOP_LEFT|#TOP_RIGHT	quad_index name or number of quad
	  *
	 */
	function addMenu menu_or_name quad_index =
	(
		--format "\n"; print "QuadMenu_v.addMenu()"
		--format "menu_or_name	= % \n" menu_or_name
		--format "menu_or_name.name	= % \n" menu_or_name.name
		--format "classOf quad_index	= % \n" (classOf quad_index)
		--format "classOf quad_index == name	= % \n" (classOf quad_index == name)

		quad_index = this._getQuadIndex(quad_index)

		Quads[quad_index].addMenu (menu_or_name)

		if superClassOf menu_or_name == StructDef then  -- IF Menu_v()
			Quads[quad_index].setTitle (menu_or_name.name)
			--Quads[quad_index].setTitle menu_or_name.name
	),

	/** Get quad menu
	  *
	  * @param	int	quad_index	of quad menu
	 */
	function getMenu quad_index =
	(
		--format "\n"; print "QuadMenu_v.getQuad()"
		quad_index = this._getQuadIndex(quad_index)

		Quads[quad_index] --return
	),

	/** Show all quad_names
	 */
	function showAllQuads switch:true =
	(
		----format "\n"; print "QuadMenu_v.showAllQuads()"
		menuMan.setShowAllQuads QuadMenu switch

		this --return
	),

	/** Set right click
	  *
	  * @param	name	which	#nonePressed #shiftPressed #altPressed #controlPressed #shiftAndAltPressed #shiftAndControlPressed #controlAndAltPressed #shiftAndAltAndControlPressed
	  *
	 */
	function setRightClick which:#nonePressed  =
	(
		format "\n"; print "QuadMenu_v.setRightClick()"
		format "this.menu_name:	% \n" this.menu_name
		format "QuadMenu: %\n" QuadMenu
		--format "QuadMenu.menu: %\n" QuadMenu.menu
		format "which:	% \n" which
		menuMan.setViewportRightClickMenu which QuadMenu
		
		format "ASSIGN HOTKEY TO QUADMENU: \"%\" HOTKEY: %\n" ( menuMan.getQuadMenuName  QuadMenu ) which
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
	
	/** Set hotkey
	 */
	function setHotkey hotkey =
	(
		--format "\n"; print "QuadMenu_v.setHotkey()"
		--format "menu_name: %\n" menu_name

		if ( hotkey_name = this._getHotkey( hotkey) ) != undefined then
			this.setRightClick which:hotkey_name

		else
			FORMAT "WARNING - TRY TO ASSIGN NOT WALID HOTKEY TO QUAD MENU in file: QuadMenu_v.setHotkey( \"%\" )\n" hotkey
	),


	private


	/** Create QuadMenu menu
	  *
	  * @return	this
	 */
	function _setQuadMenu =
	(
		--format "\n"; print "QuadMenu_v._setQuadMenu()"
		
		full_name = if ( default_quad = this._getDefaultQuadName() ) != undefined then default_quad else this._getFullName()
		--format "FULL_NAME: %\n" full_name

		/* SEARCH QUAD MENU OR CREATE NEW ONE - if menu was not found */ 
		QuadMenu = if (QuadMenu_found = menuMan.findQuadMenu full_name) != undefined then QuadMenu_found else this._createNewQuadMenu()  
		
		this --return
	),
	
	/** Create new quad menu
	 */
	function _createNewQuadMenu =
	(
		--format "\n"; print "QuadMenu_v._createNewQuadMenu()"
		function quadTitle index = this.menu_name + "-" + index as string --return

		full_name = this._getFullName()
		--format "FULL_NAME: %\n" full_name
		FORMAT "\nNEW QUAD MENU CREATED: \"%\" -- QuadMenu_v._createNewQuadMenu()\n\n" full_name
		
		menuMan.createQuadMenu (full_name) ( quadTitle 1 ) ( quadTitle 2 ) ( quadTitle 3 ) ( quadTitle 4 ) --return
	),

	/** Get default 3Ds Max quad menu
	  *
	  * @return string|undefined name of default quad
	 */
	function _getDefaultQuadName =
	(
		--format "\n"; print "QuadMenu_v._getDefaultQuadName()"
		
		default_quad_names =	for default_quad_name in default_quad_names                         \
			where	matchPattern default_quad_name pattern:( this.menu_name )    \  -- match:"Foo"
			or	matchPattern default_quad_name pattern:( this.menu_name + " *") -- match:"Foo .*"
				collect default_quad_name
		
		if default_quad_names.count > 0 then
			default_quad_names[1] --return
	),

	/** Create QuadMenu menu
	  *
	  * @return	this
	 */
	function _setQuads =
	(
		--format "\n"; print "QuadMenu_v._setQuadMenu()"
		if QuadMenu != undefined then
			for i = 1 to 4 do
				append Quads (Menu_v menu:(QuadMenu.getMenu(i)) quad_index:i)
	),

	/** Get quad index
	 */
	function _getQuadIndex quad_index =
	(
		--format "\n"; print "QuadMenu_v._getQuadIndex()"
		case quad_index of
			(
				#BOTTOM_LEFT:  4
				#BOTTOM_RIGHT: 1

				#TOP_LEFT:  3
				#TOP_RIGHT: 2

				default: quad_index
			)
	),
	

	/** Get hotkey from prefix of string
	  * 
	  * E.G.: "RightClick-foobar" >>> #RightClick
	  * 
	  * @return name|undefined
	 */
	function _getHotkey hotkey_source =
	(
		--format "\n"; print "QuadMenuManager_v._getHotkey()"
		--format "hotkey_source: %\n" hotkey_source
		
		if ( findItem hotkeys ( hotkey_source as name ) ) == 0 then
		(
			hotkey_source = hotkey_source as string 
			
			delimeters = "_- "
			
			prefix = (filterString hotkey_source delimeters)[1]
			--format "prefix: %\n" prefix
			hotkey = ( trimLeft prefix delimeters ) 
			--format "hotkey: %\n" hotkey
			
			
			if not matchPattern hotkey pattern:"RightClick" then
			(
				if not matchPattern ( hotkey ) pattern:( "*Pressed") then
					hotkey = ( hotkey + "Pressed" ) -- add suffix "Pressed"
				--format "hotkey: %\n" hotkey
				--format "index: %\n" (findItem hotkeys hotkey)
				
				hotkey = hotkey as name 
				
				if ( index = findItem hotkeys hotkey ) > 0 then
					hotkey --return
			)
			else /* RIGHTCLICK */ 
				#nonePressed  --return
			
		)
		else
			hotkey_source as name  --return
	),
	
	/** Get full name
	 */
	function _getFullName =
	(
		--format "\n"; print "QuadMenu_v._getFullName()"
		
		if not matchPattern menu_name pattern:( prefix + "*")ignoreCase:false then
			prefix + menu_name --return
		
		else
			menu_name --return
	),
	--/** Get hotkey by name
	-- */
	--function _getHotkeyByQuadName =
	--(
	--	format "\n"; print "QuadMenu_v._getHotkeyByQuadName()"
	--	hotkey = this._getHotkey(this.menu_name)
	--	
	--	if ( index = findItem hotkeys hotkey ) > 0 then
	--		hotkeys[index] --return
	--),
		
	/**
	 */
	on create do
	(
		--print("QuadMenu_v.onCreate()")
		--format "this.menu_name = % \n" this.menu_name

		this._setQuadMenu()

		this._setQuads()

		this.showAllQuads()
		
		--LAST_CREATED_QUAD = QuadMenu

		--this._getHotkeyByQuadName()
		
		--if ( hotkey = this._getHotkeyByQuadName() ) != undefined then 
		if ( hotkey = this._getHotkey(this.menu_name) ) != undefined then 
			this.setHotkey (hotkey)
	)
	
)