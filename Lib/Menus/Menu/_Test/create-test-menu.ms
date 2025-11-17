clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Menu.ms" )	--"./../Menu.ms"

/**

	TEST PLACED IN QuadMenuTest.ms

	--"./../../_Test/QuadMenuTest.ms"


  */
menu_name 	= "_Test Menu"

mcr_category	= "_Test"
mcr_title	= "Context Menu Test"
mcr_name	= "context_menu_test"


/*------------------------------------------------------------------------------
	DEFINE TESTS
--------------------------------------------------------------------------------*/

/**  CREATE TEST MACROSCRIPT
 */
execute ("macroscript	"+mcr_name+" category:	\"_Test\" buttontext:	\""+mcr_title+"\" toolTip:	\""+mcr_title+"\" ( on execute do ( messageBox \""+mcr_title+"\"	))")


Menu 	= Menu_v (menu_name)
Menu.clearMenu()
Menu.addItem (mcr_category) (mcr_name) title:"Item in Menu"

Menu.addSeparator()

SubMenu = Menu.addMenu("_Test Submenu")

SubMenu.addItem (mcr_category) (mcr_name) title:"Item in submenu"

--Menu.addMenu("_Test Submenu")

--Menu.setFlat("_Test Submenu")(true) -- Set submenu item flat


