clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Menu/Menu.ms" )

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


/** GET DEFAULT 3DS MAX QUAD MENU
 */
function getDefaultQuadMenu =
(
	--format "\n"; print ".getDefaultQuadMenu()"
	DeafultQuadMenu 	= QuadMenu_v ("Snap")
	format "DeafultQuadMenu = % \n" DeafultQuadMenu
)



/** CREATE QUAD MENU
  *
  */
function createQuadMenu =
(
	QuadMenuTest 	= QuadMenu_v (quad_menu_name)

	Quad_1 = QuadMenuTest.Quads[1]
	Quad_2 = QuadMenuTest.Quads[2]
)

/** ADD ITEM TO QUAD MENU
  */
function addItemsToQuad =
(
	/* ADD ITEM TO QUAD 1 */
	Quad_1.addItem (mcr_category) (mcr_name) -- add item to qaud
	Quad_1.addItem (mcr_category) (mcr_name) title:"Item added to index 1" index:1 --add item to menu
	Quad_1.addItem (mcr_category) (mcr_name) title:"Item added to index 2" index:2 --add item to menu
)

/** Move items
 */
function moveItemInQuad =
(
	--format "\n"; print ".moveItems()"

	Quad_1.addItem (mcr_category) (mcr_name) title:"Item moved" -- add item to qaud

	Quad_1.moveItem ("Item moved") 1
)

/** CREATE MENU
  */
function createMenuInMenuList =
(
	Menu 	= Menu_v (menu_name)

	Menu.addItem (mcr_category) (mcr_name) title:"Item in menu" --add item to menu, otherwise menu is not dispalyed
)

/** ADD MENU AS SUBMENU TO QUAD
  */
function addMenuToQuad2 =
(
	--format "\n"; print "addMenu()"
	/* ADD MENU TO QUAD 2 */
	Menu = Quad_2.addMenu (menu_name) title:"Custom Menu Title"

	/* ADD FLAT MENU TO QUAD 2 */
	Menu_flat = Menu_v ("Menu Flat")

	Menu_flat.addItem (mcr_category) (mcr_name) title:"Item in flat menu" --add item to menu, otherwise menu is not displayed

	Quad_2.addMenu ("Menu Flat") index:1 flat:true -- flat:false is default
)

/** Move items
 */
function moveItemsInMenu =
(
	--format "\n"; print ".moveItems()"

	Menu = Menu_v (menu_name)
	--format "Menu	= % \n" Menu
	Menu.addItem (mcr_category) (mcr_name) title:"Item moved to index:1"

	Menu.moveItem ("Item moved to index:1") 1
)

/** Add submenu
 */
function addSubmenu =
(
	--format "\n"; print "addSubmenu()"
	Menu 	= Menu_v (menu_name)

	SubMenu = Menu.addMenu("_Test Submenu")

	SubMenu.addItem (mcr_category) (mcr_name) title:"Item in submenu"

	Menu.addMenu("_Test Submenu")

	Menu.setFlat("_Test Submenu")(true) -- Set submenu item flat
)

/** Add separator
 */
function addSeparator =
(
	/* ADD AS LAST */
	Quad_1.addSeparator()
	Quad_1.addSeparator() -- this separator is not added, because of exists already

	Quad_1.addItem (mcr_category) (mcr_name) title:"Item after separator"

	/* ADD ON INDEX */
	Quad_1.addSeparator index:1
	Quad_1.addSeparator index:3
)
/** Remove separator
 */
function removeSeparator =
(
	Quad_1.removeSeparator(2)
)

/** Remove double separators and separators on start or end of menu
 */
function cleanSeparator =
(
	--format "\n"; print ".cleanSeparator()"
	Quad_1.addSeparator index:4 -- add double separator
	Quad_1.addSeparator()

	Quad_1.cleanSeparators()
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

/* QUAD MENU */
getDefaultQuadMenu()


--/* QUAD MENU */
--createQuadMenu()
--
--addItemsToQuad()
--
--moveItemInQuad()
--
--
--/* MENU */
--createMenuInMenuList()
--
--addMenuToQuad2()
--
--moveItemsInMenu()
--
--
--/* SUBMENU */
--addSubmenu()
--
--
--/* SEPARATOR */
--addSeparator()
--
--removeSeparator()
--cleanSeparator()
--
--/* ITEMS OPERATIONS */
--getItems()
--
--removeItems()
--
--
--/* QUAD MEMU OPTIONS */
--setMenuOptions() -- set open on rightclick
