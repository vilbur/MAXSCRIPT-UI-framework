
/** Menu item_v
 */
struct MenuItem_v
(
	id,
	title,
	command,
	
	/** Create
	  *
	  * @return string Definition of menu item
	 */
	function create =
	(
		this.setId()
		this._addSuffix()

		if( title=="separator" ) then 
			return "\n	separator sep"+( (random 1 1000000000) as string )
		
		"\n	menuItem " + id + " \"" + title + "\"" --return
	),
	
	/** Get command definition 
	 */
	function _getCommandDefinition =
	(
		if( title=="separator" or command=="" ) then 
			return ""
		
		"\n	on "+id+" picked do " + command   --return
	),
	
	/** Get id
	 */
	function setId =
	(
		if( id=="" ) then
			id = ( dotNetObject "System.Text.RegularExpressions.Regex" @"\s+" ).Replace ( toLower title ) "_"
			
	),
	
	/** Add suffix to menu item
	  *
	  * PREVENT ERRORS when maxscript preserved keyword is used as item name E.G.: "Exit|Return|Rolllout"
	  *
	  *
	 */
	function _addSuffix =
	(
		--print "MenuItem_v._addSuffix()"
		id += "_item"
	)
)