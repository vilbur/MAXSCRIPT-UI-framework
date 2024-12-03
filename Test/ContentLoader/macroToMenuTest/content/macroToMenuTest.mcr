/**
	GENERATE MENUS AND QUAD STREAIGH FROM MACROSCRIPTS

	Category is menu name
	Button text is item title in default

	Title can be also Tooltip, or exactly defined

 */



/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


	IMPORTANT:
		TO USE 'ON EXECUTE DO' if command is used in menu

		Otherwise command can be fired on just activating of the menu

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */



/*------------------------------------------------------------------------------

	ADD TO MENU

--------------------------------------------------------------------------------*

/* ADDED TO MENU AUTOMATICALY BY CATERGORY PRAMATER
*
* TITLE IS BUTTON TEXT
*/
macroscript	_test_menu_title_by_buttontext
category:	"_Test Menu"
buttontext:	"Button text is title"
icon:	"MENU:true"
(
	on execute do messageBox "Voila"

)

/* ITEM TITLE IS DEFINED
*/
macroscript	_test_menu_title_defined
category:	"_Test Menu"
buttontext:	"This is buttontext"
icon:	"MENU:Item title is defined"
(
	on execute do messageBox "Voila"

)

/* ITEM TITLE IS TOOLTIP
*/
macroscript	_test_menu_title_by_tooltip
category:	"_Test Menu"
buttontext:	"This is not menu title"
toolTip:	"Tooltip is title"
icon:	"MENU:tooltip"
(
	on execute do messageBox "Voila"

)


/*------------------------------------------------------------------------------

	ADD TO QUAD MENU SEEM TO BE USELESS, IT IS DIS

--------------------------------------------------------------------------------*

--/** ADD MACROSCRIPT TO QUAD MENU
-- */
--macroscript	_test_menu_item
--category:	"_Test Quad Menu"
--buttontext:	"_Quad Test"
--toolTip:	"Item in quad"
--icon:	"Quad:_Quad Test"
--(
--	on execute do messageBox "Voila"
--
--)
--
--
--/** ADD ITEM TO INDEX
--*/
--macroscript	_test_quadmenu_item
--category:	"_Test Quad Menu"
--buttontext:	"_Quad Test"
--toolTip:	"_Quad Test"
--icon:	"quad:_Quad Test.2"
--(
--	on execute do messageBox "Voila"
--
--)


/*------------------------------------------------------------------------------

	GET QUAD MENU

--------------------------------------------------------------------------------*/

QuadMenuTest 	= QuadMenu_v ("_Quad Test")


/*------------------------------------------------------------------------------

	ADD MENU TO QUAD MENU

------------------------------------------------------------------------------*/

QuadMenuTest.Quads[1].clearMenu() -- clear menu is not necessary, jsut for test repetion


QuadMenuTest.Quads[1].addMenu ("_Test Menu") flat:true


/*------------------------------------------------------------------------------

	MODIFY QUAD MENU OPTIONS

------------------------------------------------------------------------------*/

QuadMenuTest.showAllQuads()

QuadMenuTest.setRightClick()
--
--QuadMenuTest.resetRightClick()
