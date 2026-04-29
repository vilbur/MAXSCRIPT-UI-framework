filein( getFilenamePath(getSourceFileName()) + "/RolloutDefaultEvents/RolloutDefaultEvents.ms" )	-- "./RolloutDefaultEvents/RolloutDefaultEvents.ms"
filein( getFilenamePath(getSourceFileName()) + "/EventsCombiner/EventsCombiner.ms" )	-- "./EventsCombiner/EventsCombiner.ms"

/** Open url fails in the event but works in the callback function
  
	In 3ds Max, any script run from a string via execute is classified as a "Dynamic Script."
	Under SSSE rules, Dynamic Scripts are strictly sandboxed.
	3ds Max will always block a Dynamic Script from running system commands like shellLaunch,
	even if the main script itself is trusted.
 */
function openUrRolloutEventlCallback url = shellLaunch url ""


/** RolloutEvent
  *
  *		1) Available events for dialog|rollout are #OPEN, #CLOSE, #RESIZED, #MOVED, #DOCKED, #UNDOCKED
  *
  *		2) Events #open, #CLOSE and #docked fires save to ini callback before user defined callback, if ini file is defined then
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
	
	/* developent */
	DEBUG = false,
	
	/* ROLLOUT Events https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-DC435555-362D-4A03-BCF2-21179C5442F2
	 *
	 * Event #rolledDown IS NOT NATIVE maxscript event
	*/
	events_rollout = #( #open, #close, #rolledUp, #help ),

	/* DIALOG Events https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7
	 *
	 * Event #DOCKED \ #UNDOCKED IS NOT NATIVE maxscript event, it is binded to #moved event
	*/
	events_dialog =
	#(
		#open, #close, #moved, #resized, #oktoclose, #help,

		/* Mouse button events */
		#mousemove,
		
		#lbuttondown,
		#lbuttonup,
		#lbuttondblclk,

		#mbuttondown,
		#mbuttonup,
		#mbuttondblclk,

		#rbuttondown,
		#rbuttonup,
		#rbuttondblclk,

		/* CSUTOM TYPES - NOT maxscript NATIVE */
		#docked,
		#undocked
	),

	events_no_param	= #( #open, #close, #oktoclose, #help ),
	
	/** Prepare events
	 */
	function prepareEvents _Rollout =
	(
		--format "\n"; print "RolloutEventBinder_v.prepareEvents()"
		
		/*------------------------------------------------------------------------------
		    CONGIGURE
		--------------------------------------------------------------------------------*/		
		
		this._setRollout(_Rollout)
		
		this._setRolloutDefaultEvents()

		this._setCustomEvents()  -- NOTE: callback will be fired in reversed order then has been added. Default event goes first

		/*------------------------------------------------------------------------------
			SETUPE EVENTS BY TYPE
		--------------------------------------------------------------------------------*/
		
		/* HELP */ 
		this._setHelpUrlEvent()
		
		/* DOCKED */ 
		this._combineDockedEvents()
		
		/* ROLLUP */ 
		this._mutateOpenCloseToRolledUp()
	),
	

	/** Add handlers
	 */
	function addHandlers =
	(
		--format "\n"; print "RolloutEventBinder_v.addHandlers()"
		
		/* GET DIALOG OR ROLLOUT EVENT TYPES */ 
		event_types = if( this._Rollout.isDialog() ) then events_dialog else #( #ROLLEDUP )
		--format "event_types: %\n" event_types
		--format "event_types[#HELP]: %\n" event_types[#HELP]

		/* ADD HANDLERS FOR EACH TYPE */ 
		for event_type in event_types do
			this._addHandler event_type
	),

	private


	/** Set rollout
	 */
	function _setRollout _Rollout =
	(
		--format "\n"; print "RolloutEventBinder_v._setRollout ()"
		this._Rollout = _Rollout
	),

	/*------------------------------------------------------------------------------
		BIND EVENT TO ROLLOUT
	--------------------------------------------------------------------------------*/
	function _addHandler event_type =
	(
		if (Event = EventsCombiner.combine (event_type)) != undefined then
		(
			--format "\n\n";	print "RolloutEventBinder_v._addHandler()"
			--format "Event.TYPE: %\n" Event.type
			--format "Event.CALLBACK: %\n" Event.callback

			handler = "on "+( this._Rollout.id )+" "+ event_type as string + this._getParams(event_type)+" do\n(" +Event.callback+ "\n)"
			
			if DEBUG then format "\n---------------------------------------------------------------------------\n\nHANDLER:  % \n" handler
			
			this._Rollout.RCI.addText(handler) filter:true
		)
	),

	/** _combine events
	 */
	function _setRolloutDefaultEvents =
	(
		--format "\n\n";	print "RolloutEventBinder_v._setRolloutDefaultEvents()"
		RolloutDefaultEvents = RolloutDefaultEvents_v ini_path:ini_path

		parent_is_dialog = _Rollout.parent_rollout_id == undefined
		
		
		/*------------------------------------------------------------------------------
			GET EVENTS OF DIALOG OR ROLLOUT
		--------------------------------------------------------------------------------*/
		EventsCombiner.EventsLists[#DEFAULTS] = if parent_is_dialog then
		
			/* DIALOG EVENTS */ 
			RolloutDefaultEvents.getDialogEvents(this._Rollout.id)
		else
		
			/* ROLLOUT EVENTS */ 
			RolloutDefaultEvents.getRolloutEvents(_Rollout)
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		EventsCombiner.EventsLists[#CUSTOM] = this._Rollout.Events
	),
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/** shellLaunch cannot be executed directly from event because of security reasons
	  
		Workaround is open url from function 
	 */
	function _setHelpUrlEvent =
	(
		--format "\n"; print "RolloutEventBinder_v._setHelpUrlEvent()"
		--format "\n***********************************\n"

		if ( Events = EventsCombiner.EventsLists[#CUSTOM][#HELP] ) != undefined then 
			for i = 1 to Events.count where ( Event = Events[i] ) != undefined do
				if matchPattern Event.callback pattern:("http*") or matchPattern Event.callback pattern:("www*") then
					Event.callback = "openUrRolloutEventlCallback \""+ Event.callback +"\""
	),

	/** Bind open\close events to rolled up handler
	  *
	  * Events #open, #close are bind to #rolledUp handler
	  */
	function _mutateOpenCloseToRolledUp =
	(
		--format "\n";	print "RolloutEventBinder_v._mutateOpenCloseToRolledUp()"
		--format "_Rollout.Events.keys: %\n" _Rollout.Events.keys
		/** Join array to string
		 */
		function arrayToString arr delimeter:"\n" = ( _string = ""; for Event in arr do _string += Event.callback  + delimeter; substring _string 1 (_string.count-delimeter.count))
		
		
		/* IF ANY OF "ROLLEDUP" RELATED EVENTS IS DEFINED */ 
		if  _Rollout.Events[#ROLLEDUP] != undefined \
		or _Rollout.Events[#OPEN] 	  != undefined \
		or _Rollout.Events[#CLOSE]	  != undefined then
		(

			/* CREATE EVENT */ 
			Event_rolledup	= Event_v type:#ROLLEDUP

			/* AVOID FIRE EVENT ON INIT */ 
			_Rollout.addlocal #ROLLEDUP_INITILAZIED false
			
			
			
			/* #OPEN event */ 
			if _Rollout.Events[#OPEN] != undefined then
				Event_rolledup.callback += "\n\n	    if val == true  then " + arrayToString( _Rollout.Events[#OPEN] )

			/* #CLOSE event */ 
			if _Rollout.Events[#CLOSE] != undefined then
				Event_rolledup.callback += "\n\n	    if val == false then " + arrayToString( _Rollout.Events[#CLOSE] )
				
			
			
			/* WRAP CALLBACK TO PREVENT FIRE ON ADDING OF SUBROLLOUT --"./_Dev/preventRolledUpEventOnAdding.ms" */
			Event_rolledup.callback = 	"if ROLLEDUP_INITILAZIED == true then\n	(\n\t\t" + Event_rolledup.callback + "\n\t)\n	else\n\t	ROLLEDUP_INITILAZIED = true"

			
			/* ADD TO EVENTS */
			if Events_rolledup == undefined then 
				_Rollout.Events[#ROLLEDUP] = #()
		
		
			append _Rollout.Events[#ROLLEDUP] Event_rolledup
		)
		
	),
	
	/** Combine #DOCKED \ #UNDOCKED events and move them to _Rollout.Events
		
		
		This makes callback executable in "./RolloutDefaultEvents/Callbacks/waitForResizingEnds.ms"
		
		
		#DOCKED 	 🡶                                         🡵 #DOCKED
		#RESIZED  🡲 #RESIZED 🡲 waitForResizingEnds()🡲 Fire 🡲 #RESIZED
		#UNDOCKED 🡵                                         🡶 #UNDOCKED
  
	 */
	function _combineDockedEvents =
	(
		--format "\n"; print "RolloutEventBinder_v._combineDockedEvents()"
		for event_type in #( #UNDOCKED, #DOCKED ) where (Event = EventsCombiner.combine (event_type)) != undefined do
			--_Rollout.Events[event_type] = Event
			_Rollout.Events[event_type] = #(Event)
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

