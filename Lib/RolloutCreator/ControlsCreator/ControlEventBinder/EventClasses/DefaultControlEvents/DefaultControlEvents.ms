/** Events default
 */
struct DefaultControlEvents_v
(
	/* properties */
	Events = #(),
	
	/** Add default event for Control
	  *
	 */
	function getEvents control_type =
	(
		--append Events ( Event_v type:#pressed	code:("print \"DEFAULT EVENT\"") )
			
		Events --return
	),

	/**  
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
