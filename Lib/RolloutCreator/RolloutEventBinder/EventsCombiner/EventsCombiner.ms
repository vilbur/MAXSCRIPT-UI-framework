/** Combine code of events to single string of code
  * 
  * 
  * 
 */
struct EventsCombiner_v
(
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"
	/*
	   change variable names of keys and values
		
	*/
	classes = this.keys,	-- E.G.: #(#CUSTOM,	#DEFAULT,	#POST)  
	events  = this.values, 	-- E.G.: #(#(Events),	#(Events),	#(Events))
	
	/** Merge callbacks for each class of events
	  *
	  * @property	#name	event_type	#pressed|#rightclick|#changed etc.
	  *
	  * @return	Event_v|undefined 	if event has not callback fn then return undefined
	 */
	function combine event_type =
	(
		--print ( "EventsCombiner_v.combine() " + event_type as string )
		Event_combined = (Event_v type:event_type)
 
		for event_class in this.classes where (Events = this._getEventsOfType(event_class)(event_type)) != undefined do
			this._mergeEvents (Events) (Event_combined)
		
		--format "EVENT_COMBINED	= % \n" Event_combined			
		if( Event_combined.code != "" ) then 
			Event_combined --return
	),
	
	/** Get events
	 */
	function combineOrGetNewEvent event_type =
	(
		--print "EventsCombiner_v.combineOrGetNewEvent()"
		if( (Event = this.combine(event_type)) == undefined ) then
			Event	= (Event_v type:event_type)
		
		Event --return
	),
	
	/** Set events
	 */
	function setEventsClass event_class Events_array =
	(
		--print "EventsCombiner_v.setEvents()"
		this.setVal event_class Events_array
	),
	
	
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
				--if Event.params != "" then 
					--Event_combined.params	+= Event.params + " "
		
				/* TOOLTIP */ 
				Event_combined.tooltip	+= Event.tooltip
			)
		
		Event_combined --return
	),
	
	/** Get event
	 */
	function _getEventsOfType event_class event_type =
	(
		--print "EventsCombiner_v.getEvent()"
		if( (Events = this.getVal(event_class)) != undefined ) then 
			(for Event in Events where Event.type == event_type collect Event)
	),

	/**  
	 */
	on create do
	(
		--print("Events_v.onCreate()")
	)
)