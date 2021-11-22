
/** EventsBinder
 */
struct EventsCombiner_v
(
	Defaults	= #(),
	Custom	= #(),
	
	--event_types,  -- #( #changed, #rightclick  )
	--event_params, -- #( #(#changed, "val inSpin_arg"), #rightclick  )
	
	/** Get events
	  *
	  * @property	#name	event_type	#pressed|#rightclick|#changed etc.
	  *
	 */
	function combine event_type =
	(
		--print ( "EventsCombiner_v.combine() " + event_type as string )
		Event_default	= this._getEvent	event_type #defaults
		Event	= this._getEvent	event_type #custom
		
		if( Event_default != undefined or Event != undefined ) then
			this._mergeEvents Event_default Event --return
		else
			undefined --return 
	),
	
	
	private
	
	/** Get event
	 */
	function _getEvent event_type custom_or_default =
	(
		--print "EventsCombiner_v.getEvent()"
		Events	= if( custom_or_default == #defaults ) then Defaults else Custom 
		
		(for Event in Events where Event.type == event_type collect Event)[1]
	),

	
	/** Merge default event with user defined event
	  *
	 */
	function _mergeEvents Event_default Event =
	(
		Event_merged 	= Event_v type:(this._getEventProperty Event_default Event #type )
		
		Event_merged.params	= this._getEventProperty	Event_default Event #params
		Event_merged.tooltip	= this._getEventProperty	Event_default Event #tooltip
		Event_merged.code	=(this._getCodeStr	Event_default ) + ( this._getCodeStr Event )

		Event_merged --return
	),
	
	/** Get property from one of defined evets
	 */
	function _getEventProperty Event_default Event key =
	(
		if( Event_default!=undefined ) then
			getProperty Event_default key --return
			
		else
			getProperty Event key --return
	),
	
	/** Get code str
	 */
	function _getCodeStr Event =
	(
		if( Event!=undefined ) then
			"\n" + Event.code
		else
			""
	),

	/**  
	 */
	on create do
	(
		--print("Events_v.onCreate()")
	)
)