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
	function getEvents rollout_is_subrollout =
	(
		--print ("DefaultEvents_v.getDefaultEvents()")
		--format "ini_path	= % \n" ini_path	
		--if( rollout_is_subrollout ) then 
			
			--this._setEventsForRollout()
		
		--else
		
			this._setEventsForDialog()
			
		List --return
	),

	/** Rollout events
	 */
	function _setEventsForRollout =
	(
		--print "EventsDefault_v._setEventsForRollout()"
	),
	
	/** _dialog events
	 */
	function _setEventsForDialog =
	( 
		--print "EventsDefault_v._setEventsForDialog()"
		--append List ( Event_v type:#open	code:("GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id+"\")") )
		
		append List ( Event_v type:#open	code:("format \"%\" (\"\nDEFAULT OPEN\")") )
		append List ( Event_v type:#moved	code:("format \"%\" (\"\nDEFAULT MOVED\")") )
		append List ( Event_v type:#resized	code:("format \"%\" (\"\nDEFAULT RESIZED\")") )
		append List ( Event_v type:#docked	code:("format \"%\" (\"\nDEFAULT DOCKED\")") )
	),
	

	/**  
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
