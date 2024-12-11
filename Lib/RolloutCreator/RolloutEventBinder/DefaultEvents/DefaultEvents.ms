filein( getFilenamePath(getSourceFileName()) + "/fitSubrolloutSlotToRolloutCallback.ms" )	-- "./fitSubrolloutSlotToRolloutCallback.ms"


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



		
		/* MOVE CONTROLS TO GROUPBOXES */
		--appendEvent #OPEN "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id+"\")"
		Event =  Event_v type:#OPEN

		Event.callback = "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id+"\")"

		append EventsList.list Event


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
		
		rollout_id_full = _Rollout.getFullId()
		--format "rollout_id_full: %\n" rollout_id_full
		callback = ""
		rollout_id_full_split	= filterString rollout_id_full "."
		
		parent_rollout	= rollout_id_full_split[1]
		slot	= rollout_id_full_split[2]
		rollout_id	= rollout_id_full_split[3]
		
		rollouts	= parent_rollout + "." + slot + ".rollouts" -- rollout.slot.rollouts
		
		/* MOVE CONTROLS TO GROUPBOXES */
		--appendEvent #OPEN "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id_full+"\")"
		Event =  Event_v type:#ROLLEDUP

		callback = "if val then for _rollout in "+rollouts+" where not matchPattern ( _rollout as string ) pattern:(\"*\"+\""+rollout_id+"\") do _rollout.open = false"
		
		open_rollouts = parent_rollout + ".open_rollouts"
		
		
		open_rollouts_count = "open_rollouts_count = if ( open_rollouts_parent_count =" + parent_rollout + ".max_opened_subrollouts ) == undefined then "+rollouts+".count else open_rollouts_parent_count \n\n"
		--open_rollouts_count = "open_rollouts_count = 1\n\n"

		
		max_opened_rollouts = parent_rollout + ".max_opened_rollouts"
		
		if_roullout_opened = "if val then\n"
		
		add_opened_rollout = "    insertItem \"" + rollout_id + "\" "+open_rollouts+" 1 \n\n"
		
		opened_rollouts_clear = "    "+open_rollouts+" = makeUniqueArray (for i = 1 to "+open_rollouts+".count where i <= open_rollouts_count collect "+open_rollouts+"[i]) \n\n"
		
		close_other_rollouts = "    for _rollout in "+rollouts+" where findItem "+open_rollouts+" ((filterString (_rollout as string) \":\")[2]) == 0 do _rollout.open = false \n"
		
		callback =  open_rollouts_count + if_roullout_opened  +"(\n" + add_opened_rollout + opened_rollouts_clear + close_other_rollouts + "\n)"
		--format "CALLBACK:\n\n%\n" callback
		
		Event.callback = callback
		
		append EventsList.list Event
		
		
		EventsList --return
	),

	/**
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
)