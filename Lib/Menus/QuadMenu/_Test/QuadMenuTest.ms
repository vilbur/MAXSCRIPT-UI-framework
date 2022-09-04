clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../Menu/Menu.ms" )

global QuadMenuTest
global Quad_1
global Quad_2


quad_menu_name	= "_Test Quad"
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
  

/** CREATE QUAD MENU 
  *	
  */
function createQuadMenu =
(
	QuadMenuTest 	= QuadMenu_v (quad_menu_name)
	
	Quad_1 = QuadMenuTest.Quads[1]
	Quad_2 = QuadMenuTest.Quads[2]
)

/** CREATE MENU 
  */
function createMenu =
(
	Menu 	= Menu_v (menu_name)
	
	Menu.addItem (mcr_category) (mcr_name) title:"Item on in menu" --add item to menu
)

/** ADD MENU AS SUBMENU TO QUAD
  */
function addMenu =
(
	/* ADD SUBMENU TO QUAD 2 */ 	
	Menu = Quad_2.addMenu (menu_name) title:"_Title changed"

	/* ADD ITEM TO SUBMENU*/ 
	Menu.addItem (mcr_category) (mcr_name) title:"Item added to submenu" --add item to menu when menu is added already
	
)


/** ADD ITEM TO QUAD MENU
  */
function addItems =
(
	/* ADD ITEM TO QUAD 1 */ 
	Quad_1.addItem (mcr_category) (mcr_name) -- add item to qaud
	Quad_1.addItem (mcr_category) (mcr_name) title:"Item added to index 1" index:1 --add item to menu
	Quad_1.addItem (mcr_category) (mcr_name) title:"Item added to index 2" index:2 --add item to menu
)

/** Add separator
 */
function addSeparator =
(
	/* ADD AS LAST */ 
	Quad_1.addSeparator()
	
	Quad_1.addItem (mcr_category) (mcr_name) title:"Item after separator"
	
	/* ADD ON INDEX */ 
	Quad_1.addSeparator index:2
	Quad_1.addSeparator index:3
)
/** Remove separator
 */
function removeSeparator =
(
	Quad_1.removeSeparator(2)

)


/** Get item
 */
function getItems =
(
	/* By title */ 
	found_by_title =  Quad_1.getItem (mcr_title) 
	format "found_by_title	= % \n" (found_by_title.getTitle() )
	/* By index */
	found_by_index =  Quad_1.getItem (3) 
	format "found_by_index	= % \n" (found_by_index.getTitle() )
)

/** Remove item
 */
function removeItems =
(
	--format "\n"; print "removeItems()"
	menu_item = QuadMenuTest.Quads[1].addItem (mcr_category) (mcr_name) title:"Item to remove"
	
	Quad_1.addItem (mcr_category) (mcr_name) title:"Item to remove by title"
	
	--format "MENU_ITEM	= % \n" menu_item
	Quad_1.removeItem menu_item
	Quad_1.removeItem "Item to remove by title"
)

/** Set menu options
 */
function setMenuOptions =
(
	QuadMenuTest.setRightClick()
	
	QuadMenuTest.showAllQuads()
)



/*------------------------------------------------------------------------------
	RUN TESTS
--------------------------------------------------------------------------------*/
createQuadMenu()

createMenu()
addMenu()

--addItems()
--
--getItems()
--
--addSeparator()
--
--removeSeparator()
--
--removeItems()

setMenuOptions() -- set open on rightclick 



