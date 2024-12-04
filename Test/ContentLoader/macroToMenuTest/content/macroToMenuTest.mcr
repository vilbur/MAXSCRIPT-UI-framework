filein( getFilenamePath(getSourceFileName()) + "/../../../../Lib/Menus/QuadMenuManager/QuadMenuManager.ms" )	--"./../../../../Lib/Menus/QuadMenuManager/QuadMenuManager.ms"


/**
	GENERATE MENUS AND QUAD STREAIGH FROM MACROSCRIPTS

	Category is menu name
	Button text is item title in default

	Title can be also Tooltip, or exactly defined



	 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


				IMPORTANT:
					TO USE 'ON EXECUTE DO' if command is used in menu
			
					Otherwise command can be fired on just activating of the menu


	!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
*/



/*------------------------------------------------------------------------------

	TITLE DEFINITION OF MENU ITEM

--------------------------------------------------------------------------------*

/* ADDED TO MENU AUTOMATICALY BY CATERGORY PRAMATER
*
* TITLE IS BUTTON TEXT
*/
macroscript	_test_menu_title_by_buttontext
category:	"_Test Menu"
buttontext:	"THIS IS MENU ITEM TITLE"
icon:	"MENU:true|across:1|width:256|height:32"
(
	on execute do messageBox "Voila"

)

/* ITEM TITLE IS DEFINED
*/
macroscript	_test_menu_title_defined
category:	"_Test Menu"
buttontext:	"Title defined in parameter"
icon:	"MENU:ITEM TITLE"
(
	on execute do messageBox "Voila"

)

/* ITEM TITLE IS TOOLTIP
*/
macroscript	_test_menu_title_by_tooltip
category:	"_Test Menu"
buttontext:	"This is not menu title"
toolTip:	"TITLE IS TOOLTIP"
icon:	"MENU:tooltip"
(
	on execute do messageBox "Voila"

)



/*------------------------------------------------------------------------------

	MANAGE QUADS BUTTONS

--------------------------------------------------------------------------------*
/* PARSE .mcr files
*/ 
macroscript	_test_menu_quads_macros_to_menu
category:	"_Test Menu"
buttontext:	"MACROS TO MENUS"
icon:	"across:1|width:128|height:48"
(
	on execute do
		(QuadMenuManager_v()).createMenusFromMacroscriptFiles(getFilenamePath(getSourceFileName()))
)

/* SETUP MENUS
*/
macroscript	_test_menu_quads_install
category:	"_Test Menu"
buttontext:	"SETUP MENUS"
(
	on execute do
	(
		(QuadMenuManager_v()).setupMenus(getFilenamePath(getSourceFileName()) + "\\menus-setup")
		
		print "RightClick QUad Menu should be customized"
	)
)

/* RESET MENUS
*/
macroscript	_test_menu_quads_reset
category:	"_Test Menu"
buttontext:	"RESET MENUS"
(
	on execute do
		if queryBox "REST ALL MENUS AND QUADMENUS ?" title:"RESET MENUS" then
			(QuadMenuManager_v()).resetMenusAndHotkeys()
)


/*------------------------------------------------------------------------------

	ADD TO QUAD MENU SEEM TO BE USELESS, IT IS DISABLED

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


