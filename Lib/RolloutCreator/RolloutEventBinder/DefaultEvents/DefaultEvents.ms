/** Events default for rollout
 */
struct DefaultEvents_v
(
	/* properties */
	Events = #(),
	ini_path,
	
	/** Add default event for Rollout
	  *
	  * @return	list	of default events
	 */
	function getEvents rollout_id_full =
	(
		--format "\n"; print ("DefaultEvents_v.getEvents()" + rollout_id_full as string )
		--format "rollout_id_full	= % \n" rollout_id_full
		append Events ( Event_v type:#open	code:("GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id_full+"\")") )
		
		--append Events ( Event_v type:#okToClose	code:("print(\"okToClose "+rollout_id_full+"\"); true") )
		
		if( ini_path != undefined ) then 
			append Events ( Event_v type:#okToClose	code:("(IniSaver_v ini_file:\""+ini_path+"\").saveRollout(\""+rollout_id_full+"\")") )
		
		
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