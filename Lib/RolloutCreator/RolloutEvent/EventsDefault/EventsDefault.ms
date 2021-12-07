/** Events default
 */
struct EventsDefault_v
(
	/* required */ 
	rollout_id,
	ini_path,
	
	/* properties */ 
	list = #(),
	
	/** Add default callback for event
	  * Default callback function is added in "Rollout_v._addSaveIniFunction()"
	  *
	 */
	function getDefaultEvents rollout_is_subrollout =
	(
		--print ("DefaultEvents_v.getDefaultEvents()")
		--format "ini_path	= % \n" ini_path	
		if( rollout_is_subrollout ) then 
			
			this._rolloutEvents()
		
		else
			this._dialogEvents()
			
		list --return
	),
	
	/** _dialog events
	 */
	function _dialogEvents =
	(
		--print "EventsDefault_v._dialogEvents()"
		append list ( Event_v type:#open	code:("GroupBoxCreator.sortControlsToGroupBoxes(\""+rollout_id+"\")") )
		
		if( ini_path != undefined ) then
			this._dialogSaveIni()
	),
	
	/** Rollout events
	 */
	function _rolloutEvents =
	(
		--print "EventsDefault_v.rolloutEvents()"
		
		if( ini_path != undefined ) then
			this._rolloutSaveIni()
	),
	/** Dialog save ini
	  
	  
		IMPORTANT: #docked probably doesn't work in max 2022
	  
	  
	 */
	function _dialogSaveIni =
	(
		--print "DefaultEvents_v._dialogSaveIni()"
		this._setSaveIniDefaultEvent #moved	"moved"	"val"
		this._setSaveIniDefaultEvent #resized	"resized"	"val"
		this._setSaveIniDefaultEvent #docked	"dock_state"	("(try(cui.getDockState "+rollout_id+")catch(\"cui_floatable\"))")
	),
	
	/** Rollout save ini
	 */
	function _rolloutSaveIni =
	(
		--print "DefaultEvents_v._rolloutSaveIni()"
		this._setSaveIniDefaultEvent #rolledDown	"rolledUp"	"(val == false)"
		this._setSaveIniDefaultEvent #rolledUp	"rolledUp" 	"(val == false)"
	),
	
	/** Set save to ini default event
	 */
	function _setSaveIniDefaultEvent type key val =
	(
		if_val_not_undefined	= "if( val != undefined ) then " -- on subrollout creation is "rolledUp" fired with undefined value
		
		save_to_ini	= "( setINISetting \""+ini_path+"\" \""+rollout_id+"\" \""+key+"\" ("+val+" as string) )"
		
		append list ( Event_v type:type	code:(if_val_not_undefined + save_to_ini) )
	),
	
	/**  
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
