/** Tooltip creator
 */
struct TooltipCreator_v
(
	/* properties */

	/** Add tooltips
	 */
	function addTooltip &_Control event_type =
	(
		--format "\n"; print "TooltipCreator_v.addTooltip()"
		 event_tooltip = _Control.Events[event_type].tooltip

		if ( event_tooltip = _Control.Events[event_type].tooltip ) != "" then
		(
			tooltip = if( tooltip_param = _Control.params.getVal #tooltip ) != undefined then tooltip_param + "\n" else ""

			if tooltip != "" then
				tooltip += "\n"

			_Control.params.setVal #tooltip ( tooltip + this._getEventPrefix(_Control.type)(event_type) + event_tooltip )
		)

		_Control --return
	),
	private

	/** Get event type
	 */
	function _getEventPrefix control_type event_type =
	(
		--format "\n"; print "TooltipCreator_v._getEventPrefix()"
		--format "event_type:	% \n" event_type
		if control_type == #CHECKBUTTON and event_type == #CHANGED then
			"LMB: " --return #CHECKBUTTON:changed
		else
			case event_type of
			(
				(#pressed):	"LMB: "
				(#rightclick):	"RMB: "
				--default:	""
				default:	this._capitalize(event_type as string ) + ": "
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