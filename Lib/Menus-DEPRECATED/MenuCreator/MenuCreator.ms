
/** Menu creator
 */
struct MenuCreator_v
(
	/* construct */
	items, -- Dictionary|*.json -- KEY:"Title" VALUE: submenu|"itemCommand()" -- dictionary of items where key is title
	popup = false,
	
	/* required */
	
	/* properties */
	Menu,
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Create
	 */
	function create =
	(
		format "\n"; print "MenuCreator_v.create()"
		format "this.Menu: %\n" this.Menu
		this.Menu.create()
		--unsupplied
	),
	--
	--/** Popup
	-- */
	--function popup =
	--(
	--	--format "\n"; print "MenuCreator_v.popup()"
	--	this.Menu.popup()
	--),
	
	/** generateMenu menu
	  
	   @param RolloutClass Menu if defined then menu is created as submenu
	 */
	function generateMenu =
	(
		format "\n"; print "MenuCreator_v.generateMenu()"
		format "items: %\n" items
		format "classOf items: %\n" (classOf items)
		format "doesFileExist items: %\n" (doesFileExist items)

		/*------------------------------------------------------------------------------
		
			GET *.json FILE
		
		--------------------------------------------------------------------------------*/		
		if classOf items == string and doesFileExist items then
			items = (JsonToDictionoray_v()).jsonFileToDict this.items
		
		
		/*------------------------------------------------------------------------------
		
			DEFINE MAIN MENU - RCMENU or SUBMENU
		
		--------------------------------------------------------------------------------*/
		if this.Menu == undefined then 
			this.Menu = RcMenu_v name:"MenuByMenuCreator" search_in_menus:false
		--this.Menu = if Submenu != undefined then Submenu else
		
		/*------------------------------------------------------------------------------
		
			ADD ITEMS AND SUBMENUS
		
		--------------------------------------------------------------------------------*/
		this._addItemsToMenu this.Menu items	
 		
		
		/*------------------------------------------------------------------------------
		
			CREATE MENU IN DIALOG
		
		----------------------------------------------------------------------------------*/
		--if Dialog != undefined then 
		--	this.Menu.create() --return
		--
		--/*------------------------------------------------------------------------------
		--	POPUP MENU WHEN MENU IS CREATED BY CALLBACK OF CONTROL 
		--
		----------------------------------------------------------------------------------*/
		--else if EventFired != undefined and Submenu == undefined then 
		--	this.Menu.popup() --return
		--
		--else
		--	this.Menu --return
				
		--Menu.create() --return
		this.Menu --return
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
		print("MenuCreator_v.onCreate()")
		if items != undefined then 
			this.generateMenu()
		
		if popup then
			this.Menu.popup()
	)

)