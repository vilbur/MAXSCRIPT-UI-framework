/** Combine code of events to single string of code
  *
  *
 */
struct EventsCombiner_v
(

	events_classes = Dictionary(), --{ keys: #CUSTOM|#DEFAULT|#POST, values:#(EVENTS)  }

	/** Merge callbacks for each class of events
	  *
	  * @property	#name	event_type	#pressed|#rightclick|#changed etc.
	  *
	  * @return	Event_v|undefined 	if event has not callback fn then return undefined
	 */
	function combine event_type =
	(
		--format "\n";	print ( "EventsCombiner_v.combine() " + event_type as string )

		if event_type != #resized then
		(
			Event_combined = (Event_v type:event_type)

			for event_class in this.events_classes where (Events = this._getEventsOfType(event_class.key)(event_type)) != undefined do
				this._mergeEvents (Events) (Event_combined)

			if( Event_combined.code != "" ) then
				Event_combined --return
		)
		else
		(
			/* CUSTOM RESIZE EVENT IS FIRED BY findResizeEventType(), binded is only default */
			for Event in this.events_classes[#DEFAULTS] where Event.type == #resized do return Event

		)
	),
	--
	--/** Get events
	-- */
	--function combineOrGetNewEvent event_type =
	--(
	--	--print "EventsCombiner_v.combineOrGetNewEvent()"
	--	if( (Event = this.combine(event_type)) == undefined ) then
	--		Event	= (Event_v type:event_type)
	--
	--	Event --return
	--),


	private


	/** Combine events
	 */
	function _mergeEvents Events &Event_combined =
	(
		--format "\n"; print "EventsCombiner_v._mergeEvents()"
		--format "Events	= % \n" Events

		if( Events.count > 0 ) then
			for Event in Events do
			(
				/* CODE */
				if Event.code != "" then
					Event_combined.code	+= "\n"+Event.code + ";"
					--Event_combined.code	+= Event.code + ";"

				/* PARAMS */
				if Event.params != "" then
					Event_combined.params	+= Event.params + " "

				/* TOOLTIP */
				Event_combined.tooltip	+= Event.tooltip
			)

		Event_combined --return
	),

	/** Get event
	 */
	function _getEventsOfType event_class event_type =
	(
		if (Events = this.events_classes[event_class]) != undefined then
			(for Event in Events where Event.type == event_type collect Event)
	),

	/**
	 */
	on create do
	(
		--print("Events_v.onCreate()")
	)
)