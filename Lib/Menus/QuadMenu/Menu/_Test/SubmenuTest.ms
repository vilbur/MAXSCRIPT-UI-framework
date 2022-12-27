filein( getFilenamePath(getSourceFileName()) + "/../../QuadMenu.ms" )

/**

	TEST GET SUBMENU FROM ITEM

	Submenus can be defined directly in menu, menu itself could not exists

	THIS COMMAND DOE NOT WORK EVERY TIME <Interface><MixinInterface:menuItem>.getSubMenu()

	EXAMPLE:
		Default Viewport Quad > Quad 3 > Context Spline Tools 1 > Edit/Editable Spline Menu

*/


/* =========  NATIVE MAXSCRIPT  ========= */

_MainQuad 	= menuMan.findQuadMenu("Default Viewport Quad")
_QuadMenu 	= _MainQuad.getMenu(3)
_ItemInQuad	= _QuadMenu.getItem 12
_Menu	= _ItemInQuad.getSubmenu()
_ItemInMenu	= _Menu.getItem 1
_Submenu	= _ItemInMenu.getSubmenu() -- !!! NOTICE_1: THIS DONES NOT WALK, ALTHOUGH MENU ITEM IS SUBMENU




/* ========= UI-FRAMEWORK WRAPPER ========= */

MainQuad 	= QuadMenu_v("Default Viewport Quad")	-- get QuadMenu_v()
QuadMenu 	= MainQuad.getMenu(3)	-- get Menu_v()
ItemInQuad	= QuadMenu.getItem("Context Spline Tools 1")	-- get <MixinInterface:menuItem>
Menu	= QuadMenu.getMenu("Context Spline Tools 1")	-- get Menu_v()
ItemInMenu	= Menu.getItem("Edit/Editable Spline Menu")	-- get item by index is valid also Menu.getItem 1
Submenu	= Menu.getSubMenu("Edit/Editable Spline Menu")	-- NOTICE_2: SAME CASE AS NOTICE_1


--Menu.removeItem("Edit/Editable Spline Menu") -- REMOVE ITEM TEST


clearListener()


format "\n------------------- NATIVE MAXSCRIPT --------------\n\n"

format "_MainQuad:	% \n" _MainQuad
format "\n"
format "_QuadMenu:	% \n" _QuadMenu
format "_QuadMenu Title:	% \n" (_QuadMenu.getTitle())

format "\n"
format "_ItemInQuad:	% \n" _ItemInQuad
format "_ItemInQuad Title:	% \n" (_ItemInQuad.getTitle())

format "\n"
format "_Menu:	% \n" _Menu
format "_Menu Title:	% \n" (_Menu.getTitle())

format "\n"
format "_ItemInMenu:	% \n" _ItemInMenu
format "_ItemInMenu Title:	% \n" (_ItemInMenu.getTitle())

format "\n"
format "_Submenu:	% \n" _Submenu -- UNDEFINED




format "\n\n------------------- UI-FRAMEWORK WRAPPER --------------\n\n"

format "MainQuad:   % \n" MainQuad
format "QuadMenu:   % \n" QuadMenu
format "ItemInQuad: % \n" ItemInQuad
format "Menu:       % \n" Menu
format "ItemInMenu: % \n" ItemInMenu
format "Submenu:    % \n" Submenu -- UNDEFINED

format "ItemInMenu Title:	% \n" (ItemInMenu.getTitle())



format "\n\n------------------- COMPARE TEST --------------\n\n"

format "MainQuad     Test:	% \n" (_MainQuad	== MainQuad.QuadMenu)
format "QuadMenu     Test:	% \n" (_QuadMenu	== QuadMenu.Menu)
format "ItemInQuad   Test:	% \n" (_ItemInQuad	== ItemInQuad)
format "Menu         Test:	% \n" (_Menu	== Menu.Menu)
format "ItemInMenu   Test:	% \n" (_ItemInMenu	== ItemInMenu)
