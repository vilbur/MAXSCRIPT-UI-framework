/** Tooltip creator
 */
struct TooltipCreator_v
(
	--__construct = #( #property_name ),
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	
	/** Add tooltips
	 */
	function addTooltips &_Control =
	(
		--format "\n"; print "TooltipCreator_v.addTooltips()"
		--format "_Control.Events.List	= % \n" _Control.Events.List

		_Control.params.setVal "tooltip" (this._getTooltipsOfEvents(_Control.Events.List))
		
		_Control --return 
	),

	private
	
	/** Get tooltips of events
	 */
	function _getTooltipsOfEvents Events =
	(
		--format "\n"; print "TooltipCreator_v.getTooltipsOfEvents()"
		tooltip = ""
		
		for Event in Events do 
			tooltip += this._getEventType(Event.type) +": "+ Event.tooltip + "\n"
			
			
		trimRight tooltip "\n" --return
	),
	
	/** Get event type
	 */
	function _getEventType event_type =
	(
		--format "\n"; print "TooltipCreator_v.getEventType()"
		case event_type of
		(
			(#pressed):	"LMB"	
			(#rightclick):	"RMB"	
			default:	event_type as string 
		)
	),
	
	/**  
	 */
	on create do
	(
		--print("TooltipCreator_v.onCreate()")
		--ConstructPropeties test:this
	)
)