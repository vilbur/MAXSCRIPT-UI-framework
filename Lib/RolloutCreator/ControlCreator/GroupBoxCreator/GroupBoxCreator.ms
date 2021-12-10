/** Group box creator
 */
struct GroupBoxCreator_v
(
	GroupBoxes,
	/* required */
	/* dependency */
	/* reference */
	/* properties */

	groupbox_margin	= 16,
	--padding_top	= 16,
	--groupbox_size_fix	= 21,
	--padding_control_top	= 16,
	_control_default_height	= 24,
	controls_in_rollout,

	/** Test
	 */
	function sortControlsToGroupBoxes rollout_id =
	(
		print ("GroupBoxCreator_v.sortControlsToGroupBoxes()" + rollout_id as string )
		if( GroupBoxes != undefined ) then
			for i = GroupBoxes.keys.count to 1 by -1 do
				if( GroupBoxes.values[i].count > 0  ) then
					this._sortControlsInGroupBox(rollout_id)(GroupBoxes.keys[i])(GroupBoxes.values[i])
	),

	private

	/** _sort controls in group box
	 */
	function _sortControlsInGroupBox rollout_id groupbox_id groupbox_controls_ids =
	(
		format "\n"; print ("GroupBoxCreator_v._sortControlsInGroupBox() " +groupbox_id)
		format "groupbox_controls_ids	= % \n" groupbox_controls_ids

		controls_in_rollout = execute(rollout_id+".controls")

		groupbox_controls = for i = 1 to controls_in_rollout.count where findItem groupbox_controls_ids (this._getControlId(controls_in_rollout[i])) > 0 collect controls_in_rollout[i]
		format "groupbox_controls	= % \n" groupbox_controls

		_groupbox = execute (rollout_id+"."+groupbox_id as string )
		groupbox_position =_groupbox.pos

		control_position = groupbox_position

		--for c = 1 to groupbox_controls_ids.count where  ( control_id = groupbox_controls_ids[c] ) != ""  do
		for groupbox_control in groupbox_controls do 
			this._moveControlToGroupbox (groupbox_control)(control_position)

		this._setGroupBoxSize (rollout_id) (groupbox_controls) (_groupbox)(groupbox_id)

	),

	/** _move control to groupbox
	 */
	function _moveControlToGroupbox _control &control_position =
	(
		--format "\n"; print "GroupBoxCreator_v._moveControlToGroupbox()"
		_control.pos = control_position

		control_position.y +=  try( _control.height ) catch(_control_default_height)

		control_position --return
	),

	/** _set group box dimensions
	 */
	function _setGroupBoxSize rollout_id groupbox_controls _groupbox groupbox_id =
	(
		format "\n"; print "GroupBoxCreator_v._setGroupBoxSize()"
		__rollout = execute(rollout_id as string )
		format "_rollout	= % \n" __rollout
		controls_in_rollout = execute(rollout_id+".controls")

		if ( _groupbox_width = _groupbox.width ) == 90 then -- 90px is default width of groupbox 
		(

			if( ( next_control = this._getNextControlToGroupBox(controls_in_rollout)(groupbox_id) ) != undefined ) then
			(
				format "_groupbox	= % \n" _groupbox
				format "next_control	= % \n" next_control

				_groupbox.width	= next_control.pos.x - _groupbox.pos.x - groupbox_margin
				_groupbox.height	= next_control.height

			)
			else
			(
				_groupbox.width	= __rollout.width - _groupbox.pos.x - groupbox_margin
				_groupbox.height	= __rollout.height - _groupbox.pos.y - groupbox_margin
			)

				format "NEXT_CONTROL	= % \n" next_control

		)
	),

	/** _get bbox width
	 */
	function _getBboxWidth groupbox_controls =
	(
		--format "\n"; print "GroupBoxCreator_v._getControlsBoundingBox()"
		max_width  = 0

		for groupbox_control in groupbox_controls do
			max_width += if (_control_width = try( _control.width ) catch(128)) >  max_width then _control_width else 0

		max_width  --return
	),

	/** _get bbox height
	 */
	function _getBboxHeight groupbox_controls =
	(
		--format "\n"; print "GroupBoxCreator_v._getBboxHeight()"
		max_height  = 0

		for groupbox_control in groupbox_controls do
			max_height += try( _control.height ) catch(_control_default_height)

		max_height  --return
	),

	/** Find next control after groupbox
	  * This control must not be in another groupbox
	  *
	 */
	function _getNextControlToGroupBox controls_in_rollout groupbox_id =
	(
		--format "controls_in_rollout	= % \n" controls_in_rollout
		--format "groupbox_controls_ids	= % \n" groupbox_controls_ids
		local next_control_index

		current_control_index = this._currentControlIndex (controls_in_rollout) (groupbox_id)

		                                           /* start loop up current control */
		for i = 1 to controls_in_rollout.count where i >= current_control_index and this._controlIsInGroupbox (controls_in_rollout[i+1]) == false  do
			if( next_control_index == undefined ) then -- get only first occurence
				next_control_index = i+1

		if( next_control_index != undefined ) then
			controls_in_rollout[next_control_index] --return 
	),

	/** _current control index
	 */
	function _currentControlIndex controls_in_rollout groupbox_id =
	(
		local current_control_index

		for i = 1 to controls_in_rollout.count where this._getControlId(controls_in_rollout[i]) == groupbox_id do current_control_index = i

		current_control_index --return
	),

	/** _is controlin groupbox
	 */
	function _controlIsInGroupbox next_control =
	(
		--format "\n"; print "GroupBoxCreator_v._controlIsInGroupbox()"
		is_in_groupbox = false

		for groupbox_controls_ids in GroupBoxes.values where findItem groupbox_controls_ids (this._getControlId(next_control)) > 0 do is_in_groupbox = true

		if( next_control != undefined ) then
			is_in_groupbox --return
	),

	/** _get control id
	 */
	function _getControlId _control =
	(
		--format "\n"; print "GroupBoxCreator_v._getControlId()"
		control_id = (filterString ( _control as string) ":")[2]
		--format "control_id	= % \n" control_id
		control_id --return
	),

	/** _get control id
	 */
	function _getControlType _control =
	(
		--format "\n"; print "GroupBoxCreator_v._getControlId()"
		control_type = (filterString ( _control as string) ":")[1]

		control_type as name --return
	),

	/**  
	 */
	on create do
	(

	)
)

global GroupBoxCreator = GroupBoxCreator_v()