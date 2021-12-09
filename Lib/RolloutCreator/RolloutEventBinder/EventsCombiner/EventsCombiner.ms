/** EventsBinder
 */
struct EventsCombiner_v
(
	
	/* ListBody is defining these variables
	   
		this.keys	= #(#CUSTOM,	#DEFAULT,	#POST)  
		this.values 	= #(#(Events),	#(Events),	#(Events))  
	*/
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"
	
	/** Get events
	  *
	  * @property	#name	event_type	#pressed|#rightclick|#changed etc.
	  *
	 */
	function combine event_type =
	(
		--print ( "EventsCombiner_v.combine() " + event_type as string )
		Event_combined = (Event_v type:event_type)
 
		for event_class in this.keys do
		(
			
			if( (Event = this._getEvent(event_class)(event_type)) != undefined and Event.code !="" ) then
			(
				Event_combined.tooltip	+= ""+ Event.tooltip
				Event_combined.code	+= ""+ Event.code
				Event_combined.params	+= " " + Event.params
			)
		)

		--format "Event_combined	= % \n\t\t" Event_combined
		if( Event_combined.code != "" ) then 
			Event_combined --return
	),
	
	/** Get events
	  *
	  *
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
	function setEventsClass event_type Events_array =
	(
		--print "EventsCombiner_v.setEvents()"
		this.setVal event_type Events_array
	),
	
	
	private
	
	/** Get event
	 */
	function _getEvent event_class event_type =
	(
		--print "EventsCombiner_v.getEvent()"
		if( (Events = this.getVal(event_class)) != undefined ) then 
			(for Event in Events where Event.type == event_type collect Event)[1]
	),

	/**  
	 */
	on create do
	(
		--print("Events_v.onCreate()")
	)
)