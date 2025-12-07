/** Events default for rollout\dialog
  
	----------------------------------------------------------------------------
		HOW RESIZE AND DOCK EVENTS WORKS
	----------------------------------------------------------------------------
	
	Maxscript fires #RESIZED event when dialog is RESIZED OR DOCKED \ UNDOCKED
	
	  
	1 ) Call waitForResizingEndsTimer() #RESIZE event --"./waitForResizingEndsTimer.ms"
	  
	2) Start timer and wait then user stop resizing rollout --"./Callbacks/fireResizeDockUndockEvents.ms"
	
	3) Call correct rollout event #RESIZE | #DOCKED | #UNDOCKED
	

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
		format "\n"; print ("DefaultEvents_v.getEvents()" + rollout_id as string )

		EventsList = Dictionary()
		
		/*------------------------------------------------------------------------------
			on #OPEN - Move controls to groupboxes
		--------------------------------------------------------------------------------*/
		------appendEvent #OPEN "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id+"\")"
		
		Event =  Event_v type:#OPEN
		
		Event.callback = "GROUPBOXCREATOR.sortControlsToGroupBoxes( "+rollout_id+" )"
		
		EventsList[#OPEN] = #( Event )
		
		
		/*------------------------------------------------------------------------------
			on #RESIZE | #DOCKED | #UNDOCKED -- All these types belongs to #resize event
		--------------------------------------------------------------------------------*/
		
		Event =  Event_v type:#RESIZED
		
		Event.callback = "waitForResizingEndsTimer(#"+rollout_id+")( #resized )" --"./waitForResizingEndsTimer.ms"
		
		EventsList[#RESIZED] = #( Event )
		
		
		/*------------------------------------------------------------------------------
			on #OKTOCLOSE - Save dialog state if ini file exists
		--------------------------------------------------------------------------------*/
		
		if( ini_path != undefined ) then
		(
			ini_path	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace ini_path "/"
		
			Event =  Event_v type:#OKTOCLOSE
		
			Event.callback = "(IniSaver_v ini_file:\""+ini_path+"\").saveRollout(\""+rollout_id+"\")"
		
			--append EventsList.list Event
			EventsList[#OKTOCLOSE] = #( Event )
		)
		
		EventsList --return
	),
	
	/** Get rollout events
	 */
	function getRolloutEvents _Rollout =
	(
		--format "\n"; print "DefaultEvents_v.getRolloutEvents()"
		Event = this._getAutoRollUpRolloutEvent(_Rollout)
		
		EventsList = Dictionary()
		--append EventsList.list (this._getAutoRollUpRolloutEvent(_Rollout))
		EventsList[#ROLLEDUP] = #( Event )
		
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