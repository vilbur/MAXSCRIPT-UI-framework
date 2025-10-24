/* 
Struct MacroData_v macro related data from given arrays.
*/
struct MacroData_v
(
	/* name of maxscript  */ 
    name,
    
	/* category and ui params */
    category,
    buttontext,
    tooltip,
    icon,

    /* ui state filters */
    IsVisible,
    IsChecked,
    isEnabled,
    isIndeterminate,

    /* code handlers */
    exe,
    altExecute,
	
	/** Set prop
	 */
	function setProp key val =
	(
		--format "\n"; print "MacroData_v.setProp()"
		
		if hasProperty this ( key = this._getKey key ) then
			setProperty this key val
	),

	/** Get prop
	 */
	function getProp key =
	(
		--format "\n"; print "MacroData_v.getProp()"
		if hasProperty this ( key = this._getKey key ) then
			getProperty this key
	),
	
	/** Get property name
	  
	    "maxscript" & "execute" are preserved keywords
	 */
	function _getKey key =
	(
		--format "\n"; print "MacroData_v._getKey()"
	
		case toUpper(key as string ) of
		(
			"MACROSCRIPT":	"name"
			"EXECUTE":	"exe"

			default: key as string
		)
	),
	
    /* 
    on create initializes all properties as undefined 
    */
    on create do
    (
    )
)

