clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/*==============================================================================

	TO CREATE MENU CAN BE ANY STRUCT PASSED AS PARAMETER TO Dialog.create menu:
	
	Use case is to postpone menu creation into Dialog_v
	
	WHILE:
		1) menu HAS DEFINED METHOD: "create()" 
		2) RETURNS classof RCMenu -- https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-17DBC9E3-5B61-4738-B78B-D3D57A515CE8
	
	
	METHOD "create()" IS FIRED IN:
		"Dialog_v._createMenu() -> Menu.create()"  -- "./../../Lib/Dialog/Dialog.ms"

================================================================================*/

/** Menu creator
 */
struct MenuCreator_v
(
	Dialog,
	/*==============================================================================
		
		CREATE METHOD MUST EXISTS
		
	================================================================================*/
	function create =
	(
		format "\n"; print "MenuCreator_v.create()"
		
		/* DEFINE MAIN MENU */
		Menu = RcMenu_v name:"TestMenu"
		
		/* DEFINE MENU */
		menu_1	= Menu.menu "Dialog Menu"
		
		/** MENU ITEMS */
		menu_1.item ("SHOW PATH TO INI FILE" ) ("messagebox \""+Dialog.ini.getPath() +"\" title:\"PATH TO INI FILE\"")
		
		/*==============================================================================
		  
			RCMENU MUST BE RETURNED
			
		================================================================================*/
		
		Menu.create() --return
	)

)


/** DIALOG
 */
Dialog 	= Dialog_v title:"Test" ini:(getSourceFileName())

/*------------------------------------------------------------------------------

	CREATE DIALOG WITH MENU CREATOR

--------------------------------------------------------------------------------*/


Dialog.create menu:(MenuCreator_v(Dialog))	-- pass struct RCMenu   
