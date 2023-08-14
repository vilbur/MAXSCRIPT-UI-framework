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
		dialog_or_rollout_event_types = if( this._Rollout.parent_rollout_id == undefined ) then events_dialog else events_rollout

		for event_type in dialog_or_rollout_event_types do
			this._addHandler event_type
	),

	/** Bind events
	 */
	function _addHandler event_type =
	(
		--format "\n";	print "RolloutEventBinder_v._addHandler()"

		if (Event = EventsCombiner.combine (event_type)) != undefined then
		(
			handler = "on "+(this._Rollout.id)+" "+ event_type as string +" "+this._getParams(event_type)+" do  \n(" +Event.code+ "\n)"

			this._Rollout.RCI.addText(handler)
		)
	),

	/** _combine events
	 */
	function _setCustomEvents =
	(
		EventsCombiner.events_classes[#CUSTOM] = this._Rollout.Events.list
	),

	/** _combine events
	 */
	function _setDefaultEvents =
	(
		EventsCombiner.events_classes[#DEFAULTS] = ( (DefaultEvents_v ini_path:ini_path ).getEvents(this._Rollout.getFullId()) )
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
		 if( this._eventHasParameters(event_type) ) then "val" else ""
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