/** Events default
 */
struct SaveIniEvents_v
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
	function getEvents rollout_is_subrollout =
	(
		--print ("DefaultEvents_v.getDefaultEvents()")
		if( ini_path != undefined ) do
			if( rollout_is_subrollout ) then
	
				this._getRolloutSaveIniEvents()
	
			else
	
				this._getDialogSaveIniEvents()
	),
	
	
	private
	
	/** Dialog save ini

		IMPORTANT: #docked probably doesn't work in max 2022
	 
	 */
	function _getDialogSaveIniEvents =
	(
		print "DefaultEvents_v._getDialogSaveIniEvents()"
		this._setSaveIniDefaultEvent #moved	"moved"	"val"
		this._setSaveIniDefaultEvent #resized	"resized"	"val"
		this._setSaveIniDefaultEvent #docked	"dock_state"	("(try(cui.getDockState "+rollout_id+")catch(\"cui_floatable\"))")
		
		List --return
	),

	/** Rollout save ini
	 */
	function _getRolloutSaveIniEvents =
	(
		print "DefaultEvents_v._getRolloutSaveIniEvents()"
		this._setSaveIniDefaultEvent #rolledDown	"rolledUp"	"(not val)"
		this._setSaveIniDefaultEvent #rolledUp	"rolledUp" 	"(not val)"
		
		List --return
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
