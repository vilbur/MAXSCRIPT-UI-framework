clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Menu/_Test/create-test-menu.ms" )	--"./../../Menu/_Test/create-test-menu.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"

/* Convert existing menu to Rightclick menu

*/
--MenuRc = RcMenu_v()
MenuRc = RcMenu_v name:menu_name

MenuRc.loadMenu menu_name

--MenuRc.loadMenu "menu_name"

/** POP UP MENU ON MOUSE POS
 *
 */
MenuRc.popUp()
