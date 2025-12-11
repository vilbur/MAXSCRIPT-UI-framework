/** Menu item_v
 */
struct MenuItem_v
(
	id,
	title,
	command,

	enabled = true,
	checked = false,
	
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

		--"\n	menuItem " + id	 + " \"" + title + "\"" --return
		"\n	menuItem " + id	 + " \"" + title + "\" enabled:" + enabled as string + " checked:" + checked as string  --return
	),

	/** Get command definition
	 */
	function _getCommandDefinition =
	(
		if( this.isSeparator() or command == "" ) then
			return ""

		"\n	on "+id+" picked do " + command   --return
	),

	/** Is separator
	 */
	function isSeparator =
	(
		--format "\n"; print "MenuItem_v.isSeparator()"
		title == "separator" --return
	),

	
	private

	
	/** _repleace string
	 */
	function _repleaceCharacters search replace =
	(
		( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( id ) replace  --return
	),

	/** Set id by title if not defined
	 */
	function setId =
	(
		--format "\n\n"; print "MenuItem_v.setId()"
		
		if ( id == undefined or id == unsupplied ) then
			id = toLower title

			id = "item_" + id -- add prefix

			id = substituteString ( trimRight ( trimLeft id )) " " "_" -- replace whitespace with underscore

			id = this._repleaceCharacters "^(\d*[_-]*)" "" -- remove number as first letter, global variable MUST NOT starts with number E.G.: "1_FooDialog|_FooDialog" >>> "FooDialog"

			id = this._repleaceCharacters "[^A-Za-z0-9_]" "_" -- remove invalid characters E.G.: "Butt@n_&_1" >>> "Button_1"

			id = this._repleaceCharacters "[_]+" "_" -- remove multiple underscores E.G.: "button___1" >>> "button_1"

			id = id as name
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
		--id += "_item"
	)
)