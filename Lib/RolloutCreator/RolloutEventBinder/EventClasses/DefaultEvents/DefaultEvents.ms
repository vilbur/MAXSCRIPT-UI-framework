/** Events default
 */
struct DefaultEvents_v
(
	/* properties */
	List = #(),
	
	/** Add default event for Rollout
	  *
	  * @return	list	of default events
	 */
	function getEvents rollout_id_full =
	(
		--format "\n"; print ("DefaultEvents_v.getEvents()" + rollout_id_full as string )
		
		append List ( Event_v type:#open	code:("GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id_full+"\")") )
			
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
