/** Combine code of events to single string of code
  *
  *
 */
struct EventsCombiner_v
(

	EventsLists = Dictionary(), -- EventsLists[#CUSTOM][#OPEN] = #( Event_v )
	
	/** Merge callbacks for each class of events
	  *
	  * @property	#name	event_type	#pressed|#rightclick|#changed etc.
	  *
	  * @return	Event_v|undefined 	if event has not callback fn then return undefined
	 */
	function combine event_type =
	(
		--format "\n\n";	print ( "EventsCombiner_v.combine() #" + toUpper (event_type as string ))

		/* ONLY DEFAULT #RESIZE EVENT IS BINDED
		   
		    CUSTOM #RESIZE |#DOCK | #UNDOCKED EVENT IS FIRED IN  "./../DefaultEvents/Callbacks/waitForResizingEnds.ms"
		*/
		custom_or_defaults = if event_type == #RESIZED then #(#DEFAULTS) else #( #DEFAULTS, #CUSTOM )
		
		Event_combined = undefined 
	
		Events_to_combine = #()
		--format "EventsLists[#DEFAULTS]: %\n" EventsLists[#DEFAULTS]

		/* GET EVENTS OF TYPE */ 
		--Events = for custom_or_default in EventsLists.keys where EventsLists[custom_or_default] != undefined and (Event = EventsLists[custom_or_default][event_type])!= undefined collect Event
		for custom_or_default in custom_or_defaults \
			where EventsLists[custom_or_default] != undefined \
				and EventsLists[custom_or_default][event_type] != undefined \
				and ( Events = EventsLists[custom_or_default][event_type] ).count > 0 do
					join Events_to_combine Events
		
		
		if( Events_to_combine.count > 0 ) then
		(
			
			--format "\n\n";	print ( "EventsCombiner_v.combine() #" + toUpper (event_type as string ))
			--format "Events_to_combine: %\n" Events_to_combine
			
			Event_combined = this._mergeEvents (Events_to_combine)(event_type)
	
			if event_type == #okToClose then
				Event_combined.callback += "\n\n	true -- IMPORTANT - #oktoclose MUST RETURN BOOLEAN"
		
			--if( Event_combined.callback != "" ) then
			--format "EVENT_COMBINED: %\n" Event_combined
			--format "EVENT_COMBINED: %\n" Event_combined.callback
			Event_combined --return
		)
	),


	private


	/** Combine events
	 */
	function _mergeEvents Events event_type =
	(
		--format "\n"; print "EventsCombiner_v._mergeEvents()"
		--format "Events	= % \n" Events
		Event_combined = Event_v type:event_type

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