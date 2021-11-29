filein( getFilenamePath(getSourceFileName()) + "/EventsDefault/EventsDefault.ms" )
filein( getFilenamePath(getSourceFileName()) + "/EventsCombiner/EventsCombiner.ms" )

global DIALOG_PREVIOUS_STATE = undefined -- this should be in struct

global ENABLE_DOCKED_EVENT = true -- prevent crash on destroying  of dialog

/** RolloutEvent
  * 
  *		1) Available events for dialog|rollout are #open, #close, #resized, #moved, #docked 
  *	
  *		2) Events #open, #close and #docked fires save to ini callback before user defined callback, if ini file is defined then
  *
  *		3) Each event fires global variable EventFired
  *	
  *	
  *	------------------------------------------------------------------------------------------------------------
  *	
  *	
  *	
  */
struct RolloutEvents_v 
(
	_Rollout,
	--Events,
	--EventsDefault	= EventsDefault_v(),
	EventsCombiner	= EventsCombiner_v(),
	
	/* inhered */ 
	ini_path,
	
	/* ROLLOUT Events -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-DC435555-362D-4A03-BCF2-21179C5442F2
	 * 
	 * Event #rolledDown IS NOT NATIVE maxscript event
	*/
	events_rollout = #( #rolledUp, #rolledDown ),
	
	/* DIALOG Events -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7
	 * 
	 * Event #docled IS NOT NATIVE maxscript event, it is binded to #moved event
	*/	
	events_dialog = #(
		#open, #close, #resized, #moved, #oktoclose, #help,
		
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
		#docked
	),
	
	events_no_param	= #( #open, #close, #docked, #oktoclose ),
	
	not_native_events	= #( #rolledDown, #docked ),
	
	/** Bind events
	 */
	function bindEvents _Rollout =
	(
		--format "\n"
		--print ("RolloutEvents_v.bindEvents() " + _Rollout.id)
		--format "_Rollout.is_subrollout = % \n" _Rollout.is_subrollout
		this._Rollout = _Rollout
		--this.Events   = _Rollout.Events.list
		--format "ini_path	= % \n" ini_path
		
		if( ini_path != undefined ) then
			EventsCombiner.defaults = ((EventsDefault_v rollout_id:_Rollout.id ini_path:ini_path ).getDefaultEvents(_Rollout.is_subrollout)) 
		
		EventsCombiner.custom = _Rollout.Events.list
		
		for event_type in (event_types = this._getEventTypes()) where this._eventNameIsValid (event_types) (event_type) do
			this._bindEvent event_type
	),
	
	private
	
	/** Get events for dialog rollout or subrollout
	 */
	function _getEventTypes =
	(
		event_types = if( _Rollout.is_subrollout ) then events_rollout else events_dialog
		
		for not_native_event in not_native_events where ((index = findItem event_types not_native_event) > 0 ) do 
			event_types = deleteItem event_types index
		
		event_types --return
	),

	/** Bind events
	 */
	function _bindEvent event_type =
	(
		--print ("RolloutEvents_v.bindEvent()")
		--format "event_type	= % \n" event_type
		--format "this._getEventTypes()	= % \n" (this._getEventTypes())
		
		callback = this._getCallback event_type
		--format "callback	= % \n" callback
		
		if( callback == undefined or callback == "" ) then
			return false

		handler = "on "+(_Rollout.id)+" "+ event_type as string +" "+this._getParams(event_type)+" do  (" +callback+ ")"
		--format "_Rollout.id	= % \n" _Rollout.id
		--format "event_type	= % \n" event_type
		--format "callback	= % \n" callback
		--format "Event.code	= % \n" Event.code
		--format "handler	= % \n" handler
		_Rollout._RolloutCreator.addText(handler)
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
	
	/** Get callback on rollout open\close
	 */
	function _getCallback event_type =
	(
		--format "\n"
		--print ("RolloutEvent_v._getCallback()")
		--format "event_type	= % \n" event_type
		case event_type of
		(
			#rolledUp: this._getEventsForRolledUpHandler()
			#moved:    this._getEventsForMovedHandler()
			default:	 this._getEventCodeCombined (event_type)
		)
	),
	
	/** Bind to rolled up handler
	  *
	  * Events #open, #close are bind to #rolledUp handler
	  *
	 */
	function _getEventsForRolledUpHandler =
	(
		--print ("RolloutEvents_v._getEventsForRolledUpHandler()")
		callback_rolledown	= this._getEventCodeCombined #rolledDown
		callback_rolledup	= this._getEventCodeCombined #rolledUp

		if( callback_rolledup.count > 0 or callback_rolledown.count > 0 ) then
			callback = "if( val == true ) then (" +callback_rolledown+ ")else(" +callback_rolledup+ ")" --return
		
		callback --return
	),
		
	/** Bind #docked to #moved handler
	  *
	  *	Event #docked is bind to #moved handler
	  * If dialog is docked then callback of #docked is called
	  *
	  * #docked is not native maxscript event, it is simulated by checking dock state on #moved event
	  *
	 */
	function _getEventsForMovedHandler =
	(
		--print ("RolloutEvent_v._getEventsForMovedHandler()")
		callback_moved	= this._getEventCodeCombined #moved
		callback_docked	= this._getEventCodeCombined #docked
		
		--if_resizing_enabled     =	""
		--if_resizing_enabled     =	" if(ENABLE_RESIZING != false) then\n" -- this is MUST WRAP ALL STRINGS BELOW IN ()
		if_docked_event_enabled = " if(ENABLE_DOCKED_EVENT) then "

		prev_state_not_false	= " (DIALOG_PREVIOUS_STATE != false) "
		current_state_changed	= " (dialog_current_state = try(cui.getDockState "+_Rollout.id+")catch(false)) != DIALOG_PREVIOUS_STATE "
		state_match_cui      	= " matchPattern (dialog_current_state as string) pattern:\"cui_*\" "
		set_previous_state   	= " DIALOG_PREVIOUS_STATE = dialog_current_state "
		
		if( callback_docked != "" ) then -- on move, if dialog is docked and change its state then call #docked callback
			callback_moved += "if ( "+prev_state_not_false+" and  "+current_state_changed+" and "+state_match_cui+") then ( "+if_docked_event_enabled+" (" + callback_docked + " ))\n" + set_previous_state
		
		callback_moved --return
	),
	
	/** Get event code of custom and default event
	  *
	  * @return	string	
	 */
	function _getEventCodeCombined event_type =
	(
		--print ("RolloutEvent_v._getEventCodeCombined()")
		Event = EventsCombiner.combine event_type

		if( Event != undefined ) then
			Event.code --return
		else
			"" --return
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
		messageBox ("WARNING\n\nUnknown Event Type: #" +event_type+ "\n\nControl: " + _Rollout.id )
	),
	
	on create do
	(
		--print("RolloutEvents_v.onCreate()")
	)
)