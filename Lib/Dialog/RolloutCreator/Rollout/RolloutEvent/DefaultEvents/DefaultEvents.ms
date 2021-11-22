/** Default events
 */
struct DefaultEvents_v
(
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	
	
	/** Add default callback for event
	  * Default callback function is added in "Rollout_v._addSaveIniFunction()"
	  *
	 */
	function setSaveToIniEvents =
	(
		print ("DefaultEvents_v.setSaveToIniEvents()")

		--if( Parent_roll._isParentRoll() ) then 
		--	this._dialogSaveIni()
		--
		--else
		--	this._rolloutSaveIni()
	),
	
	/** Dialog save ini
	 */
	function _dialogSaveIni =
	(
		--print "DefaultEvents_v._dialogSaveIni()"
		this._setSaveIniDefaultEvent #moved	"moved"	"val"
		this._setSaveIniDefaultEvent #resized	"resized"	"val"
		this._setSaveIniDefaultEvent #docked	"dock_state"	("(try(cui.getDockState "+Parent_roll.id+")catch(\"cui_floatable\"))")
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
		
		save_to_ini	= "( setINISetting \""+(Parent_roll.ini #get)+"\" \""+Parent_roll.id+"\" \""+key+"\" ("+val+" as string) )"
		
		this.Events.setDefaultEvent ( Event_v type:type	code:(if_val_not_undefined + save_to_ini) )
	),

	private
	
	/**  
	 */
	on create do
	(
		--print("DefaultEvents_v.onCreate()")
	)
	
)
