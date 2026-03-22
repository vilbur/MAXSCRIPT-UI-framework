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
	/* construct */
	Dialog, -- REQUIRED FOR ROLLOUT MENU -- Dialog_v --"./../../../Dialog/Dialog.ms"
	
	/* required */
	items	= Dictionary(), -- KEY:"Title" VALUE: Dictionary|"itemCommand()" -- dictionary of items where key is title
	
	/* properties */
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/*==============================================================================
		
		CREATE METHOD MUST EXISTS
		
	================================================================================*/
	/** Create menu
	  
	   @param RolloutClass Menu if defined then menu is created as submenu
	 */
	function create Submenu:undefined =
	(
		format "\n"; print "MenuCreator_v.create()"

		/*  DEFINE MAIN MENU - RCMENU or SUBMENU */
		Menu = if Submenu != undefined then Submenu else RcMenu_v name:"PresetMenu"
		
		/* DEFINE MENU */
		menu_1	= Menu.menu "Dialog Menu"
		
		/** MENU ITEMS */
		--menu_1.item ("SHOW PATH TO INI FILE" ) ("messagebox \""+Dialog.ini.getPath() +"\" title:\"PATH TO INI FILE\"")
		menu_1.item ("SHOW PATH TO INI FILE" ) ("messagebox \"TEST\"")
		
		/*==============================================================================
		  
			RCMENU MUST BE RETURNED
			
		================================================================================*/
		
		Menu.create() --return
	),
	
	private
	
	on create do
	(
		--print("MenuCreator_v.onCreate()")
	)

)