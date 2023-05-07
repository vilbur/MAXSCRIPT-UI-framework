/** Events default
 */
struct DefaultControlEvents_v
(
	/* properties */

	/** Add default event for Control
	  *
	  * @return	array of Events
	 */
	function getEvents _Control =
	(
		Events = #()

		--print ("DefaultControlEvents_v.getEvents() "+_Control.type)
		if( _Control.type == #browsePath ) then
			Events = (BrowsePath_v()).getEvents(_Control)-- "./../../ControlTypes/BrowsePath/BrowsePath.ms"

		else if( _Control.type == #RadioButtons ) then
			Events = (RadioButtons_v()).getEvents(_Control) -- "./../../ControlTypes/RadioButtons/RadioButtons.ms"

		Events --return
	),

	/**
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)

)
