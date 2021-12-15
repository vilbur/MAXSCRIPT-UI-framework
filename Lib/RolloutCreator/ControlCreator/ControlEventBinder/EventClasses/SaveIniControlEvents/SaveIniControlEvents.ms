/** Events default
 */
struct SaveIniControlEvents_v
(
	/* required */
	ini_path,
	rollout_id,

	/* properties */ 
	List = #(),
	
	dynamic_event_types = #( #changed, #selected ), -- this events fires default save to ini callback

	/** Add save ini event for Control
	  *
	  * @return	list	of default events
	 */
	function getEvents _Control =
	(
		format "************************************************************"
		print "SaveIniEvents_v._addDefaultEvents()"
		format "_Control	= % \n" _Control
		format "this	= % \n" this
		
		
		
		List --return

	),

	private
	
	
	/** _add save to ini events
	  *
	  * KNOWING ISSUES:
	  * 	PROBLEM:	 #Multilistbox on single clict sometimes does not save to ini
	  *	SOLUTION:	Use Ctrl key even if seledting only one item 
	  *
	  *
	 */
	function _addDefaultEvents rollout_id =
	(
		--print "SaveIniEvents_v._addDefaultEvents()"
		events_list	= #()

		for event_type in event_types_of_control where findItem dynamic_event_types event_type > 0 do
		(
			--format "event_type	= % \n" event_type
			Event = this._getEvent(event_type)

			Event.code += "\n\t(setINISetting \""+ini_path+"\" \""+rollout_id+"\" \""+_Control.id+"\" (val as string) );\n"

			Event.params	= params_of_events[findItem event_types_of_control event_type]

			append events_list Event
		)

		events_list --return
	),

	/** Dialog save ini

		IMPORTANT: #docked probably doesn't work in max 2022

	 */
	function _getDialogSaveIniEvents =
	(
		--print "SaveIniEvents_v._getDialogSaveIniEvents()"
		--this._setSaveIniDefaultEvent #moved	"moved"	"val"
		--this._setSaveIniDefaultEvent #resized	"resized"	"val"
		--this._setSaveIniDefaultEvent #docked	"dock_state"	("(try(cui.getDockState "+rollout_id+")catch(\"cui_floatable\"))")

		List --return
	),

	/** Rollout save ini
	 */
	function _getRolloutSaveIniEvents =
	(
		--print "SaveIniEvents_v._getRolloutSaveIniEvents()"
		----this._setSaveIniDefaultEvent #rolledDown	"rolledUp"	"(not val)"
		--this._setSaveIniDefaultEvent #rolledUp	"rolledUp" 	"(not val)"

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
		print("SaveIniControlEvents_v.onCreate()")
		--this._checkConstctructProperties()
	)

)