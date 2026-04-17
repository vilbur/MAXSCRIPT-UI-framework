/** Events default for rollout\dialog
  
	----------------------------------------------------------------------------
		HOW RESIZE AND DOCK EVENTS WORKS
	----------------------------------------------------------------------------
	
	Maxscript fires #RESIZED event when dialog is RESIZED OR DOCKED \ UNDOCKED
	
	  
	1) Call waitForResizingEndsTimer() #RESIZE event --"./waitForResizingEndsTimer.ms"
	  
	2) Start timer and wait then user stop resizing rollout --"./Callbacks/waitForResizingEnds.ms"
	
	3) Call correct rollout event #RESIZE | #DOCKED | #UNDOCKED
	

 */ 
struct RolloutDefaultEvents_v -- MAYBE RENAME THIS TO RolloutRolloutDefaultEvents_v FOR BETTER IDENTIFICATION
(
	/* properties */
	--Events = #(),
	ini_path,

	/*==============================================================================
	
		GET DIALOG EVENTS
	
		@return	list	of rollout default events

	================================================================================*/
	function getDialogEvents rollout_id =
	(
		--format "\n"; print ("RolloutDefaultEvents_v.getDialogEvents(" + rollout_id as string +")")

		EventsList = Dictionary()
		
		
		/*--------------------------------------------------------------------------------------------------------------------------------------
		  
			on #OPEN - Move controls to groupboxes
			
		----------------------------------------------------------------------------------------------------------------------------------------*/
		
		Event =  Event_v type:#OPEN
		
		Event.callback = ""
		--Event.callback += "\nformat \"TEST EVENT: #OPEN  Rollout: "+ rollout_id as name +"\n\";\n" + Event.callback
		
		Event.callback += "\n"+rollout_id+".visible = true\n\n"
		
		Event.callback += "GROUPBOXCREATOR.sortControlsToGroupBoxes( "+rollout_id+" )"
		
		--Event.callback += "\nformat \"ON OPEN Rollout.visible: %\""+ rollout_id +".visible\n;\n" + Event.callback
		
		EventsList[#OPEN] = #( Event )
		
		
		
		/*--------------------------------------------------------------------------------------------------------------------------------------
		  
			on #RESIZE - start timer to check size and wait for resizing ends, then fires callbacks
			
		----------------------------------------------------------------------------------------------------------------------------------------*/
		
		Event =  Event_v type:#RESIZED
		
		Event.callback = "waitForResizingEndsTimer(#"+rollout_id+")" --"./waitForResizingEndsTimer.ms"
		
		EventsList[#RESIZED] = #( Event )
		
		
		
		/*--------------------------------------------------------------------------------------------------------------------------------------
		  
			on dialog #DOCKED -- save dock state to ini
			
		----------------------------------------------------------------------------------------------------------------------------------------*/
		
		if( ini_path != undefined ) then
			for event_type in #( #DOCKED, #UNDOCKED ) do
			(
				callback_fn = if event_type == #DOCKED then "saveDialogDockState" else "saveDialogState"
				
				Event =  Event_v type:event_type
				
				Event.callback = "(UiStateSaver_v ini_file:\""+ini_path+"\")."+callback_fn+"(\""+rollout_id+"\")"
				
				Event.callback += "\nformat \"TEST DEFAULT EVENT: #"+event_type+"  Rollout: "+ rollout_id as name +"\n\";\n" + Event.callback
	
				EventsList[event_type] = #( Event )
			)
		
		
		
		/*--------------------------------------------------------------------------------------------------------------------------------------
		  
			on #OKTOCLOSE - Save dialog state when its closed
			
			IMPORTANT: #oktoclose MUST RETURN BOOLEAN - true:close dialog | false:cancel closing
			
		----------------------------------------------------------------------------------------------------------------------------------------*/
		
		if( ini_path != undefined ) then
		(
			ini_path	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace ini_path "/"
		
			Event =  Event_v type:#OKTOCLOSE
		
			Event.callback = "(UiStateSaver_v ini_file:\""+ini_path+"\").saveControlsAndSubrollouts(\""+rollout_id+"\")"
		
			--Event.callback += "format \"TEST EVENT: #OKTOCLOSE  Rollout: "+ rollout_id as name +"\n\";\n" + Event.callback  
			
			Event.callback += "\n\n	true -- IMPORTANT - #oktoclose MUST RETURN BOOLEAN"

			--append EventsList.list Event
			EventsList[#OKTOCLOSE] = #( Event )
		)
		
		
		/*------------------------------------------------------------------------------
			RETURN EVENT LIST
		--------------------------------------------------------------------------------*/
		EventsList --return
	),
	
	
	
	/*==============================================================================
	
		GET ROLLOUT EVENTS
	
		@return	list	of rollout default events

	================================================================================*/
	function getRolloutEvents _Rollout =
	(
		--format "\n"; print "RolloutDefaultEvents_v.getRolloutEvents()"
		
		EventsList = Dictionary()
		
		--append EventsList.list (this._getAutoRollUpRolloutEvent(_Rollout))
		EventsList[#ROLLEDUP] = #( this._getAutoRollUpRolloutEvent(_Rollout) )
		--format "EventsList[#ROLLEDUP]: %\n" EventsList[#ROLLEDUP][1].callback
		EventsList --return
	),
	
	
	private
	
	/** Get auto roll up rollout event
	 */
	function _getAutoRollUpRolloutEvent _Rollout =
	(
		--format "\n"; print "RolloutDefaultEvents_v._getAutoRollUpRolloutEvent()"
		
		/** Get autoroll parmas
		 */
		function getAutorollParmas rollout_id_full =
		(
			--format "\n"; print "RolloutDefaultEvents_v.getAutorollParmas()"
			rollout_id_full_split	= filterString rollout_id_full "."
			
			/* "( parent_rollout_id )	( subrollout_slot )	( subrollout_id )" */ 
			"( #"+rollout_id_full_split[1]+ ")	( #"+rollout_id_full_split[2]+ ")	( #"+rollout_id_full_split[3]+ ")" --return
		)
		
		/* GET PARAMS FOR CALLBACK */ 
		params = getAutorollParmas (_Rollout.getFullId())
		
		close_other_rollouts_callback	= "rollUpOtherRolloutsCallback "	+ params
		auto_roll_up_rollout_callback	= "autoRollUpRolloutCallback "	+ params

		--callback = "	if keyboard.controlPressed then	rollUpOtherRolloutsCallback " + params +"\n" --"./Callbacks/rollUpOtherRolloutsCallback.ms"
		/* if CTRL is pressed callback */ 

		callback = "	if keyboard.controlPressed then\n		"+ close_other_rollouts_callback+"\nelse\n		"+auto_roll_up_rollout_callback

		--callback = "if val then\n	(\n	autoRollUpRolloutCallback "  + params + "\n)" --"./Callbacks/autoRollUpRolloutCallback.ms"
		
		/* RETURN EVENT */ 
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