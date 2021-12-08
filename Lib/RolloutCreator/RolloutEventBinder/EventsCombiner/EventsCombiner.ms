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
			Event	= this._getEvent event_class event_type
		
			Event_combined.tooltip	+= "\n"+ Event.tooltip
			Event_combined.code	+= "\n"+ Event.code
			Event_combined.params	+= " " + Event.params
		)

		--format "Event_combined	= % \n\t\t" Event_combined
		Event_combined --return
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
		Events	=   this.getVal event_class

		(for Event in Events where Event.type == event_type collect Event)[1]
	),

	/**  
	 */
	on create do
	(
		--print("Events_v.onCreate()")
	)
)