/* 
Struct MacroData_v macro related data from given arrays.
*/
struct MacroData_v
(
	/* name of maxscript  */ 
    name,  -- 
    
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
    --execute,
    exe,
    altExecute,
	
	/** Set prop
	 */
	function setProp key val =
	(
		--format "\n"; print "MacroData_v.setProp()"
		--format "%: %\n" key val
		 --key = this._getKey key
		
		if hasProperty this ( key = this._getKey key ) then
			setProperty this key val
			
		--format "key: %\n" key
	),

	/** Get prop
	 */
	function getProp key =
	(
		--format "\n"; print "MacroData_v.getProp()"
		if hasProperty this ( key = this._getKey key ) then
			getProperty this key
	),
	
	/** Get key
	 */
	function _getKey key =
	(
		--format "\n"; print "MacroData_v._getKey()"
		--format "key: %\n" key
		--format "classOf key: %\n" ( classOf key )
	--	case (key as name ) of
	--	(
	--		#MACROSCRIPT:	"name"
	--		#EXECUTE:	"exe"
	--		#buttontext:	"text"
	--		default: key as string
	--	)
	
		case toUpper(key as string ) of
		(
			"MACROSCRIPT":	"name"
			"EXECUTE":	"exe"
			--"BUTTONTEXT":	"text"
			default: key as string
		)
	
	),
	
    /* 
    on create initializes all properties as undefined 
    */
    on create do
    (
        --category          = undefined
        --buttontext        = undefined
        --tooltip           = undefined
        --icon              = undefined
        --
        --IsVisible         = undefined
        --IsChecked         = undefined
        --isEnabled         = undefined
        --isIndeterminate   = undefined
        --
        --execute           = undefined
        --altExecute        = undefined
    )
)

--/* test code */
--macro_data = MacroData_v()
--macro_data.category = "My Tools"
--macro_data.buttontext = "Execute Tool"
--macro_data.tooltip = "Runs the selected macro"
--macro_data.icon = "MyIcon.bmp"
--
--macro_data.IsVisible = true
--macro_data.IsChecked = false
--macro_data.isEnabled = true
--macro_data.isIndeterminate = false
--
--macro_data.execute = (messageBox "Macro Executed")
--macro_data.altExecute = (messageBox "Alternate Execution")
