clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Menu/_Test/create-test-menu.ms" )	--"./../../Menu/_Test/create-test-menu.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"

/* Convert existing menu to Rightclick menu

*/
(RcMenu_v(menu_name)).popUp()




--MenuRc = RcMenu_v name:"Helpers"
MenuRc = RcMenu_v("Helpers")
--MenuRc = RcMenu_v("HelpersX")

--MenuRc.loadMenu "Helpers"

--MenuRc.popUp()
