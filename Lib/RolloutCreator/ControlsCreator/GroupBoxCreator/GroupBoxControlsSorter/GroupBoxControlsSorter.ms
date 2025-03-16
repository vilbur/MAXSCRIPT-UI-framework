/** Sort controls in groupbox
 */
struct GroupBoxControlsSorter_v
(
	--__construct = #( #property_name ),
	/* properties */
	padding	= [32, 8],
	margin	= 8,
	_first_control_offset_y	= 16,
	_control_default_height	= 24,

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */


	/** Sort controls in group box
	  *
	  * @return	array controls in groupbox
	 */
	function sortControlsInGroupBox GroupboxControl groupbox_controls =
	(
		--format "\n"; print "GroupBoxControlsSorter_v._sortControlsInGroupBox()"
		--format "GroupboxControl	= % \n" GroupboxControl
		--format "groupbox_controls	= % \n" groupbox_controls

		control_position = this._getControlBoxPosition(GroupboxControl.pos) -- get position of first control in groupbox
		--format "control_position	= % \n" control_position
		for groupbox_control in groupbox_controls do
			this._moveControlToGroupbox (groupbox_control)(control_position)

	),


	private


	/** _get group box position
	 */
	function _getControlBoxPosition control_position =
	(
		--format "\n"; print "GroupBoxControlsSorter_v._getControlBoxPosition()"
		control_position.x += padding.x
		control_position.y += _first_control_offset_y + padding.y

		control_position -- return
	),

	/** _move control to groupbox
	 */
	function _moveControlToGroupbox _control &control_position =
	(
		--format "\n"; print "GroupBoxControlsSorter_v._moveControlToGroupbox()"
		--format "_control	= % \n" _control
		_control.pos = next_control_position = control_position

		next_control_position.y +=  try( _control.height ) catch(_control_default_height)
		--next_control_position.y +=  _control_default_height
		next_control_position.y +=  margin
		--
		next_control_position --return
	),


	/**
	 */
	on create do
	(
		--print("GroupBoxControlsSorter_v.onCreate()")
		--ConstructPropeties test:this
	)
)