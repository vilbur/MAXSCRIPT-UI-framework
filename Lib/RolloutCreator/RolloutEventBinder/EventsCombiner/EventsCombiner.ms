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
			/* GET EVENTS OF TYPE */ 
			Events = for custom_or_default in EventsLists.keys where EventsLists[custom_or_default] != undefined and (Event = EventsLists[custom_or_default][event_type])!= undefined collect Event
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

		/* ONLY DEFAULT #RESIZE EVENT IS BINDED
		   
		    CUSTOM #RESIZE |#DOCK | #UNDOCKED EVENT IS FIRED IN  "./../DefaultEvents/Callbacks/fireResizeDockUndockEvents.ms"
				
		*/
		else if this.EventsLists[#DEFAULTS] != undefined then
			this.EventsLists[#DEFAULTS][#RESIZED]
	),


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