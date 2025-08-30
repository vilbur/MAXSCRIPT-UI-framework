/** Sort controls in groupbox
 */
struct GroupBoxControlsSorter_v
(
	--__construct = #( #property_name ),
	/* properties */
	padding	= [32, 8],
	margin	= 8,
	rollout_width,
	
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
	function sortControlsInGroupBox rollout_id GroupboxControl groupbox_controls =
	(
		format "\n"; print "GroupBoxControlsSorter_v._sortControlsInGroupBox()"
		format "\n          DISABLED\n"
		--format "ROLLOUT_ID: %\n" rollout_id
		--format "TEST: %\n" (execute (rollout_id+".width"))
		--
		--rollout_width = execute (rollout_id+".width")
		--
		--/* GET INIT POSITION OF CONTROLS IN GROUPBOX - top left corner of groupbox */ 
		--control_position = this._getControlBoxPosition(GroupboxControl.pos) -- get position of first control in groupbox
		--
		--/* MOVE CONTROLS ON POSTIONS */ 
		--for groupbox_control in groupbox_controls do
		--	this._moveControlToGroupbox (groupbox_control)(control_position)
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
		format "\n"; print "GroupBoxControlsSorter_v._moveControlToGroupbox()"
		--format "_control: %\n" _control
		
		/*------------------------------------------------------------------------------
			SET CONTROL POSITION 
		--------------------------------------------------------------------------------*/
		control_pos_current = copy control_position
		
		if classOf _control == SpinnerControl then
			control_pos_current.x += _control.pos.x 

		_control.pos = control_pos_current
		

		/*------------------------------------------------------------------------------
			NEXT CONTROL POSITION 
		--------------------------------------------------------------------------------*/
		control_position.y +=  try( _control.height ) catch(_control_default_height)

		control_position.y +=  margin
		
		control_position --return
	),


	/**
	 */
	on create do
	(
		--print("GroupBoxControlsSorter_v.onCreate()")
		--ConstructPropeties test:this
	)
)