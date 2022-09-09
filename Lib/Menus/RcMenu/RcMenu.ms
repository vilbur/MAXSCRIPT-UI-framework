filein( getFilenamePath(getSourceFileName()) + "/MenuItem.ms" )

/** Menu for rollout
 */
struct RcMenu_v
(
	__construct = #( ),
	
	/* properties */
	name = "MainMenu",
	
	self	= this,
	type	= "RCmenu",
	items	= #(),
	
	/** Submenu
	 */
	function menu _name =
	(
		local _menu =  RcMenu_v name:_name type:"submenu"
		
		this._addItem _menu
		
		_menu --return 
	),

	/** Add item to menu
	  *
	  * @param	string	title	Title of item
	  * @param	string	command	Command of item
	  * @param	string	[id]	Id of item, if empoty, then sanitized title is used
	 */
	function item title command id:"" =
	(
		--print "RcMenu_v.item()"
		this._addItem (MenuItem_v title:(title as string) command:command id:id)
	),

	/** Set separator item
	 */
	function separator =
	(
		this.item "separator" ""
	),

	/** Create menu
	  *
	  * [rcmenu ]](https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_17DBC9E3_5B61_4738_B78B_D3D57A515CE8_htm)
	  *
	  * @return	RcMenu class|string	Return RcMenu for 'CreateDialog menu:RcMenu' or definition of submenu
	 */
	function create =
	(
		--print "RcMenu_v.create()"
		menu_def	= this._getMenuDefinition()
		subitems	= this._getDefinitionsOfMenuItems()
		commands	= this._getAllCommandsDefinitions()
		
		definition = menu_def + "\n(\n" + subitems + commands + "\n)"
		--format "\n\nDefinition = \n% \n" definition
		if( type == "RCmenu" ) then
			(execute definition) -- return if menu
		else
			definition -- return if submenu
	),

	/** Add item
	 */
	function _addItem item =
	(
		append items item
	),

	/** Get menu definition
	 */
	function _getMenuDefinition =
	(
		if( type == "submenu" ) then
			"\nsubMenu \"" + name + "\"" -- return
		else
			"RcMenu " + name -- return
	),
	
	/** Get definitions of items
	 */
	function _getDefinitionsOfMenuItems =
	(
		_definition	= ""
		--format "items.count = % \n" items.count
		for item in items do
			_definition += item.create()
			
		_definition -- return
	),

	/** Get all commands definitions in RcMenu
	 */
	function _getAllCommandsDefinitions =
	(
		commands	= ""
		
		if( type != "submenu" ) then
			commands	= this._getCommandDefinition()
		
		commands -- return
	),

	/** Get commands definition of items in menu
	 */
	function _getCommandDefinition =
	(
		commands	= ""
	
		for item in items do
			commands += item._getCommandDefinition()
			
		commands --return 
	),

	/*------------------------------------------------------------------------------
		CONSTRUCT
	--------------------------------------------------------------------------------*/
	
	/** Check if properties in __construct are defined when an instance of the struct is created.
	  * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("Undefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	
	/**  
	 */
	on create do
	(
		this._checkConstctructProperties()
	)
)