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
	 * Event #DOCKED \ #UNDOCKED IS NOT NATIVE maxscript event, it is binded to #moved event
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

		/* CSUTOM TYPES - NOT maxscript NATIVE */
		#docked,
		#undocked
	),

	events_no_param	= #( #open, #close, #oktoclose, #help ),

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

		--format "_Rollout.Events.keys: %\n" _Rollout.Events.keys
		this._setDefaultEvents()
		--format "_Rollout.Events.keys: %\n" _Rollout.Events.keys

		this._setCustomEvents()  -- NOTE: callback will be fired in reversed order then has been added. Default event goes first
		
		--format "_Rollout.Events.keys: %\n" _Rollout.Events.keys

	),

	/** Add handlers
	 */
	function addHandlers =
	(
		--format "\n"; print "RolloutEventBinder_v.addHandlers()"
		dialog_or_rollout_event_types = if( this._Rollout.isDialog() ) then events_dialog else #( #ROLLEDUP )

		for event_type in dialog_or_rollout_event_types do
			this._addHandler event_type
	),

	/** Bind open\close events to rolled up handler
	  *
	  * Events #open, #close are bind to #rolledUp handler
	  */
	function mutateOpenCloseToRolledUp =
	(
		--format "\n";	print "RolloutEventBinder_v.mutateOpenCloseToRolledUp()"
		--format "_Rollout.Events.keys: %\n" _Rollout.Events.keys
		/** Join array to string
		 */
		function arrayToString arr delimeter:"\n" = ( _string = ""; for Event in arr do _string += Event.callback  + delimeter; substring _string 1 (_string.count-delimeter.count))
		
		if  _Rollout.Events[#ROLLEDUP] != undefined \
		or _Rollout.Events[#OPEN] 	  != undefined \
		or _Rollout.Events[#CLOSE]	  != undefined then
		(

			/* CREATE EVENT */ 
			--if Event_rolledup == undefined then
			Event_rolledup	= Event_v type:#ROLLEDUP

			_Rollout.addlocal #ROLLEDUP_INITILAZIED false
			
			if _Rollout.Events[#OPEN] != undefined then
				Event_rolledup.callback += "\n\n	if val == true then " + arrayToString( _Rollout.Events[#OPEN] )

			if _Rollout.Events[#CLOSE] != undefined then
				Event_rolledup.callback += "\n\n	if val == false then " + arrayToString( _Rollout.Events[#CLOSE] )

			/* WRAP CALLBACK TO PREVENT FIRE ON ADDING OF SUBROLLOUT --"./_Dev/preventRolledUpEventOnAdding.ms" */
			Event_rolledup.callback = 	"if rolledup_initilazied == true then\n	(\n\t\t" + Event_rolledup.callback + "\n\t)\n	else\n\t	rolledup_initilazied = true"

			/* ADD TO EVENTS */
			if Events_rolledup == undefined then 
				_Rollout.Events[#ROLLEDUP] = #()
		
			append _Rollout.Events[#ROLLEDUP] Event_rolledup
		)
	),

	private


	/** Bind events
	 */
	function _addHandler event_type =
	(
		if (Event = EventsCombiner.combine (event_type)) != undefined then
		(
			--format "\n\n";	print "RolloutEventBinder_v._addHandler()"
			--format "Event: %\n" Event

			handler = "on "+(this._Rollout.id)+" "+ event_type as string + this._getParams(event_type)+" do\n(" +Event.callback+ "\n)"
			--format "HANDLER:	% \n" handler
			
			this._Rollout.RCI.addText(handler) filter:true
		)
	),

	/** _combine events
	 */
	function _setDefaultEvents =
	(
		--format "\n\n";	print "RolloutEventBinder_v._setDefaultEvents()"
		DefaultEvents = DefaultEvents_v ini_path:ini_path

		parent_is_dialog = _Rollout.parent_rollout_id == undefined
		
		
		-- if parent_is_dialog then
		--	DefaultEvents.getDialogEvents(this._Rollout.id)

		
		/*------ DIALOG OR ROLLOUT ------*/
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

