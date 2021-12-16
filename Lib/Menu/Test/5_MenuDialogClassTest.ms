clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Dialog.ms" )


Dialog	= Dialog_v title:(getFilenameFile(getSourceFileName()))


/* ROLLOUT DEFINITION */

Rollouts_1 = Dialog.rollouts()

Rollout_A	= Rollouts_1.new "Subrollout A"









/** CREATE MENU 
 */

/* DEFINE MAIN MENU */
--Menu = Dialog.Menu

--/* DEFINE MENU */
--menu_1	= Menu.menu "Menu 1"
--menu_2	= Menu.menu "Menu 2"
--
--
--/** MENU ITEMS 
-- */
--menu_1.item "Item 1" "messagebox \"Item 1\"" id:"test_item1"
--
--
--/* DEFINE SUBMENU */
--submenu = menu_1.menu "Submenu"
--submenu.item "Submenu Item 1"  "messagebox \"Submenu Item 1\""
--
--
--/** MENU ITEMS 2
-- */
--menu_2.item "Item 2" "messagebox \"Item 2\""
--menu_2.separator()
--menu_2.item "Item 3" "messagebox \"Item 3\""




/** CREATE ROLLOUT 
 *	
 */
--CreateDialog roll_main menu:(Menu.create()) style:#(#style_border, #style_resizing )




/* CREATE DIALOG */
Dialog.create()	-- create with default params





