------global LAST_CREATED_QUAD


/** Quad menu manager
 */
struct QuadMenuManager_v
(
	/* construct */

	/* required */

	/* properties */
	hotkeys = #( #RightClick, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),

	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	
	/** Setup menus by config files in dir
	  * 
	  * NOTE: hotkey of DEFAULT QUAD is set to CTRL+SHIFT+AL+RMB
	  * 
	 */
	function setupMenus dir =
	(
		--format "\n"; print "QuadMenuManager_v.setupMenus()"
		--this.createMenusFromMacroscriptFiles()
		
		/* ISNTALL QUAD MENUS */ 
		this.setDefaultQuadHotkey(#shiftAndAltAndControlPressed)

		this._fileInSetupFiles( dir  )	--"./../../../QuadMenu/QuadMenus"
		
		this._saveMenusToMaxStartup()
		
		this._reconnectHotkeys()
	),
	
	/** Reset mnus and hotkeys
	 */
	function resetMenusAndHotkeys =
	(
		--format "\n"; print "QuadMenuManager_v.resetMnusAndHotkeys()"
		this._loadDefaultMenuConfig()
			
		this._resetHotkeysOfDefaultQuads()
	),

	/** Import macroscript files to menus
	 */
	function createMenusFromMacroscriptFiles dir blacklist:#() =
	(
		format "\n"; print "QuadMenuManager_v.createMenusFromMacroscriptFiles()"
		format "dir: %\n" dir
		/** Test if path is on blacklist
		 */
		function isOnBlacklist macro_path blacklist = (for pattern in blacklist where matchPattern macro_path pattern:pattern collect pattern).count > 0
		--format "dir: %\n" dir
		all_macro_files = getFiles ( dir + "/*.mcr" ) recurse:true  -- "./../../slot_properties.ini"
		format "ALL_MACRO_FILES: %\n" all_macro_files
		for macro_path in all_macro_files where not isOnBlacklist macro_path blacklist do
			try
			(
				--format "CREATE MENUS FROM FILE: %\n" (filenameFromPath(macro_path))
				
				(ScriptFile_Content_v(macro_path)).importMacroscriptsToMenus()
			)
			catch
				format "!!!!! FILEIN *.mcr file ERROR\n\n%\n\n" (getCurrentException())
	),
	
	/** Set default quad hotkey to CTRL+SHIFT+AL+RMB
	 */
	function setDefaultQuadHotkey which =
	(
		--format "\n"; print "QuadMenuManager_v.setDefaultQuadHotkey()"
		if ( quadmenu_default = menuMan.findQuadMenu "Default Viewport Quad" ) != undefined do
			menuMan.setViewportRightClickMenu which quadmenu_default
	),
	
	
	private
	
	/** Import modify files of quad names
	  * Each quad should has its own file
	  *
	  *
	  * HOTKEY of quad is assignend by filename if prefix match one of this.hotkeys
	  *
	  *		E.G.: "-RightClick-Config-Quad.mcr" >>> hotkey is #RIGHTCLICK
	  *
	 */
	function _fileInSetupFiles dir =
	(
		format "\n"; print "QuadMenuManager_v._fileInSetupFiles()"
		
		for menu_file in getFiles ( dir + "\\*.ms") do
		(
			menu_file = pathConfig.normalizePath menu_file

			format "\n\n============================== SETUP QUAD MENU FILE ==========================================\n%\n" menu_file
		
			filein( menu_file )
			
			--format "LAST_CREATED_QUAD: %\n" (LAST_CREATED_QUAD)
			
			--this._setHotkeyByFilename(getFilenameFile(menu_file))
			
		)
	),
	
	/** Set menus to max start
	 */
	function _saveMenusToMaxStartup =
	(
		--format "\n"; print "QuadMenuManager_v._saveMenusToMaxStartup()"
		menuMan.saveMenuFile ((getDir #ui)+"\\MaxStartUI.mnux") --"./../../../../../en-US/UI/MaxStartUI.mnux"
	),
	
	/** Load default menu config
	 */
	function _loadDefaultMenuConfig =
	(
		--format "\n"; print "QuadMenuManager_v.loadDefaultMenuNfig()"
		/* LAOD 3DS MAX DEFAULT .mnux FILE */
		menuMan.loadMenuFile ( getFilenamePath(getSourceFileName()) + "/user-interface-mnux-file/menu-default.mnux" )	--"./user-interface-mnux-file/menu-default.mnux"
		
		this._resetHotkeysOfDefaultQuads()
	),
	
	/** Reset hotkeys of default quads
	 */
	function _resetHotkeysOfDefaultQuads =
	(
		--format "\n"; print "QuadMenuManager_v._resetHotkeysOfDefaultQuads()"
		
		default_quads	=  Dictionary #( "Default Viewport Quad",  #nonePressed ) #( "Modeling 1 [Cntrl+RMB]", #controlPressed )

		for quad_name in default_quads.keys where ( quad_default = menuMan.findQuadMenu quad_name ) != undefined do
			menuMan.setViewportRightClickMenu default_quads[quad_name] quad_default
	),
	
	
	--/** Set hotkey by filename
	-- */
	--function _setHotkeyByFilename filename =
	--(
	--	format "\n"; print "QuadMenuManager_v._setHotkeyByFilename()"
	--	format "LAST_CREATED_QUAD: %\n" LAST_CREATED_QUAD
	--	
	--	--format "LAST_CREATED_QUAD: %\n" ( menuMan.getQuadMenuName  LAST_CREATED_QUAD )
	--	format "HOTKEY: %\n" (this._getHotkeyFromPrefix(filename))
	--	
	--	if LAST_CREATED_QUAD != undefined and ( hotkey = this._getHotkeyFromPrefix(filename) ) != undefined then
	--	(
	--		format "ASSIGN HOTKEY TO QUADMENU: \"%\" HOTKEY: %\n" ( menuMan.getQuadMenuName  LAST_CREATED_QUAD ) hotkey
	--		
	--		menuMan.setViewportRightClickMenu hotkey LAST_CREATED_QUAD
	--	)
	--),
	
	
	--/** Get hotkey from prefix of string
	--  * 
	--  * E.G.: "RightClick-foobar" >>> #RightClick
	--  * 
	--  * @return name|undefined
	-- */
	--function _getHotkeyFromPrefix _string =
	--(
	--	--format "\n"; print "QuadMenuManager_v._getHotkeyFromPrefix()"
	--	--format "_string: %\n" _string
	--	delimeters = "_- "
	--	
	--	prefix = (filterString _string delimeters)[1]
	--	--format "prefix: %\n" prefix
	--	hotkey = ( trimLeft prefix delimeters ) 
	--	--format "hotkey: %\n" hotkey
	--	
	--	if hotkey != "RightClick" then
	--	(
	--		if not matchPattern ( hotkey ) pattern:( "*Pressed") then
	--			hotkey = ( hotkey + "Pressed" ) -- add suffix "Pressed"
	--		--format "hotkey: %\n" hotkey
	--		--format "index: %\n" (findItem hotkeys hotkey)
	--		
	--		hotkey = hotkey as name 
	--		
	--		if ( index = findItem hotkeys hotkey ) > 0 then
	--			hotkey --return
	--	)
	--	else
	--		#nonePressed  --return
	--),
	
	/** Update menus hotkeys by OPENING and CLOSING hotkey editor
	  * Workaround for reconnect of quad menus hotkeys and reinstalled quadmenus
	  * 
	  * 
	  * NOTE:
	  *	PROBLEM:  Reinstalling of quad menus break their hotkey shortcuts
	  *  	SOLUTION: Open and close hotkey editor will reconnect hotkeys and reinstalled quadmenus
	  * 
	 */
	function _reconnectHotkeys =
	(
		--format "\n"; print "QuadMenuManager_v._reconnectHotkeys()"
		/* OPEN HOTKEY EDITOR - for refresh quad menu keyboard shortcuts */
		actionMan.executeAction 0 "59245"  -- Customize User Interface: Hotkey Editor

		/* CLOSE HOTKEY EDITOR */
		if (hotkey_dialog = (for hwnd in UIAccessor.GetPopupDialogs() where UIAccessor.GetWindowText hwnd == "Hotkey Editor" collect hwnd)[1]) != undefined then
			UIAccessor.CloseDialog hotkey_dialog
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "QuadMenuManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
