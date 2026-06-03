clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"

try( DestroyDialog rollout_test )catch()

/* DEFINE MAIN MENU */
Menu = RcMenu_v name:"TestMenu"

/* DEFINE MENU */
menu_1	= Menu.menu "Menu 1"
menu_2	= Menu.menu "Menu 2"


/** MENU ITEMS 
-- */
menu_1.item "Item 1" "messagebox \"Item 1\"" 
menu_1.item "Exit" "try( execute(\"DestroyDialog rollout_test\") )catch()" 



/* DEFINE SUBMENU */
submenu = menu_1.menu "Submenu"
submenu.item "Submenu Item 1"  "messagebox \"Submenu Item 1\""


/** MENU ITEMS 2
 */
menu_2.item "Item 2" "messagebox \"Item 2\""
menu_2.separator()
menu_2.item "Item 3" "messagebox \"Item 3\""


/* define rollout for menu */
rollout rollout_test "Menu Test"
(
)


/** CREATE ROLLOUT 
 *	
 */
CreateDialog rollout_test menu:(Menu.create())