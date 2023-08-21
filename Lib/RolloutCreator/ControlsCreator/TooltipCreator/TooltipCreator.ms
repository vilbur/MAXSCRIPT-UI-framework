/** Tooltip creator
 */
struct TooltipCreator_v
(
	/* properties */
	--_Control,

	/** Add tooltips
	 */
	function addTooltips &_Control =
	(
		--format "\n"; print "TooltipCreator_v.addTooltips()"
		--this._Control = _Control

		if( tooltip = this._getTooltipsOfEvents(_Control) ) != "" then
			_Control.params.setVal (#tooltip) (tooltip)

		_Control --return
	),

	private

	/** Get tooltips of events
	 */
	function _getTooltipsOfEvents _Control =
	(
		--format "\n"; print "TooltipCreator_v.getTooltipsOfEvents()"
		tooltip = if( tooltip_param = _Control.params.getVal #tooltip ) != undefined then tooltip_param + "\n" else ""

		for Event_data in _Control.Events where (event_tooltip = Event_data.value.tooltip) != "" do
			tooltip += this._getEventPrefix(Event_data.value.type) + event_tooltip + "\n"

		trimRight tooltip "\n" --return
	),

	/** Get event type
	 */
	function _getEventPrefix event_type =
	(
		--format "\n"; print "TooltipCreator_v.getEventType()"
		case event_type of
		(
			(#pressed):	"LMB:  "
			(#rightclick):	"\nRMB: "
			default:	""
			--default:	"On " + this._capitalize(event_type as string ) + ": "
		)
	),

	/** Capitalize first letter
	 */
	function _capitalize _string =
	(
		toUpper (substring _string 1 1) + substring _string 2 _string.count -- add it back to the rest of the string
	),

	/**
	 */
	on create do
	(
		--print("TooltipCreator_v.onCreate()")
	)
)