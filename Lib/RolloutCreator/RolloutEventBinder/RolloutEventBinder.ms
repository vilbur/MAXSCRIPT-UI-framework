filein( getFilenamePath(getSourceFileName()) + "/RolloutEventsDefault/RolloutEventsDefault.ms" )
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
struct RolloutEventBinder_v 
(
	_Rollout,
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
		#docked
	),
	
	events_no_param	= #( #open, #close, #docked, #oktoclose ),
	
	not_native_events	= #( #rolledDown, #docked ),
	
	/** Bind events
	 */
	function bindEvents _Rollout =
	(
		this._Rollout = _Rollout

		--this._setCustomEvents()
		this._setDefaultEvents()
		
		this._bindEachEvent()
	),
	
	private


	/** Bind events
	 */
	function _bindEvent event_type =
	(
		--format "this._getEventTypes()	= % \n" (this._getEventTypes())
		Event = this._getCombinedEvent event_type
		
		if( Event == undefined ) then
			return false

		format "\n"
		print ("RolloutEvents_v.bindEvent()")
		format "event_type	= % \n" event_type
		format "Event	= % \n" Event

		handler = "on "+(_Rollout.id)+" "+ event_type as string +" "+this._getParams(event_type)+" do  (" +Event.code+ ")"
		--format "_Rollout.id	= % \n" _Rollout.id
		--format "event_type	= % \n" event_type
		--format "callback	= % \n" callback
		--format "Event.code	= % \n" Event.code
		--format "handler	= % \n" handler
		_Rollout._RolloutCreator.addText(handler)
	),
	
	/** Get callback on rollout open\close
	 */
	function _getCombinedEvent event_type =
	(
		--format "\n"
		--print ("RolloutEvent_v._getCombinedEvent()")
		--format "event_type	= % \n" event_type
		case event_type of
		(
			#rolledUp: this._getEventsForRolledUpHandler()
			--#moved:    this._getEventsForMovedHandler()
			--#moved:    this._getEventsForMovedHandlerMax2016()
			#resized:    EventsCombiner.getResized()
			default:	 EventsCombiner.combine (event_type)
		)
	),
	

	/** _combine events
	 */
	function _setCustomEvents =
	(
		EventsCombiner.setEventsClass #CUSTOM _Rollout.Events.list
	),	

	/** _combine events
	 */
	function _setDefaultEvents =
		EventsCombiner.setEventsClass #DEFAULTS ((RolloutEventsDefault_v rollout_id:_Rollout.id ini_path:ini_path ).getDefaultEvents(_Rollout.is_subrollout)) 
	),	
	
	/** _bind events
	 */
	function _bindEachEvent =
	(
		--print "global._bindEachEvent()"
		for event_type in (event_types = this._getEventTypes()) where this._eventNameIsValid (event_types) (event_type) do
			this._bindEvent event_type
	),
		

	/** Bind to rolled up handler
	  *
	  * Events #open, #close are bind to #rolledUp handler
	  *
	 33
	function _getEventsForRolledUpHandler =
	(
		--print ("RolloutEvents_v._getEventsForRolledUpHandler()")
		callback_rolledown	= EventsCombiner.combine (#rolledDown)
		callback_rolledup	= EventsCombiner.combine (#rolledUp)

		if( callback_rolledup.count > 0 or callback_rolledown.count > 0 ) then
			callback = "if( val == true ) then (" +callback_rolledown+ ")else(" +callback_rolledup+ ")" --return
		
		callback --return
	),
		
	/** _get events for moved handler
	 */
	function _getEventsForMovedHandler =
	(
		print "!!!! global._getEventsForMovedHandler()"
		
		--if(  (max_version = (maxVersion())[8] )!= undefined and max_version >= 2022  ) then 
			--this._getEventsForResizedHandlerMax()
		--else
			--this._getEventsForMovedHandlerMax2016()
	),	
		
	/** _get events for moved handler max2020
	 */
	function _getEventsForResizedHandlerMax =
	(
		print "global._getEventsForResizedHandlerMax()"
		callback_resized	= EventsCombiner.combine (#resized)
		----current_state	= " (dialog_current_state = try(cui.getDockState "+_Rollout.id+")catch(false)) != DIALOG_PREVIOUS_STATE "
		----set_previous_state   	= " DIALOG_PREVIOUS_STATE = dialog_current_state "
		----
		----
		----if( callback_docked != "" ) then -- on move, if dialog is docked and change its state then call #docked callback
		----	callback_resized += "\n" + current_state + "\n" + set_previous_state + "\nprint \"STATE:\"\nprint DIALOG_PREVIOUS_STATE as string"
		--print ("RolloutEvent_v._getEventsForMovedHandlerMax2016()")
		--callback_resized	= EventsCombiner.combine (#resized)
		--callback_docked	= EventsCombiner.combine (#docked)
		----if_resizing_enabled     =	""
		----if_resizing_enabled     =	" if(ENABLE_RESIZING != false) then\n" -- this is MUST WRAP ALL STRINGS BELOW IN ()
		--if_docked_event_enabled = " if(ENABLE_DOCKED_EVENT) then "
		--
		--prev_state_not_false	= " (DIALOG_PREVIOUS_STATE != false) "
		--current_state_changed	= " (dialog_current_state = try(cui.getDockState "+_Rollout.id+")catch(false)) != DIALOG_PREVIOUS_STATE "
		--state_match_cui      	= " matchPattern (dialog_current_state as string) pattern:\"cui_*\" "
		--set_previous_state   	= " DIALOG_PREVIOUS_STATE = dialog_current_state "
		--
		----if( callback_docked != "" ) then -- on move, if dialog is docked and change its state then call #docked callback
		--	--callback_resized += "if ( "+prev_state_not_false+" and  "+current_state_changed+" and "+state_match_cui+") then ( "+if_docked_event_enabled+" (" + callback_docked + " ))\n" + set_previous_state
		--format "callback_resized	= % \n" callback_resized
		--format "callback_docked	= % \n" callback_docked 
		--callback_resized --return
		----callback_docked
		
		callback_resized.code +=("(format \"%\" (\"\n!!! MERGED EVENT RESIZED\"))") 

		callback_resized
	),
	/** _get events for moved handler max2020
	 */
	function _getEventsForResizeHandlerMax2022 =
	(
		if(  (max_version = (maxVersion())[8] )!= undefined and max_version >= 2022  ) then 
		(
			callback_resized	= EventsCombiner.combine (#resized)

			
		current_state	= " (dialog_current_state = try(cui.getDockState "+_Rollout.id+")catch(false)) != DIALOG_PREVIOUS_STATE "

			callback_resized += current_state + "\n" + "\nprint \"STATE DOCKED:\"\nprint DIALOG_PREVIOUS_STATE as string"

			
		)
	),
	
	
	
	/** Bind #docked to #moved handler
	  *
	  *	Event #docked is bind to #moved handler
	  * If dialog is docked then callback of #docked is called
	  *
	  * #docked is not native maxscript event, it is simulated by checking dock state on #moved event
	  *
	 */
	function _getEventsForMovedHandlerMax2016 =
	(
		print ("RolloutEvent_v._getEventsForMovedHandlerMax2016()")
		Event_moved	= EventsCombiner.combine (#moved)
		Event_docked	= EventsCombiner.combine (#docked)
		
		--if_resizing_enabled     =	""
		--if_resizing_enabled     =	" if(ENABLE_RESIZING != false) then\n" -- this is MUST WRAP ALL STRINGS BELOW IN ()
		if_docked_event_enabled = " if(ENABLE_DOCKED_EVENT) then "

		prev_state_not_false	= " (DIALOG_PREVIOUS_STATE != false) "
		current_state_changed	= " (dialog_current_state = try(cui.getDockState "+_Rollout.id+")catch(false)) != DIALOG_PREVIOUS_STATE "
		state_match_cui      	= " matchPattern (dialog_current_state as string) pattern:\"cui_*\" "
		set_previous_state   	= " DIALOG_PREVIOUS_STATE = dialog_current_state "
		
		if( Event_docked != undefined ) then -- on move, if dialog is docked and change its state then call #docked callback
			Event_moved.code += "if ( "+prev_state_not_false+" and  "+current_state_changed+" and "+state_match_cui+") then ( "+if_docked_event_enabled+" (" + Event_moved.code + " ))\n" + set_previous_state
		
		Event_moved --return
	),
	
	/** Get events for dialog rollout or subrollout
	 */
	function _getEventTypes =
	(
		event_types = if( _Rollout.is_subrollout ) then events_rollout else events_dialog
		
		for not_native_event in not_native_events where ((index = findItem event_types not_native_event) > 0 ) do 
			event_types = deleteItem event_types index
		
		event_types --return
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

	/** Get event code of custom and default event
	  *
	  * @return	string	
	 */
	function _EventsCombinerCombine event_type =
	(
		--print ("RolloutEvent_v._EventsCombinerCombine()")
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