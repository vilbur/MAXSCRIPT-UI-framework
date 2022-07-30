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
	_Control,
	
	/** Add tooltips
	 */
	function addTooltips &_Control =
	(
		--format "\n"; print "TooltipCreator_v.addTooltips()"
		--format "_Control.Events.List	= % \n" _Control.Events.List
		this._Control = _Control

		this._Control.params.setVal #tooltip (this._getTooltipsOfEvents())
		
		this._Control --return 
	),

	private
	
	/** Get tooltips of events
	 */
	function _getTooltipsOfEvents =
	(
		--format "\n"; print "TooltipCreator_v.getTooltipsOfEvents()"
		Events = this._Control.Events.List
		
		tooltip = if( tooltip_param = _Control.params.getVal #tooltip ) != undefined then tooltip_param + "\n" else ""
		
		for Event in Events do 
			tooltip += this._getEventPrefix(Event.type) + Event.tooltip + "\n"
			
		trimRight tooltip "\n" --return
	),
	
	/** Get event type
	 */
	function _getEventPrefix event_type =
	(
		--format "\n"; print "TooltipCreator_v.getEventType()"
		if this._Control.Events.List.count > 1 then 
			case event_type of
			(
				(#pressed):	"LMB: "	
				(#rightclick):	"RMB: "	
				default:	event_type as string 
			)
		else
			"" --return
	),
	
	/**  
	 */
	on create do
	(
		--print("TooltipCreator_v.onCreate()")
		--ConstructPropeties test:this
	)
)