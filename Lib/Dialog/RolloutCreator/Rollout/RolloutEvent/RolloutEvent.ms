--filein( getFilenamePath(getSourceFileName()) + "/DefaultEvents/DefaultEvents.ms" )

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
	
	Ini	= Ini_v(),
	--DefaultEvents	= DefaultEvents_v(),
	
	/* Events #rolledDown|#docked ARE NOT NATIVE maxscript events
	*/ 
	event_types = #(
		
		/* ROLLOUT */ -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-DC435555-362D-4A03-BCF2-21179C5442F2
		#rolledUp, #rolledDown,
		
		/* ROLLOUT AND DIALOG */ 
		#open, #close, #resized, #moved,
		
		/* DIALOG */ -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7
		#oktoclose, #help, #docked,
		
		/* DIALOG Mouse button events */ 
		#lbuttondown,	
		#lbuttonup,	
		#lbuttondblclk,	
		
		#mbuttondown,	
		#mbuttonup,	
		#mbuttondblclk,	
		
		#rbuttondown,	
		#rbuttonup,	
		#rbuttondblclk
	),
	
	events_no_param	= #( #open, #close, #docked, #oktoclose ),
	
	/** Bind events
	 */
	function bindEvents _Rollout =
	(
		format "\n"
		print ("RolloutEvents_v.bindEvents() " + _Rollout.id)
		--format "_Rollout.Events = % \n" _Rollout.Events
		this._Rollout = _Rollout
		--this.Events   = _Rollout.Events.list
		
		--this.DefaultEvents.setSaveToIniEvents()
		
		--for Event in Events do 
			--this._bindEvent Event
	),
	
	private

	
	/** Bind events
	 */
	function _bindEvent Event =
	(
		print ("RolloutEvents_v.bindEvent()")
		format "Event	= % \n" Event
		callback = this._getCallback Event.type

		handler = "on "+(_Rollout.id)+" "+ Event.type as string +" "+this._getParams(Event.type)+" do  (" +callback+ ")" 
		format "handler	= % \n" handler
		
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
		--print ("RolloutEvent_v._getCallback()")
		--format "event_type	= % \n" event_type
		case event_type of
		(
			#moved:    this._bindToMovedHandler()
			#rolledUp: this._bindToRolledUpHandler()
			default:	 this._getEventCode (event_type)
		)
	),
	
	/** Bind to rolled up handler
	  *
	  * Events #open, #close are bind to #rolledUp handler
	  *
	 */
	function _bindToRolledUpHandler =
	(
		print ("RolloutEvents_v._bindToRolledUpHandler()")
		callback_rolledown	= this._getEventCode #rolledDown
		callback_rolledup	= this._getEventCode #rolledUp

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
	function _bindToMovedHandler =
	(
		--print ("RolloutEvent_v._bindToMovedHandler()")
		callback_moved	= this._getEventCode #moved
		callback_docked	= this._getEventCode #docked
		
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
	
	/** _get event code
	 */
	function _getEventCode event_type =
	(
		event_code = ""
		
		for Event in Events where Event.type == event_type do event_code = Event.code
				
		event_code --return
	),
	
	
	on create do
	(
		print("RolloutEvents_v.onCreate()")
		format "Ini._path	= % \n" Ini._path
	)
)