global QUAD_MENU_INSTALL

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu/QuadMenu.ms" )	--"./../QuadMenu/QuadMenu.ms"

/* ADD QUAD MENUS FROM CONFIG FILES
 * 
 * QUAD MENU SHORTCUT IS CREATED IF FILENAME IS PREFIXED BY:
 *		shiftPressed|altPressed|controlPressed|shiftAndAltPressed|shiftAndControlPressed|controlAndAltPressed|shiftAndAltAndControlPressed
 * 
 * 	E.G.: controlPressed.ms|shiftAndAltPressed-fooBarSuffix|altPressed_.ms
 * 	
 * 
 * @param dir where quadMenu config *.ms are converted to quad menus
 * 
 */
function QuadMenuInstall dir delimeters:" -_" =
(
	--format "\n"; print ".()"
	key_shortcuts = #( #shiftPressed, #altPressed, #controlPressed, #shiftAndAltPressed, #shiftAndControlPressed, #controlAndAltPressed, #shiftAndAltAndControlPressed )
	
	for menu_file in getFiles ( dir + "\\*.ms") do
	(
		--format "\n";	format "menu_file:	% \n" menu_file
	
		filein( menu_file )
	
		filename = getFilenameFile( menu_file )
	
		 if QUAD_MENU_INSTALL != undefined then
		 (
			--format "QUAD_MENU_INSTALL:	% \n" filename
		--try(
			filename	= (filterString filename delimeters)[1]
		
	
			if filename == "RightClick" then
				QUAD_MENU_INSTALL.setRightClick()
	
			else
			(
				menu_shortcut = ( filename + "Pressed" ) as name
	
				if ( index = findItem key_shortcuts menu_shortcut ) > 0 then
					QUAD_MENU_INSTALL.setRightClick which:menu_shortcut
			)
	
			QUAD_MENU_INSTALL = undefined
	
	--	)catch(
	--
	--		format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
	--		format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
	--		format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
	--		format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
	--
	--    )
	
		 )
	
	
	)
)


