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
  


QuadMenu 	= QuadMenu_v _name:"_Test Quad"

QuadMenu.setShowAllQuads()


QuadMenu.addMenu "_Test Menu Submenu"
	
QuadMenu.addItem "_Test Menu Submenu" ("context_menu_test") ("_Test") title:"Context Menu Test"

QuadMenu.setRightClick("_quadMenuTest")
	

