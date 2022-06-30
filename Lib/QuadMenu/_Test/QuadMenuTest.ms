clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../QuadMenu.ms" )


quad_menu_name = "_Test Quad"


/**  
 *	
 */
macroscript	context_menu_test
category:	"_Test"
buttontext:	"Context Menu Test"
toolTip:	"Context Menu Test"
--toolTip:	"contenxt_menu_test"
icon:	("quad"+quad_menu_name)
(
	--on isVisible return selection.count == 0
	
	on execute do -- !IMPORTANT TO USE
    (
		messageBox "Context Menu Test"
	)
)
  

--QuadMenu 	= QuadMenu_v name:quad_menu_name
QuadMenu 	= QuadMenu_v (quad_menu_name)

--QuadMenu.addMenu "_Test Menu Submenu"
	
--QuadMenu.addItem "_Test Menu Submenu" ("context_menu_test") ("_Test") title:"Context Menu Test"
--
--QuadMenu.setRightClick()
	
--QuadMenu.showAllQuads()

