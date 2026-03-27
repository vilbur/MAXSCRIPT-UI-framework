function getHotkeysOfQuadMenus debug:false =
(
	-- Initialize shared variables
	local hotkeys = #( #nonePressed, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed )
	local menus_hotkeys = Dictionary #STRING

	local kbd_path = ( getDir #TEMP ) + "3DsMax-hotkeys.kbdx"

	local XmlParser = XmlParser_v(kbd_path)

	local quad_menus = for i = 1 to (menuMan.numQuadMenus() ) collect (menuMan.getQuadMenuName (menuMan.getQuadMenu i))
	
	-- ==========================================
	-- NESTED UTILITY FUNCTIONS
	-- ==========================================

	fn getHumanReadableKey mod_key hotkey =
	(
		-- 1. Identify Modifiers based on fVirt bitmask
		local modStr = ""
		if (bit.and hotkey 8) == 8 then modStr += "Ctrl+"
		if (bit.and hotkey 16) == 16 then modStr += "Alt+"
		if (bit.and hotkey 4) == 4 then modStr += "Shift+"
		
		-- 2. Map Virtual Key Code to Name
		local keyboardSet = dotNetClass "System.Windows.Forms.Keys"
		local keyName = (dotNetObject "System.Windows.Forms.KeysConverter").ConvertToString mod_key
		
		if keyName == "Divide" then
			keyName = "/"
		
		return (modStr + keyName)
	)

	fn camelCaseToString str =
	(
		str[1] = toUpper str[1]
		local rx = ( dotNetClass "System.Text.RegularExpressions.Regex" )
		str	= rx.Replace str "Pressed" " + RMB"
		str	= rx.Replace str "And" " + "
		
		return str
	)

	-- ==========================================
	-- NESTED LOOP FUNCTIONS
	-- ==========================================

	fn processQuadMenus menus_hotkeys xmlParser quad_menus_list =
	(
		for quad_menu_name in quad_menus_list do
		(
			local element = xmlParser.getElement #shortcut attr:"actionID" val:quad_menu_name
			
			if element != undefined then 
			(
				local mod_key = ( xmlParser.getAttribute element "accleleratorKey" ) as integer
				local hotkey_val  = ( xmlParser.getAttribute element "fVirt" ) as integer
				
				menus_hotkeys[quad_menu_name] = getHumanReadableKey mod_key hotkey_val
			)
		)
	)

	fn processRightClickMenus menus_hotkeys hotkeys =
	(
		for hotkey in hotkeys do
		(
			local menu_of_hotkey = menuMan.getViewportRightClickMenu hotkey
			
			if menu_of_hotkey != undefined then
				menus_hotkeys[ menuMan.getQuadMenuName menu_of_hotkey ] = camelCaseToString (hotkey as string)
		)
	)

	fn printMenuHotkeys menus_hotkeys =
	(
		for menu_name in menus_hotkeys.keys do
			format "menu: % \nhotkey: %\n\n" menu_name menus_hotkeys[menu_name]
	)

	-- ==========================================
	-- MAIN EXECUTION
	-- ==========================================
	actionman.SaveKeyboardFile( kbd_path )
	-- Execute the loop functions
	processQuadMenus (menus_hotkeys) (XmlParser) (quad_menus)
	
	processRightClickMenus(menus_hotkeys)(hotkeys)
	
	/* DEBUG */
	if debug then
		printMenuHotkeys(menus_hotkeys)

	return menus_hotkeys
)