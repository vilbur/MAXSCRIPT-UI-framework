filein( getFilenamePath(getSourceFileName()) + "/DefaultEvents/DefaultEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventsCombiner/EventsCombiner.ms" ) -- move this to rollout

/** RolloutEvent
  * 
  *		1) Available events for dialog|rollout are #open, #close, #resized, #moved, #docked 
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
	
	/* DIALOG Events -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7
	 * 
	 * Event #docled IS NOT NATIVE maxscript event, it is binded to #moved event
	*/	
	events_dialog = #(
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
		#rbuttondblclk
		
		/* NOT maxscript NATVIVE */ 
		--#docked
	),
	
	events_no_param	= #( #open, #close, #oktoclose ),
	
	--not_native_events	= #( #rolledDown, #docked ),
	
	/** Bind events
	 */
	function combineEventsAndAddHandlers _Rollout =
	(
		--format "\n\n~~~~~~~~~	Rollout Events:%	~~~~~~~~~\n" _Rollout.id

		this._Rollout = _Rollout

		this._setDefaultEvents()
		this._setCustomEvents()  -- NOTE: callback will be fired in reversed order then has been added. Default event goes first
				
		this._addHandlers()
	),
	
	private

	/** _bind events
	 */
	function _addHandlers =
	(
		--print "RolloutEventBinder_v._addHandlers()"
		dialog_or_rollout_event_types = if( _Rollout.parent_rollout_id == undefined ) then events_dialog else events_rollout
		
		--for event_type in this._getEventTypes(dialog_or_rollout_event_types) do
		for event_type in dialog_or_rollout_event_types do
			this._addHandler event_type
	),
		
	/** Bind events
	 */
	function _addHandler event_type =
	(
		--print "RolloutEventBinder_v._addHandler()"

		--if( (Event = this._getCombinedEvent event_type) == undefined ) then
		Event = EventsCombiner.combine (event_type)
		
		if Event == undefined then 
			return false
		
		
		--if Event.code == "" then 
			--return false
		
		--print "RolloutEventBinder_v._addHandler()"
		--format "event_type	= % \n" event_type
		--format "Event.code	= % \n" Event.code	
		--format "Event	= % \n" Event
		
		handler = "on "+(_Rollout.id)+" "+ event_type as string +" "+this._getParams(event_type)+" do  \n(" +Event.code+ "\n)"
		
		--format "handler	= % \n" handler
		_Rollout._RolloutCreator.addText(handler)
	),
	
	--/** Get callback on rollout open\close
	-- */
	--function _getCombinedEvent event_type =
	--(
	--	--format "\n"; print ("RolloutEvent_v._getCombinedEvent()")
	--	--format "event_type	= % \n" event_type
	--	case event_type of
	--	(
	--		#rolledUp:	this._mutateRolledUpEventToRolledDown()
	--		#resized:	this._mutateResizedEventToDocked()
	--		default:	EventsCombiner.combine (event_type)
	--	)
	--),
	
	/** _combine events
	 */
	function _setCustomEvents =
	(
		EventsCombiner.setEventsClass #CUSTOM _Rollout.Events.list
	),	

	/** _combine events
	 */
	function _setDefaultEvents =
	(
		EventsCombiner.setEventsClass #DEFAULTS ( (DefaultEvents_v ini_path:ini_path ).getEvents(_Rollout.getFullId()) ) 
	),

	--/** _combine events
	-- */
	--function _setSaveIniEvents =
	--(
	--	EventsCombiner.setEventsClass #SAVEINI ( (SaveIniEvents_v rollout_id:_Rollout.id ini_path:ini_path ).getEvents(_Rollout.parent_rollout_id) ) 
	--),
	

	--
	--/** Bind to rolled up handler
	--  *
	--  * Events #open, #close are bind to #rolledUp handler
	--  */
	--function _mutateRolledUpEventToRolledDown =
	--(
	--	--print ("RolloutEvents_v._mutateRolledUpEventToRolledDown()")
	--	Event_rolledup = EventsCombiner.combineOrGetNewEvent (#rolledUp)
	--	
	--	if( (Event_rolledown = EventsCombiner.combine (#rolledDown)) != undefined ) then 
	--		Event_rolledup.code = ";if( val ) then (" +Event_rolledown.code+ ")else(" +Event_rolledup.code+ ")" --return
	--	
	--	Event_rolledup --return
	--),
		
	--/** Mutate #resized event to works as #resized event as well
	--  *
	--  * Callback from #docked event is bind to #resized handler
	-- */
	--function _mutateResizedEventToDocked =
	--(
	--	--print "global._mutateResizedEventToDocked()"
	--	Event_resized	= EventsCombiner.combineOrGetNewEvent (#resized)
	--	--format "Event_resized	= % \n" Event_resized
	--	
	--	if( (Event_docked = EventsCombiner.combine (#docked)) != undefined ) then
	--	(
	--		prev_state_not_false	= " (DIALOG_PREVIOUS_STATE != false) "
	--		current_state_changed	= " (dialog_current_state = try(cui.getDockState "+_Rollout.id+")catch(false)) != DIALOG_PREVIOUS_STATE "
	--		current_state_match_cui	= " matchPattern (dialog_current_state as string) pattern:\"cui_*\" "
	--		
	--		----if_resizing_enabled     =	" if(ENABLE_RESIZING != false) then\n" -- this is MUST WRAP ALL STRINGS BELOW IN ()
	--		if_docked_event_enabled = " if(EVENT_DOCKED_ENABLED) then "
	--		
	--		re_set_previous_state   	= " DIALOG_PREVIOUS_STATE = dialog_current_state "
	--		
	--		--if( Event_docked != undefined ) then -- on move, if dialog is docked and change its state then call #docked callback
	--		Event_resized.code = "if ( "+prev_state_not_false+" and "+current_state_changed+" and "+current_state_match_cui+")
	--								then
	--									( "+if_docked_event_enabled+" (" +Event_docked.code+ " )  -- Fire #docked event
	--										EVENT_DOCKED_ENABLED = false 
	--									)
	--								else "+
	--									"(" +Event_resized.code+ ")"+ -- Fire #resized event
	--								re_set_previous_state
	--	)
	--
	--	Event_resized
	--),	

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
		 if( this._eventHasParameters(event_type) ) then "val" else "" 
	),
		
	/** _event has parameters
	 */
	function _eventHasParameters event_type =
	(
		findItem events_no_param event_type == 0
	),

	--/** Get event code of custom and default event
	--  *
	--  * @return	string	
	-- */
	--function _EventsCombinerCombine event_type =
	--(
	--	--print ("RolloutEvent_v._EventsCombinerCombine()")
	--	Event = EventsCombiner.combine event_type
	--
	--	if( Event != undefined ) then
	--		Event.code --return
	--	else
	--		"" --return
	--),
	
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
		messageBox ("WARNING\n\nUnknown Event Type: #" +event_type+ "\n\nControl: " + _Rollout.id )
	),
	
	on create do
	(
		--print("RolloutEventBinder_v.onCreate()")
	)
)