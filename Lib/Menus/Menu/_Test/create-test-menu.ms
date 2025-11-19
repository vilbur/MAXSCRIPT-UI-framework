clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Menu.ms" )	--"./../Menu.ms"

/**

	OTHER TESTS PLACED IN QuadMenuTest.ms

	--"./../../_Test/QuadMenuTest.ms"


  */
menu_name 	= "_Test Menu"

mcr_category	= "_Test"
mcr_title	= "Menu Test"
mcr_name	= "menu_test"


/*------------------------------------------------------------------------------
	DEFINE TESTS
--------------------------------------------------------------------------------*/

/**  CREATE TEST MACROSCRIPT
 */
execute ("macroscript	"+mcr_name+" category:	\"_Test\" buttontext:	\""+mcr_title+"\" toolTip:	\""+mcr_title+"\" ( on execute do ( messageBox \""+mcr_title+"\"	))")

/*------------------------------------------------------------------------------
	MENU
--------------------------------------------------------------------------------*/
Menu 	= Menu_v (menu_name)
Menu.clearMenu()
Menu.addItem (mcr_category) (mcr_name) title:"Item in Menu"

Menu.addSeparator()

/*------------------------------------------------------------------------------
	SUB MENU
--------------------------------------------------------------------------------*/
SubMenu = Menu.addMenu("_Test Submenu")
SubMenu.clearMenu()

SubMenu.addItem (mcr_category) (mcr_name) title:"Submenu item 1" 
SubMenu.addSeparator()

/*------------------------------------------------------------------------------
	NESTED SUB MENU
------------------------------------------------------------------------------*/
SubMenuNested = SubMenu.addMenu("_Test SubMenuNested")
SubMenuNested.clearMenu()

SubMenuNested.addItem (mcr_category) (mcr_name) title:"SubMenuNested item 1" 


