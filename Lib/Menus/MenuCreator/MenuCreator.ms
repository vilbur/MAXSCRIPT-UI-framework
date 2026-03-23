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
	items, -- Dictionary|*.json -- KEY:"Title" VALUE: submenu|"itemCommand()" -- dictionary of items where key is title
	
	/* properties */
	Menu,
	
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

		/* IF ITEMS IS *.json FILE PATH */ 
		if classOf items == string and doesFileExist items then
			items = (JsonToDictionoray_v()).jsonFileToDict items
		
		/*  DEFINE MAIN MENU - RCMENU or SUBMENU */
		Menu = if Submenu != undefined then Submenu else RcMenu_v name:"PresetMenu" search_in_menus:false
		
		/* ADD ITEMS AND SUBMENUS */
		this._addItemsToMenu Menu items	
		
		/*==============================================================================
		  
			RCMENU MUST BE RETURNED
			
		================================================================================*/
		
		Menu.create() --return
	),
	
	private
	
	/** Add items to menu
	 */
	function _addItemsToMenu menu_current menu_items =
	(
		--format "\n"; print "PASSED._addItemsToMenu()"
		
		for title in menu_items.keys do
		(
			item = menu_items[title]
			/*------------------------------------------------------------------------------
				ADD SUBMENU
			--------------------------------------------------------------------------------*/
			if classOf item == Dictionary then
			(
				submenu	= menu_current.menu title

				this._addItemsToMenu submenu item
			)
			/*------------------------------------------------------------------------------
				ADD ITEM
			--------------------------------------------------------------------------------*/
			else if classOf item == string then
				menu_current.item title item 
		)
		
	),
	
	
	on create do
	(
		--print("MenuCreator_v.onCreate()")
	)

)