/** Add macroscript to quad menu context menu
 * Context menu name is '.mcr' filename
 *
 *
 * IMPORTANT:
 *		use 'on execute do' otherwise script is executed when quad menu is displayed
 *
 * @param quad:true -- if quad paramater present then add o context menu
 */
macroscript	context_menu_test
category:	"_Test"
buttontext:	"Context Menu Test"
toolTip:	"Context Menu Test"
--toolTip:	"contenxt_menu_test"
icon:	"quad:true"
(
	
	on isVisible return selection.count == 0

	 on execute do -- !IMPORTANT TO USE IN QUAD MENU
    (
		messageBox "Context Menu Test" 
	)
)
  
  
macroscript	context_menu_test_2
category:	"_Test"
buttontext:	"Context Menu Test B"
toolTip:	"Context Menu Test B"
--toolTip:	"contenxt_menu_test"
icon:	"quad:true"
(
	
	on isVisible return selection.count == 0

	 on execute do -- !IMPORTANT TO USE
    (
		messageBox "Context Menu Test B" 
	)
)
  