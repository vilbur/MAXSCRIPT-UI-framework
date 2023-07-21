/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	IMPORTANT:
		TO USE 'ON EXECUTE DO' if command is used in menu

		Otherwise command will be fired on just activating of the menu

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */


/*------------------------------------------------------------------------------

	ADD TO MENU

--------------------------------------------------------------------------------*

/* ADDED TO MENU AUTOMATICALY BY CATERGORY PRAMATER
*/
macroscript	_test_menu_by_category
category:	"_Test"
buttontext:	"Menu created by category"
icon:	"menu:true"
(
	on execute do messageBox "Menu created by category" beep:false
)


/* MENU NAME DEFINED EXACTLY
*/
macroscript	_test_menu_item_with_title
category:	"_Test"
buttontext:	"Use custom title in icon parameter"
icon:	"menu:_Test Menu"
(
    on isVisible return selection.count>0

	on execute do messageBox "Custom Title" beep:false
)


/* CUSTOM TITLE OF MENU ITEM DEFINED
*/
macroscript	_test_menu_item_with_title
category:	"_Test"
buttontext:	"Use custom title in icon parameter"
icon:	"title:Custom Title"
(
    on isVisible return selection.count>0

	on execute do messageBox "Custom Title" beep:false
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

--------------------------------------------------------------------------------*/

QuadMenuTest.showAllQuads()

QuadMenuTest.setRightClick()

QuadMenuTest.resetRightClick()
