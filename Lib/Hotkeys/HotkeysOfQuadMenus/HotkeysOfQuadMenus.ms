struct HotkeysOfQuadMenus_v
(
	-- ==========================================
	-- PROPERTIES
	-- ==========================================
	debug = false,
	
	mod_keys = #( #nonePressed, #controlPressed, #shiftPressed, #altPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed ),
	
	hotkeys_and_quad_data = Dictionary #STRING,
	
	kbd_path = ( getDir #TEMP ) + "3DsMax-hotkeys.kbdx",
	
	XmlParser = XmlParser_v(kbd_path),
	
	quad_menus = for i = 1 to (menuMan.numQuadMenus() ) collect (menuMan.getQuadMenuName (menuMan.getQuadMenu i)),


	-- ==========================================
	-- METHODS
	-- ==========================================
	-- ==========================================
	-- MAIN EXECUTION
	-- ==========================================
	function getHotkeysOfQuadMenus =
	(
		
		
		actionman.SaveKeyboardFile( kbd_path )
		
		/* GET RIGHTCLICK MENUS */ 
		this.getMenusOfModKeysAndRMB()
		
		/* GET HOTKEYS MENUS */ 
		this.getQuadsWithKeyboardShortcut()
		
		/* DEBUG */
		if debug then this.printMenuHotkeys()

		return hotkeys_and_quad_data
	),
	
	/** Get quad menu data
	 */
	function getQuadMenuData quad_menu_name =
	(
		local quad_menu = menuMan.findQuadMenu (trimLeft quad_menu_name)
		local quad_data = Dictionary #( #QUADS, "")
		
		quad_data[#MENU_NAME]  = quad_menu_name
		quad_data[#QUAD_NAMES]  = ""
		
		for i = 1 to 4 do
			quad_data[#QUAD_NAMES] += ( trimLeft ( trimRight ((quad_menu.getMenu i).getTitle())))  + " | " 
		
		quad_data[#QUAD_NAMES] = trimRight quad_data[#QUAD_NAMES] " | "
		
		quad_data --return
	),
	

	/*
	   #shiftAndControlPressed >>> "Control + Shift + Alt + RMB"
	  
		@return string
	*/ 
	function getMenusOfModKeysAndRMB =
	(
		--format "\n"; print "HotkeysOfQuadMenusStruct.getMenusOfModKeysAndRMB()"
		
		function camelCaseToString str =
		(
			hotkey	= ""
			
			keys_order	= #( "Control", "Shift", "Alt" )
			
			str[1] = toUpper str[1]
			
			local rx = ( dotNetClass "System.Text.RegularExpressions.Regex" )
			
			str	= rx.Replace str "Pressed" ""
			str	= rx.Replace str "And" " "
			
			str_split	= filterString str " "
			
	
			for key in keys_order where findItem str_split key do 
				hotkey += key + " + "
			
			hotkey + "RMB" --return
		)
		
		local prefix = " " -- for oder of "RMB" shorcuts as first
		
		for mod_key in mod_keys do
		(
			local menu_of_mod_key = menuMan.getViewportRightClickMenu mod_key
			
			if menu_of_mod_key != undefined then
			(
				local quad_menu_name = menuMan.getQuadMenuName menu_of_mod_key
				--format "mod_key: %\n" mod_key
				local mod_key_shortcut = camelCaseToString ( mod_key as string )
				
				hotkeys_and_quad_data[ prefix + mod_key_shortcut ] = this.getQuadMenuData quad_menu_name 
			)
		)
	),
	

	function getQuadsWithKeyboardShortcut =
	(
		--format "\n"; print "HotkeysOfQuadMenusStruct.getQuadsWithKeyboardShortcut()"
		
		function getHumanReadableKey mod_key hotkey =
		(
			-- 1. Identify Modifiers based on fVirt bitmask
			local modStr = ""
			
			if (bit.and hotkey 8)  == 8  then modStr += "Ctrl + "
			if (bit.and hotkey 4)  == 4  then modStr += "Shift + "
			if (bit.and hotkey 16) == 16 then modStr += "Alt + "
			
			-- 2. Map Virtual Key Code to Name
			local keyboardSet = dotNetClass "System.Windows.Forms.Keys"
			local keyName = ( dotNetObject "System.Windows.Forms.KeysConverter").ConvertToString mod_key
			
			/* TWEAK CONVERSION INCORRECTIONS */ 
			if keyName == "Divide" then
				keyName = "/"
			
			return (modStr + keyName)
		)
		
		
		/*------------------------------------------------------------------------------
			GET HOTKEY FOR EACH QUAD MENU
		--------------------------------------------------------------------------------*/
		for quad_menu_name in quad_menus do
		(
			local element = XmlParser.getElement #shortcut attr:"actionID" val:quad_menu_name
			
			if element != undefined then 
			(
				--format "\n"
				local mod_key    = ( XmlParser.getAttribute element "accleleratorKey" ) as integer
				local hotkey_val = ( XmlParser.getAttribute element "fVirt" ) as integer
				--format "mod_key: %\n" mod_key
				--format "hotkey_val: %\n" hotkey_val
				local hotkey = getHumanReadableKey mod_key hotkey_val
				
				--hotkeys_and_quad_data[hotkey] = this.getQuadMenuData quad_menu_name
				hotkeys_and_quad_data[hotkey] = this.getQuadMenuData quad_menu_name

			)
 		)
	),

	function printMenuHotkeys =
	(
		--format "\n"; print "HotkeysOfQuadMenusStruct.getQuadsWithKeyboardShortcut()"

		--format "hotkeys_and_quad_data.keys: %\n" hotkeys_and_quad_data.keys
		--format "hotkeys_and_quad_data.keys: %\n" (sort hotkeys_and_quad_data.keys)
		
		prefix = "--------------------------------------------------------------------------------------------------------------"
		--for hotkey in hotkeys_and_quad_data.keys do
		for hotkey in sort hotkeys_and_quad_data.keys do
		(
			local quad_data = hotkeys_and_quad_data[hotkey]
		
			FORMAT "\n%\n\nMENU:   %\nHOTKEY: %\nQUADS:  % \n" prefix quad_data[#MENU_NAME] (trimLeft hotkey) quad_data[#QUAD_NAMES]
		)
	),
	
	/**
	 */
	on create do
	(
	)
)

/* -- Usage Example:
-- myHotkeys = HotkeysOfQuadMenusStruct debug:true
-- myHotkeys.execute()
*/