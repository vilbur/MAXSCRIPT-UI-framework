clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Menu.ms" )

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
--menu_name = "_Test Menu"
--Menu 	= Menu_v()
--Menu 	= (Menu_v(menu_name)).create()

--Menu 	= Menu_v("_Test Menu") #(1,2,3)
Menu.addItem ("context_menu_test") ("_Test") title:"Context Menu Test"
