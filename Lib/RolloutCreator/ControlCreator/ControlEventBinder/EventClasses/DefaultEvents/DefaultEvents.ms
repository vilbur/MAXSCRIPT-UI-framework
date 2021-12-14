/** Events default
 */
struct DefaultEvents_v
(
	/* properties */
	List = #(),
	
	/** Add default callback for event
	  * Default callback function is added in "Rollout_v._addSaveIniFunction()"
	  *
	  * @return	list	of default events
	 */
	function getEvents rollout_id_full =
	(
		--append List ( Event_v type:#open	code:("GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id_full+"\")") )
			
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
