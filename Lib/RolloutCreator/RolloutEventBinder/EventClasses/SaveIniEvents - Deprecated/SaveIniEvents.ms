/** Events default
  
  
  
  
  DELETE THIS STRUCT
  
  
  
  
  
  
  
  
  
  
 */
struct SaveIniEvents_v
(
	/* required */ 
	rollout_id,
	ini_path,

	/* properties */ 
	Events = #(),

	/** Add save ini events for Rollout
	  *
	  * @return	list	of default events
	 */
	function getEvents parent_rollout =
	(
		--print ("SaveIniEvents_v.getDefaultEvents()")
		if( ini_path != undefined ) do
			if( parent_rollout != undefined ) then
	
				this._getRolloutSaveIniEvents() -- return 
	
			else
	
				this._getDialogSaveIniEvents() -- return 
	),

	private

	/** Dialog save ini

	 */
	function _getDialogSaveIniEvents =
	(
		--print "SaveIniEvents_v._getDialogSaveIniEvents()"

		--this._setSaveIniDefaultEvent #moved	"moved"	"val"
		--this._setSaveIniDefaultEvent #resized	"resized"	"val"
		
		this._setSaveIniDefaultEvent #close	"position"	("(GetDialogPos "+rollout_id+")")
		this._setSaveIniDefaultEvent #close	"dock_state"	("(try(cui.getDockState "+rollout_id+")catch(\"cui_floatable\"))")
		
		Events --return
	),

	/** Rollout save ini
	 */
	function _getRolloutSaveIniEvents =
	(
		--print "SaveIniEvents_v._getRolloutSaveIniEvents()"
		this._setSaveIniDefaultEvent #rolledDown	"rolledUp"	"(not val)"
		this._setSaveIniDefaultEvent #rolledUp	"rolledUp" 	"(not val)"

		Events --return
	),

	/** Set save to ini default event
	 */
	function _setSaveIniDefaultEvent type key val =
	(
		------if_val_not_undefined	= "if( val != undefined ) then " -- on subrollout creation is "rolledUp" fired with undefined value
		------EVENT =   ( Event_v type:type	code:(if_val_not_undefined + save_to_ini) )

		save_to_ini	= "( setINISetting \""+ini_path+"\" \""+rollout_id+"\" \""+key+"\" ("+val+" as string) )"

		append Events ( Event_v type:type	code:save_to_ini )
	),

	/**  
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)

)