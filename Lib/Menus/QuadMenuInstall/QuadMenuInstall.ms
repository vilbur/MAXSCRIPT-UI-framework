--global QUAD_MENU_INSTALL

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu/QuadMenu.ms" )	--"./../QuadMenu/QuadMenu.ms"

/* ADD QUAD MENUS FROM CONFIG FILES
 * 
 * QUAD MENU SHORTCUT IS CREATED IF FILENAME IS PREFIXED BY:
 *		RightClick|shift|alt|control|shiftAndAlt|shiftAndControl|controlAndAlt|shiftAndAltAndControl
 * 
 * 	E.G.: RightClick.ms|shiftAndAlt-fooBarSuffix|alt_fooBar.ms
 * 	
 * 
 * @param dir where quadMenu config *.ms are converted to quad menus
 * 
 */
function QuadMenuInstall dir delimeters:" -_" =
(
	format "\n"; print "QuadMenuInstall()"
	--format "dir: %\n" dir
	format "\n\n====== INSTALL QUAD MENUS FROM DIRECTORY ======\n%\n" ( pathConfig.normalizePath dir )
	
	key_shortcuts = #( #RightClick, #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed )
	
	for menu_file in getFiles ( dir + "\\*.ms") do
	(
		menu_file = pathConfig.normalizePath menu_file
		
		format "\n\n====== INSTALL QUAD MENU FILE ======\n%\n" menu_file
	
		filein( menu_file )
	
		-- if QUAD_MENU_INSTALL != undefined then
		-- (
		--	filename = getFilenameFile( menu_file )
		--	
		--	keyboard_shortcut	= (filterString filename delimeters)[1]
		--
		--	if ( index = findItem key_shortcuts menu_shortcut ) > 0 then
		--	(
		--		--format "QUAD_MENU_INSTALL:	% \n" filename
		--	--try(
		--
		--		if keyboard_shortcut == "RightClick" then
		--		(
		--			QUAD_MENU_INSTALL.setRightClick()
		--			
		--			format "KEYBOARD SHORTCUT: RightClick\n"
		--		)
		--		else
		--		(
		--			keyboard_shortcut = ( keyboard_shortcut + "Pressed" ) as name
		--
		--			QUAD_MENU_INSTALL.setRightClick which:keyboard_shortcut
		--			
		--			format "KEYBOARD SHORTCUT: %\n" keyboard_shortcut
		--		)
		--		
		--
		--		QUAD_MENU_INSTALL = undefined
		--		
		--	)
		--	else
		--		format "\nQUAD MENU IS NOT INSTALLED: global variable QUAD_MENU_INSTALL is undefined\n"
		--	
		--
	--	)catch(
	--
	--		format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
	--		format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
	--		format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
	--		format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
	--
	--    )
	
		 --)
	
	
	)
)


