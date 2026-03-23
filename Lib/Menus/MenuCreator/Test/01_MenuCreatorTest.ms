clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/Dialog.ms" )	--"./../../../Dialog/Dialog.ms"

menu_items_json = ( getFilenamePath(getSourceFileName()) + "menu_items.json" )	--"./menu_items.json"

/*==============================================================================

	ISOLATED TEST

================================================================================*/
--MenuCreator = MenuCreator_v items:menu_items_json
--
--MenuCreator.create()

/*------------------------------------------------------------------------------
	DEFINE DIALOG
--------------------------------------------------------------------------------*/

Dialog = Dialog_v title:"Test"

_Controls   = Dialog.Controls()


/*==============================================================================
  
	OPEN AS POPUP ON CALLBACK OF ANY CONTROL WHICH FIRES EventFired
	
================================================================================*/
_Button = _Controls.control #BUTTON "RC Menu Test" across:1 width:64

_Button.Event #Pressed ( "MenuCreator_v items:@"+menu_items_json + "@ popup:true" )

--_Controls.control #CHECKBOX "Checkbox"

/*==============================================================================

	OPEN AS ROLLOUT MENU

================================================================================*/
--Dialog.create()
--Dialog.create menu:( MenuCreator_v items:menu_items_json )	-- pass struct RCMenu   


/*==============================================================================
	
	ADD AS SUBMENU
	
================================================================================*/


/* DEFINE RC MAIN MENU */
SubMenuTest = RcMenu_v name:"TestMenu" search_in_menus:false

/* DEFINE MENU */
menu_1	= SubMenuTest.menu "Menu 1"
menu_1.item "Item 1" "messagebox \"Item 1\"" 

/*  */
Dialog.create menu:( MenuCreator_v items:menu_items_json Menu:SubMenuTest )	-- pass struct RCMenu   

