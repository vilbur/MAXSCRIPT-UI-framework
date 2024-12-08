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
	function getDialogEvents rollout_id_full =
	(
		--format "\n"; print ("DefaultEvents_v.getEvents()" + rollout_id_full as string )

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
		--appendEvent #OPEN "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id_full+"\")"
		Event =  Event_v type:#OPEN

		Event.callback = "GROUPBOXCREATOR.sortControlsToGroupBoxes(\""+rollout_id_full+"\")"
--
		append EventsList.list Event


		/* HANDLE WITH #RESIZE|#DOCKED|#UNDOCKED events */
		Event =  Event_v type:#RESIZED

		Event.callback = "waitForResixeEndTimer(#"+rollout_id_full+")( #resized )"

		append EventsList.list Event


		/* SAVE DIALOG STATE IF INI FILE EXISTS */
		if( ini_path != undefined ) then
		(
			ini_path	= ( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace ini_path "/"

			Event =  Event_v type:#OKTOCLOSE

			Event.callback = "(IniSaver_v ini_file:\""+ini_path+"\").saveRollout(\""+rollout_id_full+"\")"

			append EventsList.list Event
		)

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