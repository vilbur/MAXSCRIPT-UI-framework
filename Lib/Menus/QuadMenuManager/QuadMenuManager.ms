/** Quad menu manager
 */
struct QuadMenuManager_v
(
	/* construct */
	

	/* required */
	

	/* properties */

	

	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	
	/** Install menus
	 */
	function installMenus dir =
	(
		--format "\n"; print "QuadMenuManager_v.installMenus()"
		this.importMacroscriptFilesToMenus()
		
		/* ISNTALL QUAD MENUS */ 
		installQuadsFromFiles( dir  )	--"./../../../QuadMenu/QuadMenus"

		this.setDefaultQuadHotkey(#shiftAndAltAndControlPressed)
		
		this.saveMenusToMaxStartup()
		
		this.reconnectHotkeys()
	),
	
	/** Reset mnus and hotkeys
	 */
	function resetMenusAndHotkeys =
	(
		--format "\n"; print "QuadMenuManager_v.resetMnusAndHotkeys()"
		if queryBox "REST ALL MENUS AND QUADMENUS ?" title:"RESET MENUS" then
		(
			this.loadDefaultMenuConfig()
			
			this.resetHotkeysOfDefaultQuads()
		)
	),

	/** Import macroscript files to menus
	 */
	function importMacroscriptFilesToMenus dir blacklist:#() =
	(
		--format "\n"; print "QuadMenuManager_v.importMacroscriptFilesToMenus()"
		/** Test if path is on blacklist
		 */
		function _isNotOnBlacklist macro_path blacklist = (for pattern in blacklist where matchPattern macro_path pattern:pattern collect pattern).count == 0
		
		all_macro_files = getFiles ( dir + "/*.mcr" ) recurse:true  -- "./../../slot_properties.ini"
		
		for macro_path in all_macro_files where this._isNotOnBlacklist macro_path blacklist do
			try
				(ScriptFile_Content_v(macro_path)).importMacroscriptsToMenus()
				
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
	
	/** Install quads from files
	 */
	function installQuadsFromFiles dir =
	(
		--format "\n"; print "QuadMenuManager_v.installQuadsFromFiles()"
		key_shortcuts = #( #RightClick, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed )
		
		for menu_file in getFiles ( dir + "\\*.ms") do
		(
			menu_file = pathConfig.normalizePath menu_file
			
			format "\n\n====== INSTALL QUAD MENU FILE ======\n%\n" menu_file
		
			filein( menu_file )
		)
	),
	
	/** Set menus to max start
	 */
	function saveMenusToMaxStartup =
	(
		--format "\n"; print "QuadMenuManager_v.saveMenusToMaxStartup()"
		menuMan.saveMenuFile ((getDir #ui)+"\\MaxStartUI.mnux") --"./../../../../../en-US/UI/MaxStartUI.mnux"
	),
	
	/** Load default menu config
	 */
	function loadDefaultMenuConfig =
	(
		--format "\n"; print "QuadMenuManager_v.loadDefaultMenuNfig()"
		/* LAOD 3DS MAX DEFAULT .mnux FILE */
		menuMan.loadMenuFile ( getFilenamePath(getSourceFileName()) + "/user-interface-mnux-file/menu-default.mnux" )	--"./user-interface-mnux-file/menu-default.mnux"
		
		this.resetHotkeysOfDefaultQuads()
	),
	
	/** Reset hotkeys of default quads
	 */
	function resetHotkeysOfDefaultQuads =
	(
		--format "\n"; print "QuadMenuManager_v.resetHotkeysOfDefaultQuads()"
		
		default_quads	=  Dictionary #{ "Default Viewport Quad",  #nonePressed } #{ "Modeling 1 [Cntrl+RMB]", #controlPressed 

		for quad_name in default_quads.keys where ( quad_default = menuMan.findQuadMenu quad_name ) != undefined do
			menuMan.setViewportRightClickMenu default_quads.value quad_default
	),
	
	/** Update menus hotkeys by OPENING and CLOSING hotkey editor
	  * Workaround for reconnect of quad menus hotkeys and reinstalled quadmenus
	  * 
	  * 
	  * NOTE:
	  *	PROBLEM:  Reinstalling of quad menus break their hotkey shortcuts
	  *  	SOLUTION: Open and close hotkey editor will reconnect hotkeys and reinstalled quadmenus
	  * 
	 */
	function reconnectHotkeys =
	(
		--format "\n"; print "QuadMenuManager_v.reconnectHotkeys()"
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
