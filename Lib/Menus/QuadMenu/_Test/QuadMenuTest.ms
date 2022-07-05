clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../Menu/Menu.ms" )

quad_menu_name	= "_Test Quad"
menu_name 	= "_Test Menu"

mcr_category = "_Test"
mcr_name     = "context_menu_test"



/*------------------------------------------------------------------------------
	DEFINE TESTS
--------------------------------------------------------------------------------*/

/**  Create test macroscript
 */
execute ("macroscript	context_menu_test category:	\"_Test\" buttontext:	\"Context Menu Test\" toolTip:	\"Context Menu Test\" ( on execute do ( messageBox \"Context Menu Test\"	))")
  

/** CREATE MENU 
  */
function createMenu =
(
	Menu 	= Menu_v (menu_name)

	Menu.addItem (mcr_category) (mcr_name) title:"Item in submenu" --add item to menu
)

/** CREATE QUAD MENU 
  *	
  */
function createQuadMenu =
(
	--QuadMenu 	= (QuadMenu_v (quad_menu_name)).create()
	QuadMenu 	= QuadMenu_v (quad_menu_name)
	
	
	Quad_1 = QuadMenu.Quads[1]
	Quad_2 = QuadMenu.Quads[2]

	/* ADD ITEM TO QUAD 1 */ 
	Quad_1.addItem (mcr_category) (mcr_name) -- add item to qaud
	
	
	/* ADD SUBMENU TO QUAD 2 */ 
	Menu = Quad_2.addMenu (menu_name)
	
	/* ADD ITEM TO SUBMENU*/ 
	Menu.addItem (mcr_category) (mcr_name) title:"Item added via QuadMenu" --add item to menu

	/* SET QUAD MENU OPTIONS */ 
	QuadMenu.setRightClick()
	QuadMenu.showAllQuads()
)



/*------------------------------------------------------------------------------
	RUN TESTS
--------------------------------------------------------------------------------*/
createMenu()

createQuadMenu()