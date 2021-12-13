/** Dialog menu
 */
struct DialogMenu_v
(
	__construct = #(  ),
	
	/* required */
	/* dependency */
	Dialog,
	
	/* reference */
	/* properties */
	
	Menu	= Menu_v(),

	
	
	/** Create
	 */
	function create =
	(
		--print "DialogMenu_v.create()"

		--/* DEFINE MENU */
		--menu_1	= Menu.menu Dialog.title
		--menu_2	= Menu.menu "Menu 2"
		--
		--
		--/** MENU ITEMS 
		-- */
		--menu_1.item "Item 1" "messagebox \"Item 1\"" id:"test_item1"
		--
		--
		--/* DEFINE SUBMENU */
		--Submenu = menu_1.menu "Submenu"
		--Submenu.item "Submenu Item 1"  "messagebox \"Submenu Item 1\""
		--
		--
		--/** MENU ITEMS 2
		-- */
		--menu_2.item "Item 2" "messagebox \"Item 2\""
		--menu_2.separator()
		--menu_2.item "Item 3" "messagebox \"Item 3\""
		
		--Main_Menu	= Menu.menu Dialog.title
		Main_Menu	= Menu.menu "Menu"
		
			DockMenu = Main_Menu.menu "Dock"
	
			DockMenu.item "Left"	(this.accessDialog method:#dockLeft)
			DockMenu.item "Right"	(this.accessDialog method:#dockRight)
			DockMenu.item "Undock"	(this.accessDialog method:#undock)

		
		Main_Menu.item "Exit" (this.accessDialog method:#destroy)
		--Main_Menu.item #Exit "messageBox \"Item 3\""

		
		Menu.create()
		
	),
	
	/** Main menu
	 */
	function setMainMenu =
	(
		--print "DialogMenu_v.setMainMenu()"

		--format "Dialog.title	= % \n" Dialog.title
		

		--menu_1.item "Exit" "try( execute(\"DestroyDialog "+Dialog.id+"\") )catch()" id:"test_item1"

	),
	
	/** Get dialog
	 */
	function accessDialog method: =
	(
		"execute(\"(DIALOG_GLOBALS.get(#"+(Dialog.RolloutMain.id)+"))."+ method as string +"()\")"
	),
	
	/** Wrap string
	 */
	function wrap _string =
	(
		""+_string+"" --return
	),
	

	private
	
	/** Get\set value of property 
	 * @param	string|name key	Name  of property E.G.: "foo_key" OR #foo_key 
	 * @param	string|#get value	Value of property
	 *
	 * @return	string|self Value or self
	 *
	 * @example this._getSetProp "foo" "bar" -- SET "bar" to property "foo"
	 * @example this._getSetProp #foo  #get  -- GET value of property "foo"
	 */
	function _getSetProp key value =
	(
		if( value != #get ) then
		(
			if( value != undefined ) then
				setProperty  this ( key as string ) value
			this --return
		) else
			getProperty this ( key as string ) --return
	),
	
	/** Check if required properties are defined when an instance of the struct is created.
	 *	
	 * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("DialogMenu\nUndefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	/**  
	 */
	on create do
	(
		--print("DialogMenu_v.onCreate()")
		this._checkConstctructProperties()
	)
	
)
