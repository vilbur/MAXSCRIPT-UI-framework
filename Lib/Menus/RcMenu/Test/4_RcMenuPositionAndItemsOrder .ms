clearListener(); print("Cleared in: "+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"

/** Add menu items
 */
function addMenuItems &menu prefix: items_count:3 =
(
	--format "\n"; print ".addMenuItems()"
	
	for i = 1 to items_count do
	(
		title = "Item " + i as string  
		
		if prefix != unsupplied then
			title = prefix + " " + title
		
		menu.item title "messagebox \"Item\""
	)

	menu --return
)

max_window_center = getMAXWindowPos() + (getMAXWindowSize () / 2 )

/*------------------------------------------------------------------------------
	DEFINE MENU
--------------------------------------------------------------------------------*/

/* DEFINE MAIN MENU */
Menu = RcMenu_v name:"TestMenu"


/* MAIN MENU ITEMS */ 
--addMenuItems Menu prefix:"Main" items_count:1


/* SUBMENUS */
menu_1	= Menu.menu "Menu 1"
menu_2	= Menu.menu "Menu 2"
menu_3	= Menu.menu "Menu 3"
menu_4	= Menu.menu "Menu 4"


/* SUBMENUS ITEMS */
addMenuItems menu_1 prefix:"Submenu 1" items_count:2
addMenuItems menu_2 prefix:"Submenu 2" items_count:2
addMenuItems menu_3 prefix:"Submenu 3" items_count:3
addMenuItems menu_4 prefix:"Submenu 4" items_count:5


/*------------------------------------------------------------------------------
	RUNT TESTS
--------------------------------------------------------------------------------*/

/* POP UP MENU ON MOUSE POS */ 
--Menu.popUp()

/* RIGHT BOTTOM corner of 3Ds Max window */ 
--Menu.popUp pos:( getMAXWindowPos() + getMAXWindowSize () )

/* CENTER OF 3Ds Max window */ 
--Menu.popUp pos:( max_window_center )


/* CENTER OF 3Ds Max window */ 

--Menu.popUp pos:[ max_window_center.x, 0 ]


/* TEST OF REVERSED ORDER OF ITEMS
   
   BOTTOM OF SCREEN WHERE MAX WINDOW IS
*/ 

Menu.popUp pos:[ max_window_center.x, sysInfo.desktopSize.y ] -- center of 3Ds Max window

