clearListener()

filein ( getFilenamePath(getSourceFileName()) + "/../RcMenu.ms" )
/** CREATE MENU
 */

/* DEFINE MAIN MENU */
Menu = RcMenu_v()

/* DEFINE MENU */
menu_1	= Menu.menu "Menu 1"
menu_2	= Menu.menu "Menu 2"


/** MENU ITEMS
 */
menu_1.item "Item 1" "messagebox \"Item 1\"" id:"test_item1"


/* DEFINE SUBMENU */
submenu = menu_1.menu "Submenu"
submenu.item "Submenu Item 1"  "messagebox \"Submenu Item 1\""


/** MENU ITEMS 2
 */
menu_2.item "Item 2" "messagebox \"Item 2\""
menu_2.separator()
menu_2.item "Item 3" "messagebox \"Item 3\""


/* define rollout for menu */
rollout roll_main "Menu Test"
(
)

/** CREATE ROLLOUT
 *
 */
CreateDialog roll_main menu:(Menu.create()) style:#(#style_border, #style_resizing )