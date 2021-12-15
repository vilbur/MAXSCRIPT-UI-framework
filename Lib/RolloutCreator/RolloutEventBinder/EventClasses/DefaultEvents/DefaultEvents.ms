/** Events default for rollout
 */
struct DefaultEvents_v
(
	/* properties */
	Events = #(),
	
	/** Add default event for Rollout
	  *
	  * @return	list	of default events
	 */
	function getEvents rollout_id_full =
	(
		--format "\n"; print ("DefaultEvents_v.getEvents()" + rollout_id_full as string )
		
		append Events ( Event_v type:#open	code:("GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id_full+"\")") )
			
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