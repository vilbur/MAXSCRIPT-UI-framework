clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Menu/_Test/create-test-menu.ms" )	--"./../../Menu/_Test/create-test-menu.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"

/* TEST MENU */ 
--(RcMenu_v(menu_name)).popUp()

/* NATIVE MAX MENU TO RC MENU */ 
 --(RcMenu_v("Helpers")).popUp()



/*------------------------------------------------------------------------------
	SUBMENU TEST
--------------------------------------------------------------------------------*/

MenuRc = RcMenu_v name:"Test Menu"

MenuRc.item "Menu Item 1"  "messagebox \"Menu Item 1\""

/* NATIVE MAX MENU TO RC SUBMENU */ 
SubMenuRc = MenuRc.menu "Helpers"


MenuRc.popUp()
