filein( getFilenamePath(getSourceFileName()) + "/DefaultEvents/DefaultEvents.ms" )	-- "./DefaultEvents/DefaultEvents.ms"
filein( getFilenamePath(getSourceFileName()) + "/EventsCombiner/EventsCombiner.ms" )	-- "./EventsCombiner/EventsCombiner.ms"

/** RolloutEvent
  *
  *		1) Available events for dialog|rollout are #open, #close, #resized, #moved, #docked, #undocked
  *
  *		2) Events #open, #close and #docked fires save to ini callback before user defined callback, if ini file is defined then
  *
  *		3) Each event fires global variable EventFired
  *
  */
struct RolloutEventBinder_v
(
	/* construct */
	_Rollout,

	/* dependency */
	EventsCombiner	= EventsCombiner_v(),

	/* inhered */
	ini_path,

	/* ROLLOUT Events -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-DC435555-362D-4A03-BCF2-21179C5442F2
	 *
	 * Event #rolledDown IS NOT NATIVE maxscript event
	*/
	events_rollout = #( #open, #close, #rolledUp ),

	/* DIALOG Events
	 *
	 * Event #docled IS NOT NATIVE maxscript event, it is binded to #moved event
	*/
	events_dialog =
	#(
		#open, #close, #moved, #resized, #oktoclose, #help,

		/* Mouse button events */
		#lbuttondown,
		#lbuttonup,
		#lbuttondblclk,

		#mbuttondown,
		#mbuttonup,
		#mbuttondblclk,

		#rbuttondown,
		#rbuttonup,
		#rbuttondblclk,

		/* NOT maxscript NATVIVE */
		#docked,
		#undocked
	),

	events_no_param	= #( #open, #close, #oktoclose, #help ),

	--not_native_events	= #( #rolledDown, #docked ),

	/** Set rollout
	 */
	function setRollout _Rollout =
	(
		--format "\n"; print "RolloutEventBinder_v.setRollout ()"
		this._Rollout = _Rollout
	),

	/**Combine CUSTOM and DEFAULT events
	  * 
	  * TODO: rename this to setEventsToCombiner or like that
	 */
	function combineEvents =
	(
		--format "\n"; print "RolloutEventBinder_v.combineEvents()"
		--format "\n\n~~~~~~~~~	Rollout Events:%	~~~~~~~~~\n" _Rollout.id

		this._setDefaultEvents()

		this._setCustomEvents()  -- NOTE: callback will be fired in reversed order then has been added. Default event goes first
	),

	/** Add handlers
	 */
	function addHandlers =
	(
		--format "\n"; print "RolloutEventBinder_v.addHandlers()"
		dialog_or_rollout_event_types = if( this._Rollout.isDialog() ) then events_dialog else #( #ROLLEDUP )

		--format "this._Rollout.isDialog(): %\n" (this._Rollout.isDialog())
		--format "dialog_or_rollout_event_types: %\n" dialog_or_rollout_event_types

		for event_type in dialog_or_rollout_event_types do
			this._addHandler event_type
	),

	/** Bind open\close events to rolled up handler
	  *
	  * Events #open, #close are bind to #rolledUp handler
	  */
	function mutateOpenCloseToRolledUp =
	(
		--format "\n";	print "RolloutEventBinder_v._addHandler()"

		if  (Event_rolledup	= _Rollout.Events.get(#ROLLEDUP)) != undefined \
		or (Event_open   	= _Rollout.Events.get(#OPEN))     != undefined \
		or (Event_close  	= _Rollout.Events.get(#CLOSE))    != undefined then
		(
			_Rollout.addlocal #rolledup_initilazied false

			if Event_rolledup == undefined then
				Event_rolledup	= Event_v type:#ROLLEDUP

			if Event_open != undefined then
				Event_rolledup.callback += "\n\n	if val == true then " + Event_open.callback

			if Event_close != undefined then
				Event_rolledup.callback += "\n\n	if val == false then " + Event_close.callback

			/* WRAP CALLBACK TO PREVENT FIRE ON ADDING OF SUBROLLOUT --"./_Dev/preventRolledUpEventOnAdding.ms" */
			Event_rolledup.callback = 	"if rolledup_initilazied == true then\n	(\n\t\t" + Event_rolledup.callback + "\n\t)\n	else\n\t	rolledup_initilazied = true"


			--format "EVENT_ROLLEDUP.CALLBACK: %\n" Event_rolledup.callback
			_Rollout.Events.replace	(Event_rolledup)
		)
	),

	private


	/** Bind events
	 */
	function _addHandler event_type =
	(
		--format "\n"; print "RolloutEventBinder_v._addHandler()"
		if (Event = EventsCombiner.combine (event_type)) != undefined then
		(
			--format "\n";	print "RolloutEventBinder_v._addHandler()"
			--format "Event.callback: %\n" Event.callback
			--format "\n";	print "RolloutEventBinder_v._addHandler()"
			--format "event_type:	% \n" event_type

			handler = "on "+(this._Rollout.id)+" "+ event_type as string + this._getParams(event_type)+" do\n(" +Event.callback+ "\n)"
			--format "HANDLER:	% \n" handler
			this._Rollout.RCI.addText(handler)
		)
	),

	/** Mutate #resized event to works as #resized event as well
	  *
	  * Callback from #docked event is bind to #resized handler



			CURRENTLY UNUSED


	 */
	function _mutateResizedEventToDocked =
	( 
		--print "global._mutateResizedEventToDocked()"
		Event_resized	= EventsCombiner.combineOrGetNewEvent (#resized)
		--format "Event_resized	= % \n" Event_resized

		if( (Event_docked = EventsCombiner.combine (#docked)) != undefined ) then
		(
			prev_state_not_false	= " (DIALOG_PREVIOUS_STATE != false) "
			current_state_changed	= " (dialog_current_state = try(cui.getDockState "+_Rollout.id+")catch(false)) != DIALOG_PREVIOUS_STATE "
			current_state_match_cui	= " matchPattern (dialog_current_state as string) pattern:\"cui_*\" "

			----if_resizing_enabled     =	" if(ENABLE_RESIZING != false) then\n" -- this is MUST WRAP ALL STRINGS BELOW IN ()
			if_docked_event_enabled = " if(EVENT_DOCKED_ENABLED) then "

			re_set_previous_state   	= " DIALOG_PREVIOUS_STATE = dialog_current_state "

			--if( Event_docked != undefined ) then -- on move, if dialog is docked and change its state then call #docked callback
			Event_resized.code = "if ( "+prev_state_not_false+" and "+current_state_changed+" and "+current_state_match_cui+")
									then
										( "+if_docked_event_enabled+" (" +Event_docked.code+ " )  -- Fire #docked event
											EVENT_DOCKED_ENABLED = false
										)
									else "+
										"(" +Event_resized.code+ ")"+ -- Fire #resized event
									re_set_previous_state
		)

		Event_resized
	),

	/** _combine events
	 */
	function _setDefaultEvents =
	(
		DefaultEvents = DefaultEvents_v ini_path:ini_path

		parent_is_dialog = _Rollout.parent_rollout_id == undefined
		
		--_Rollout.addLocal #open_rollouts #()
		--_Rollout.addLocal #auto_roll_up (if parent_is_dialog then undefined else 2 ) -- keep only single opened subrollout
		
		EventsCombiner.EventsLists[#DEFAULTS] = if parent_is_dialog then
		
			/* DIALOG EVENTS */ 
			DefaultEvents.getDialogEvents(this._Rollout.id)
		else
		
			/* ROLLOUT EVENTS */ 
			DefaultEvents.getRolloutEvents(_Rollout)
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		EventsCombiner.EventsLists[#CUSTOM] = this._Rollout.Events
	),

	/** Get events for dialog rollout or subrollout
	 */
	function _getEventTypes event_types =
	(
		for event_type in event_types where ((index = findItem not_native_events event_type) == 0 ) collect event_type
	),

	/** _get params
	 */
	function _getParams event_type =
	(
		if( this._eventHasParameters(event_type) ) then " val" else ""
	),

	/** _event has parameters
	 */
	function _eventHasParameters event_type =
	(
		findItem events_no_param event_type == 0
	),

	/** _is event exists
	 */
	function _eventNameIsValid event_types event_type =
	(
		--print "Events_v._eventNameIsValid()"
		--format "event_types	= % \n" event_types
		event_exists = findItem event_types event_type > 0

		if not( event_exists ) then
			this._exception (event_type)

		event_exists --return
	),

	/** Exception
	 */
	function _exception event_type =
	(
		messageBox ("WARNING\n\nUnknown Event Type: #" +event_type+ "\n\nControl: " + this._Rollout.id )
	),

	on create do
	(
		--print("RolloutEventBinder_v.onCreate()")
	)
)