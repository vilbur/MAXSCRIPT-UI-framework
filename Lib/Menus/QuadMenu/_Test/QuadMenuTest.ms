clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../Menu/Menu.ms" )

quad_menu_name	= "_Test Quad"
menu_name 	= "_Test Menu"

mcr_category = "_Test"
mcr_name     = "context_menu_test"


/**  
 *	
 */
execute ("macroscript	context_menu_test category:	\"_Test\" buttontext:	\"Context Menu Test\" toolTip:	\"Context Menu Test\" ( on execute do ( messageBox \"Context Menu Test\"	))")
  

/** CREATE MENU 
  */
function createMenu =
(
	Menu 	= Menu_v (menu_name)

	Menu.addItem (mcr_category) (mcr_name) title:"Item in menu" --add item to menu
)

/** CREATE QUAD MENU 
  *	
  */
function createQuadMenu =
(
	--QuadMenu 	= (QuadMenu_v (quad_menu_name)).create()
	QuadMenu 	= QuadMenu_v (quad_menu_name)
	
	Quad = QuadMenu.Quads[1]
	format "Quad	= % \n" Quad
	format "Quad.menu.getTitle()	= % \n" (Quad.menu.getTitle())
	Menu = Quad.addMenu (menu_name)
	
	--Quad.addItem (mcr_category) (mcr_name) -- add item to qaud
	--
	
	
	--format "Menu	= % \n" Menu
	--QuadMenu.addMenu menu_name 1
	
	
	
	--Quad.addItem ("context_menu_test") ("_Test")
	--Quad.addItem ("context_menu_test") ("_Test") title:"Context Menu Test Custom Title"
	
	--format "QuadMenu	= % \n" QuadMenu
	
		
	--QuadMenu.addItem "_Test Menu Submenu" ("context_menu_test") ("_Test") title:"Context Menu Test"
	--
	--QuadMenu.setRightClick()
	--QuadMenu.showAllQuads()
	
)

--createMenu()

createQuadMenu()
