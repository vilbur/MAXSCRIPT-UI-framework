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
  

QuadMenu 	= QuadMenu_v()

--menu = QuadMenu.getMenu "_New Menu"

--quad = QuadMenu.create "_quadMenuTest" "quad1Name" "quad2Name" "quad3Name" "quad4Name" 
--
--menu = QuadMenu.addItem "_Test Menu" ("context_menu_test") ("_Test") title:"Context Menu Test"


        --quad_sub = quad.getMenu 1; -- bottom right
		
		
quad = menuMan.findQuadMenu "_quadMenuTest"

--format "menu	= % \n" menu	
format "quad	= % \n" quad
--quad_sub.addItem menu 1
--menuMan.createSubMenuItem "_QQQ name" menu
--
--format "quad	= % \n" quad
QuadMenu.setRightClick(quad)

--QuadMenu.resetRightClick()

--format "menu_items	= % \n" menu_items
--
--
--for menu_item in menu_items do 
--	format "menu_item.getTitle()	= % \n" (menu_item.getTitle())

--
-- 
--
----format "menu_items	= % \n" menu_items
--myStringStream = stringStream ""
--macros.list to:myStringStream
--
--seek myStringStream 0
--
--counter	= 0
----lines	= #()
--
--while not eof myStringStream do 
--(
--	line =  readLine myStringStream
--	format "line	= % \n" line
--	--if( line.count > 1 ) then 
--		--append all_macros ( this._trimWhiteSpace(line))
--		
--	counter += 1
--)

--seek myStringStream 0    -- reset position to beginning
--
--close myStringStream -- closes the file
--
--format "all_macros	= % \n" all_macros
