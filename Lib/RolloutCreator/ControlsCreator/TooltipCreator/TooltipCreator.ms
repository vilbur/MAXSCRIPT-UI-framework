/** Tooltip creator
 */
struct TooltipCreator_v
(
	/* properties */

	/** Add tooltips
	 */
	function addTooltip &_Control event_type =
	(
		--format "\n-----------------------------\n"
		--format "\n"; print "TooltipCreator_v.addTooltip()"
		events_count = _Control.Events.keys.count

		if ( tooltip_of_event = _Control.Events[event_type].tooltip ) != "" then
		(
			delimeter = case _Control.type of
			(
				#imgtag: "    ||    " -- IMAGE
				default: "\n\n"
			)
			
			prefix = if events_count > 1 then this._getEventPrefix(_Control.type)(event_type) else ""
			
			tooltip_prevoious = if( tooltip_param = _Control.params[#tooltip] ) != undefined then tooltip_param + delimeter else ""
			
			
			/* RE-SET TOOLTIP BACK TO PARAMS */ 
			_Control.params[#tooltip] = ( tooltip_prevoious + prefix + tooltip_of_event )
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