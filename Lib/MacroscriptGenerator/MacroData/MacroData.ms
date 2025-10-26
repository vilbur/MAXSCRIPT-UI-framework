
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
	
	/** Type
	 */
	function type key =
	(
		--format "\n"; print "MacroData_v.type()"		
		type = case of
		(
			( findItem (this.keysParams()) key > 0 ): #PARAMETER
			( findItem (this.keysFilter()) key > 0 ): #FILTER
			( findItem (this.keysCode())   key > 0 ): #CODE
			--default: 
		)
		
		type --return
	),
	
	/** Keys params
	 */
	function keysParams = #( #category, #buttontext, #tooltip, #icon ),
	
	/** Keys filter
	 */
	function keysFilter = #( #IsVisible, #IsChecked, #isEnabled, #isIndeterminate ),
	
	/** Keys code
	 */
	function keysCode = #( #exe, #altExecute ),

	/** Get params
	 */
	function getParams type =
	(
		--format "\n"; print "MacroData_v.getParams()"
		values	= Dictionary #NAME
		
		keys = case type of
		(
			#PARAMETERS:	this.keysParams()
			#FILTERS:	this.keysFilter()
			#CODE:	this.keysCode()
		)
	
		for key in keys \
			where hasProperty this key \
			and (val = getProperty this key) != undefined do
				values[key] = val
		
		values --return
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

