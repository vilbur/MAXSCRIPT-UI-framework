--filein( getFilenamePath(getSourceFileName()) + "/Callbacks/fitSubrolloutSlotToRolloutCallback.ms" )	--"./Callbacks/fitSubrolloutSlotToRolloutCallback.ms"
--filein( getFilenamePath(getSourceFileName()) + "/Callbacks/autoRollUpRolloutCallback.ms" )	--"./Callbacks/autoRollUpRolloutCallback.ms"

/** Events default for rollout\dialog
 */
struct DefaultEvents_v
(
	/* properties */
	--Events = #(),
	ini_path,

	/** Add default event for Rollout
	  *
	  * @return	list	of default events
	 */
	function getDialogEvents rollout_id =
	(
		--format "\n"; print ("DefaultEvents_v.getEvents()" + rollout_id as string )

		--/** Append event
		-- */
		--function appendEvent type callback =
		--(
		--	--format "\n"; print "DefaultEvents_v.appendEvent()"
		--	Event =  Event_v type:type
		--
		--	Event.callback = callback
		--
		--	append this.Events Event
		--)
		EventsList = EventsList_v()



		format "\n"; print "DefaultEvents_v.getRolloutEvents() !!!!!!!!!!!!!! DISABLED EVENT"

		/* MOVE CONTROLS TO GROUPBOXES */
		--appendEvent #OPEN "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id+"\")"
		
		--Event =  Event_v type:#OPEN
		--
		--Event.callback = "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id+"\")"
		--
		--append EventsList.list Event


		/* HANDLE WITH #RESIZE|#DOCKED|#UNDOCKED events */
		Event =  Event_v type:#RESIZED

		Event.callback = "waitForResizeEndTimer(#"+rollout_id+")( #resized )"

		append EventsList.list Event


		/* SAVE DIALOG STATE IF INI FILE EXISTS */
		if( ini_path != undefined ) then
		(
			ini_path	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace ini_path "/"

			Event =  Event_v type:#OKTOCLOSE

			Event.callback = "(IniSaver_v ini_file:\""+ini_path+"\").saveRollout(\""+rollout_id+"\")"

			append EventsList.list Event
		)

		EventsList --return
	),
	
	/** Get rollout events
	 */
	function getRolloutEvents _Rollout =
	(
		--format "\n"; print "DefaultEvents_v.getRolloutEvents()"
		EventsList = EventsList_v()
		
		append EventsList.list (this._getAutoRollUpRolloutEvent(_Rollout))
		
		EventsList --return
	),
	
	
	private
	
	/** Get auto roll up rollout event
	 */
	function _getAutoRollUpRolloutEvent _Rollout =
	(
		--format "\n"; print "DefaultEvents_v._getAutoRollUpRolloutEvent()"
		rollout_id_full = _Rollout.getFullId()
		--format "rollout_id_full: %\n" rollout_id_full
		
		rollout_id_full_split	= filterString rollout_id_full "."
	
		params = "( #"+rollout_id_full_split[1]+ ") ( #"+rollout_id_full_split[2]+ ") ( #"+rollout_id_full_split[3]+ ")"
	
		roll_up_other_rollouts_callback = "rollUpOtherRolloutsCallback " + params
		auto_roll_up_rollout_callback   = "autoRollUpRolloutCallback " + params
	
		rollup_others_if_control_pressed = "	if keyboard.controlPressed then\n		"+roll_up_other_rollouts_callback+"\nelse\n		"+auto_roll_up_rollout_callback
	
	
		callback = "if val then\n	(\n	" + rollup_others_if_control_pressed + "\n)"
		
		
		Event_v type:#ROLLEDUP callback:callback --return
	),
	

	/**
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
)