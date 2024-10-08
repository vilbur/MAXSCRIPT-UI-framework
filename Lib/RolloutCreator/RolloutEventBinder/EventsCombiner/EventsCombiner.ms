/** Combine code of events to single string of code
  *
  *
 */
struct EventsCombiner_v
(

	EventsLists = Dictionary(), --{ keys: #CUSTOM|#DEFAULT|#POST, values:#(EVENTS)  }

	/** Merge callbacks for each class of events
	  *
	  * @property	#name	event_type	#pressed|#rightclick|#changed etc.
	  *
	  * @return	Event_v|undefined 	if event has not callback fn then return undefined
	 */
	function combine event_type =
	(
		--format "\n";	print ( "EventsCombiner_v.combine() " + event_type as string )

		if event_type != #RESIZED then
		(
			Events = for key in EventsLists.keys where EventsLists[key] != undefined and (Event = EventsLists[key].get(event_type))!= undefined collect Event
			--Events = for key in EventsLists.keys where EventsLists[key] != undefined collect EventsLists[key]

			if( Events.count > 0 ) then
			(
				Event_combined = this._mergeEvents (Events)

				if( Event_combined.callback != "" ) then
				(
					if event_type == #okToClose then
						Event_combined.callback += "\n\n	true -- IMPORTANT - #oktoclose MUST RETURN BOOLEAN"

					Event_combined --return
				)
			)
		)

		else /* CUSTOM RESIZE EVENT IS FIRED BY findResizeEventType(), binded is only default */
			if this.EventsLists[#DEFAULTS] != undefined then
			this.EventsLists[#DEFAULTS].get(#RESIZED)
	),

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
	function _mergeEvents Events =
	(
		--format "\n"; print "EventsCombiner_v._mergeEvents()"
		--format "Events	= % \n" Events
		Event_combined = (Event_v type:Events[1].type)

		for Event in Events do
		(
			--format "\n"; print "EventsCombiner_v._mergeEvent()"
			--format "Event.callback: %\n" Event.callback

			--format "Event.type: %\n" Event.type
			--format "\n-----------------------\n"
			--format "Event.callback: %\n" Event.callback
			--format "\n-----------------------\n"
			--format "Event_combined.callback: %\n" Event_combined.callback
			--format "\n-----------------------\n"
			/* CODE */
			if Event.callback != "" then
				Event_combined.callback	+= "\n	"+Event.callback
				--Event_combined.callback	+= Event.callback + ";"

			/* PARAMS */
			if Event.params != "" then
				Event_combined.params	+= Event.params + " "

			/* TOOLTIP */
			Event_combined.tooltip	+= Event.tooltip
		)
		--format "\n\nEVENT_COMBINED: %\n" Event_combined

		Event_combined --return
	),

	/** Get event
	 */
	function _getEventsOfType List event_type =
	(
		--if (Events = this.EventsLists[List]) != undefined then
			(for Event in List.Events where Event.type == event_type collect Event)
	),

	/**
	 */
	on create do
	(
		--print("Events_v.onCreate()")
	)
)