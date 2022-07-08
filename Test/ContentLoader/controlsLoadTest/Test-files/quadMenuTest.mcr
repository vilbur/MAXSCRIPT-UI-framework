
/** Add macroscript to menus and quad menu
 *
 */

/*------------------------------------------------------------------------------
	ADD TO MENU
--------------------------------------------------------------------------------*/
macroscript	_test_menu_item
category:	"_Test"
buttontext:	"Menu Test"
toolTip:	"Menu Test"
--toolTip:	"contenxt_menu_test"
--icon:	"menu:_Test Menu"
icon:	"quad:_Quad Test.1" 
(
	on execute do messageBox "Menu Test" 
)


/*------------------------------------------------------------------------------
	ADD TO QUAD MENU
--------------------------------------------------------------------------------*/
macroscript	_test_quadmenu_item
category:	"_Test"
buttontext:	"_Quad Test"
toolTip:	"_Quad Test"

/*
	QUAD MENU NAME AND QUAD MENU INDEX WHERE TO ADD MACROSCRIPT
 */
icon:	"quad:_Quad Test.2" 
(
	
	on execute do messageBox "_Quad Test" -- IMPORTANT TO USE 'ON EXECUTE DO' if command is used in menu
)


/*------------------------------------------------------------------------------
	DEFINE TITLE
--------------------------------------------------------------------------------*/
macroscript	_test_menu_item_with_title
category:	"_Test"
buttontext:	"Use custom title in icon parameter"
toolTip:	""
icon:	"menu:_Test Menu|title:Custom Title"
(
    on isVisible return selection.count>0

	on execute do messageBox "Custom Title" beep:false
)

/** MODIFY QUAD MENU 
  *	
  */
QuadMenuTest 	= QuadMenu_v ("_Quad Test")

QuadMenuTest.Quads[1].setTitle ("First Quad")
QuadMenuTest.Quads[2].setTitle ("Second Quad")

QuadMenuTest.Quads[1].addMenu ("_Test Menu") flat:true

QuadMenuTest.Quads[1].addSeparator()

QuadMenuTest.Quads[1].addItem ("Tools") ("Move")


QuadMenuTest.showAllQuads()
QuadMenuTest.setRightClick()
--QuadMenuTest.resetRightClick()

