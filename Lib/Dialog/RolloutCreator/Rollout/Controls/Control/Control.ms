
/** Control
 */
struct Control_v
(
	__construct = #(  ),
	
	/* required */
	type,
	caption,
	
	/* properties */
	id,
	params,
	/* reference */
	
	/* dependency */
	Events = Events_v(),

	private
	
	/** _get id by caption
	 */
	function _setIdByCaption =
	(
		id = substituteString caption " " "_" -- replace whitespace with underscore

		this._repleaceCharacters "[^A-Za-z0-9_]+"	""	-- remove characters	E.G.: "Butt@n_&_1" >>> "Button_1"
		this._repleaceCharacters "[_]+"	"_"	-- remove underscores	E.G.: "button___1" >>> "button_1"
		
		id = toUpper ( type as string ) + "_" + id -- add prefix by control type E.G.: "test" >>> "BUTTON_test"
	),

	
    
	/** _repleace string
	 */
	function _repleaceCharacters search replace =
	(
		id = ( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( id ) replace  --return 
	),
	
	/**  
	 */
	on create do
	(
		if( id == undefined ) then
			this._setIdByCaption()
	)
)