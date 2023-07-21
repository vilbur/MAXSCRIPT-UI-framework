/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	IMPORTANT:
		TO USE 'ON EXECUTE DO' if command is used in menu

		Otherwise command will be fired on just activating of the menu

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */


/*------------------------------------------------------------------------------

	ADD TO MENU

--------------------------------------------------------------------------------*

/* ADDED TO MENU AUTOMATICALY BY CATERGORY PRAMATER
* Title is button text
*/
macroscript	_test_menu_by_category
category:	"_Test"
buttontext:	"Menu created by category"
icon:	"menu:true"
(
	on execute do messageBox "Menu created by category" beep:false
)

/* TITLE IS TOOLTIP
*/
macroscript	_test_menu_title_by_tooltip
category:	"_Test"
buttontext:	"This is not menu title"
toolTip:	"Menu title by tooltip"
icon:	"menu:tooltip"
(
	on execute do messageBox "Test" beep:false
)


/* MENU NAME DEFINED EXACTLY
*/
macroscript	_test_menu_defined
category:	"_Test"
buttontext:	"Button text is menu item title"
icon:	"menu:_Test Menu"
(
	on execute do messageBox "Test" beep:false
)


/* MENU ITEM TITLE DEFINED
*/
macroscript	_test_menu_title_defined
category:	"_Test"
buttontext:	"Title Defined"
icon:	"title:Menu Title Defined"
(
	on execute do messageBox "Test" beep:false
)


/* MENU NAME AND MENU ITEM TITLE DEFINED EXACTLY
*/
macroscript	_test_menu_and_title_defined
category:	"_Test"
buttontext:	"Menu And Title Defined"
icon:	"menu:_Test Menu|title:Menu And Title Defined"
(
	on execute do messageBox "Test" beep:false
)

/*------------------------------------------------------------------------------

	ADD TO QUAD MENU

--------------------------------------------------------------------------------*

/** ADD MACROSCRIPT TO QUAD MENU
 */
macroscript	_test_menu_item
category:	"_Test"
buttontext:	"_Quad Test"
toolTip:	"Item in quad"
icon:	"Quad:_Quad Test"
(
	on execute do messageBox "Menu Test"
)


/** ADD ITEM TO INDEX
*/
macroscript	_test_quadmenu_item
category:	"_Test"
buttontext:	"_Quad Test"
toolTip:	"_Quad Test"
icon:	"quad:_Quad Test.2"
(
	on execute do messageBox "_Quad Test"
)


/*------------------------------------------------------------------------------

	GET QUAD MENU

--------------------------------------------------------------------------------*/

QuadMenuTest 	= QuadMenu_v ("_Quad Test")


/*------------------------------------------------------------------------------

	SETTING QUAD MENU

------------------------------------------------------------------------------*/

QuadMenuTest.Quads[1].setTitle ("First Quad")
QuadMenuTest.Quads[2].setTitle ("Second Quad")

QuadMenuTest.Quads[1].addMenu ("_Test Menu") flat:true

QuadMenuTest.Quads[1].addSeparator()

QuadMenuTest.Quads[1].addItem ("Tools") ("Move")



/*------------------------------------------------------------------------------

	MODIFY QUAD MENU OPTIONS

------------------------------------------------------------------------------*/

QuadMenuTest.showAllQuads()

QuadMenuTest.setRightClick()

QuadMenuTest.resetRightClick()
