/** Events default
 */
struct RolloutEventsDefault_v
(
	/* required */ 
	rollout_id,
	ini_path,
	
	/* properties */ 
	List = #(),
	
	/** Add default callback for event
	  * Default callback function is added in "Rollout_v._addSaveIniFunction()"
	  *
	  * @return	list	of default events
	 */
	function getDefaultEvents rollout_is_subrollout =
	(
		--print ("DefaultEvents_v.getDefaultEvents()")
		--format "ini_path	= % \n" ini_path	
		if( rollout_is_subrollout ) then 
			
			this._setEventsForRollout()
		
		else
		
			this._setEventsForDialog()
			
		List --return
	),

	/** Rollout events
	 */
	function _setEventsForRollout =
	(
		--print "EventsDefault_v._setEventsForRollout()"
		
		if( ini_path != undefined ) then
			this._setRolloutSaveIniEvents()
	),
	
	/** _dialog events
	 */
	function _setEventsForDialog =
	(
		--print "EventsDefault_v._setEventsForDialog()"
		--append List ( Event_v type:#open	code:("GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id+"\")") )
		
		append List ( Event_v type:#open	code:("format \"%\" (\"\n!!! DEFAULT EVENT OPEN\");GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id+"\")") )
		append List ( Event_v type: #moved	code:("format \"%\" (\"\n!!! DEFAULT EVENT MOVED\")") )
		append List ( Event_v type: #resized	code:("format \"%\" (\"\n!!! DEFAULT EVENT RESIZED\")") )

		--if( ini_path != undefined ) then
			--this._setDialogSaveIniEvents()
	),
	
	/** Dialog save ini
	  
	  
		IMPORTANT: #docked probably doesn't work in max 2022
	  
	  
	 */
	function _setDialogSaveIniEvents =
	(
		--print "DefaultEvents_v._setDialogSaveIniEvents()"
		this._setSaveIniDefaultEvent #moved	"moved"	"val"
		this._setSaveIniDefaultEvent #resized	"resized"	"val"
		this._setSaveIniDefaultEvent #docked	"dock_state"	("(try(cui.getDockState "+rollout_id+")catch(\"cui_floatable\"))")
	),
	
	/** Rollout save ini
	 */
	function _setRolloutSaveIniEvents =
	(
		--print "DefaultEvents_v._setRolloutSaveIniEvents()"
		this._setSaveIniDefaultEvent #rolledDown	"rolledUp"	"(val == false)"
		this._setSaveIniDefaultEvent #rolledUp	"rolledUp" 	"(val == false)"
	),
	
	/** Set save to ini default event
	 */
	function _setSaveIniDefaultEvent type key val =
	(
		if_val_not_undefined	= "if( val != undefined ) then " -- on subrollout creation is "rolledUp" fired with undefined value
		
		save_to_ini	= "( setINISetting \""+ini_path+"\" \""+rollout_id+"\" \""+key+"\" ("+val+" as string) )"
		
		append List ( Event_v type:type	code:(if_val_not_undefined + save_to_ini) )
	),
	
	/**  
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
