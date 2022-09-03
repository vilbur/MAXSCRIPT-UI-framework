clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../Menu/Menu.ms" )

global QuadMenuTest

quad_menu_name	= "_Test Quad"
menu_name 	= "_Test Menu"

mcr_category	= "_Test"
mcr_title	= "Context Menu Test"
mcr_name	= "context_menu_test"



/*------------------------------------------------------------------------------
	DEFINE TESTS
--------------------------------------------------------------------------------*/

/**  Create test macroscript
 */
execute ("macroscript	"+mcr_name+" category:	\"_Test\" buttontext:	\""+mcr_title+"\" toolTip:	\""+mcr_title+"\" ( on execute do ( messageBox \""+mcr_title+"\"	))")
  

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
	--QuadMenuTest 	= (QuadMenu_v (quad_menu_name)).create()
	QuadMenuTest 	= QuadMenu_v (quad_menu_name)
	
	Quad_1 = QuadMenuTest.Quads[1]
	Quad_2 = QuadMenuTest.Quads[2]

	/* ADD ITEM TO QUAD 1 */ 
	Quad_1.addItem (mcr_category) (mcr_name) -- add item to qaud
	
	
	/* ADD SUBMENU TO QUAD 2 */ 
	Menu = Quad_2.addMenu (menu_name)
	
	/* ADD ITEM TO SUBMENU*/ 
	Menu.addItem (mcr_category) (mcr_name) title:"Item added via QuadMenuTest" --add item to menu
)

/** Set menu options
 */
function setMenuOptions =
(
	QuadMenuTest.setRightClick()
	
	QuadMenuTest.showAllQuads()
)


/** Remove item
 */
function removeItem =
(
	--format "\n"; print "removeItem()"
	menu_item = QuadMenuTest.Quads[1].addItem (mcr_category) (mcr_name) title:"Item to remove"
	
	QuadMenuTest.Quads[1].addItem (mcr_category) (mcr_name) title:"Item to remove by title"
	
	--format "MENU_ITEM	= % \n" menu_item
	QuadMenuTest.Quads[1].removeItem menu_item
	QuadMenuTest.Quads[1].removeItem "Item to remove by title"
)

/*------------------------------------------------------------------------------
	RUN TESTS
--------------------------------------------------------------------------------*/
createMenu()

createQuadMenu()

removeItem()

setMenuOptions()



