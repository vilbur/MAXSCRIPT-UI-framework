/** Events default
 */
struct DefaultControlEvents_v
(
	/* properties */
	Events = #(),
	
	/** Add default event for Control
	  *
	  * @return	array of Events	
	 */
	function getEvents _Control =
	(
		--print ("DefaultControlEvents_v.getEvents() "+_Control.type)
		if( _Control.type == #browsePath ) then
			Events = (BrowsePath_v()).getEvents(_Control)
		
		------append Events ( Event_v type:#changed	code:("print \"DEFAULT EVENT\"")  params:"val"  )
			
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
