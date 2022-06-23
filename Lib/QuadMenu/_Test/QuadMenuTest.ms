clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu.ms" )


/**  
 *	
 */
macroscript	context_menu_test
category:	"_Test"
buttontext:	"Context Menu Test"
toolTip:	"Context Menu Test"
--toolTip:	"contenxt_menu_test"
--icon:	"#(path, index)"
(
	
	on isVisible return selection.count == 0
	
	on execute do -- !IMPORTANT TO USE
    (
		messageBox "Context Menu Test"
	)
)
  

/** Createmenu
 */
function createmenu =
(
	--format "\n"; print ".createmenu()"
	QuadMenu 	= QuadMenu_v()

	----menu = QuadMenu.getMenu "_New Menu"
	
	quad = QuadMenu.create "_quadMenuTest" "quad1Name" "quad2Name" "quad3Name" "quad4Name" 
	
	menu = QuadMenu.addItem "_Test Menu" ("context_menu_test") ("_Test") title:"Context Menu Test"
	------
	------
	------        ----quad_sub = quad.getMenu 1; -- bottom right
	------		
	------		
	--------quad = menuMan.findQuadMenu "_quadMenuTest"
	
	format "quad	= % \n" quad
	
	QuadMenu.setRightClick("_quadMenuTest")

)

/** Modify menu
 */
function modifyMenu =
(
	--format "\n"; print ".modifyMenu()"
	
	quad_menu = menuMan.findQuadMenu "_quadMenuTest"
	
	menuMan.setShowAllQuads quad_menu true
	
	format "quad_menu	= % \n" quad_menu
	
	quad_sub = quad_menu.getMenu 2; -- bottom right
	--quad_sub_2 = quad_menu.getMenu 2
	format "quad_sub	= % \n" quad_sub
	
	--item = quad_sub.getItem 1
	--quad_sub_2.addItem item 1
	
	--format "item	= % \n" item
	
	--format "item.getTitle()	= % \n" (item.getTitle())
	
	menu = menuMan.findMenu "_Test Menu"
	menu_item = menuMan.createSubMenuItem "_Test Menu Submenu" menu
	format "menu	= % \n" menu
	quad_sub.addItem menu_item 1
	


)


--createmenu()
modifyMenu()