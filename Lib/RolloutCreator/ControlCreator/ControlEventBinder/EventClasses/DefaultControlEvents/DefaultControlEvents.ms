/** Events default
 */
struct DefaultControlEvents_v
(
	/* properties */
	List = #(),
	
	/** Add default event for Control
	  *
	 */
	function getEvents control_type =
	(
		append List ( Event_v type:#pressed	code:("print \"DEFAULT EVENT\"") )
			
		List --return
	),

	/**  
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
