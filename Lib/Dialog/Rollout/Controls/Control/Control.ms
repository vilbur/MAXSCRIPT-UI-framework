
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
	
	/* extended control params */ 
	rollout_locals,	-- #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	rollout_function,	-- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	
	/* dependency */
	Events = EventsList_v(),

	private
	
	/** Set id by control caption
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