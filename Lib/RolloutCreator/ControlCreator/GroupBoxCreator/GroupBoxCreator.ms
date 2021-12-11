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
	margin	= 8,
	padding	= [32, 8],
	_first_control_offset_y	= 16,
	--padding_control_top	= 16,
	_control_default_height	= 24,
	
	/** Test
	 */
	function sortControlsToGroupBoxes rollout_id =
	(
		--print ("GroupBoxCreator_v.sortControlsToGroupBoxes()" + rollout_id as string )
		if( GroupBoxes != undefined ) then
			for i = GroupBoxes.keys.count to 1 by -1 do
				this._sortControlsInGroupBox(rollout_id)(GroupBoxes.keys[i])(GroupBoxes.values[i])
	),

	private

	/** _sort controls in group box
	 */
	function _sortControlsInGroupBox rollout_id groupbox_id groupbox_controls_ids =
	(
		--format "\n"; print ("GroupBoxCreator_v._sortControlsInGroupBox() " +groupbox_id)
		--format "groupbox_controls_ids	= % \n" groupbox_controls_ids
		_groupbox = execute (rollout_id+"."+groupbox_id as string )

		controls_in_rollout = execute(rollout_id+".controls")

		control_position = this._getControlBoxPosition(_groupbox.pos)
		
		groupbox_controls = for i = 1 to controls_in_rollout.count where findItem groupbox_controls_ids (this._getControlId(controls_in_rollout[i])) > 0 collect controls_in_rollout[i]
		
		for groupbox_control in groupbox_controls do
		
			this._moveControlToGroupbox (groupbox_control)(control_position)

		this._setGroupBoxSize (rollout_id) (groupbox_controls) (_groupbox)(groupbox_id)
	),

	/** _set group box dimensions
	 */
	function _setGroupBoxSize rollout_id groupbox_controls _groupbox groupbox_id =
	(
		--format "\n"; print "GroupBoxCreator_v._setGroupBoxSize()"
		local _rollout  = execute(rollout_id as string )
		local _groupbox = execute(rollout_id+"."+groupbox_id as string )

		next_control = this._getNextControlToGroupBox(_rollout.controls)(groupbox_id)

		is_next_control_in_same_row = this._isNextControlInSameRow (next_control) ( _groupbox.pos.y)
		
		this._setGroupboxWidth  (_rollout) (_groupbox) (next_control) (is_next_control_in_same_row)
		this._setGroupboxHeight (_rollout) (_groupbox) (next_control) (is_next_control_in_same_row)
	),
	
	/** _set groupbox width
	 */
	function _setGroupboxWidth _rollout _groupbox next_control is_next_control_in_same_row =
	(
		--format "\n"; print "GroupBoxCreator_v._setGroupboxWidth()"
		if width_is_default = _groupbox.width == 90 do -- 90px is default width of groupbox
		
			if is_next_control_in_same_row then
				_groupbox.width	= next_control.pos.x - _groupbox.pos.x - groupbox_margin  -- set width up to next control in row
		
			else
				_groupbox.width = _rollout.width - _groupbox.pos.x - groupbox_margin -- set width up to rollout border
	),
	
	/** _set groupbox height
	 */
	function _setGroupboxHeight _rollout _groupbox next_control is_next_control_in_same_row =
	(
		--format "\n"; print ("GroupBoxCreator_v._setGroupboxHeight() " + _groupbox as string )
		--format "_groupbox.height	= % \n" _groupbox.height
		if height_is_default = _groupbox.height == GROUPBOX_DEFAULT_HEIGHT do -- 90px is default width of groupbox
		
			if next_control == undefined then -- if control is last
				_groupbox.height = _rollout.height - _groupbox.pos.y - groupbox_margin
			
			if is_next_control_in_same_row then
				_groupbox.height	=  (this._getControlSize (next_control))
			
			else if next_control != undefined then -- if next control is on next row
				_groupbox.height = next_control.pos.y - _groupbox.pos.y - groupbox_margin
	),
	
	/** _is next control in same row
	 */
	function _isNextControlInSameRow next_control groupbox_pos_y =
	(
		--format "\n"; print "GroupBoxCreator_v._isNextControlInSameRow()"
		if next_control != undefined then
			next_control_pos_y	= next_control.pos.y
		
		next_control != undefined and (next_control_pos_y <= groupbox_pos_y +20 and next_control_pos_y >= groupbox_pos_y - 20) -- return 
	),
	/** _get group box position
	 */
	function _getControlBoxPosition control_position =
	(
		--format "\n"; print "GroupBoxCreator_v._getControlBoxPosition()"
		control_position.x += padding.x
		control_position.y += _first_control_offset_y + padding.y

		control_position -- return
	),

	/** _move control to groupbox
	 */
	function _moveControlToGroupbox _control &control_position =
	(
		--format "\n"; print "GroupBoxCreator_v._moveControlToGroupbox()"
		_control.pos = next_control_position = control_position

		next_control_position.y +=  try( _control.height ) catch(_control_default_height)
		next_control_position.y +=  margin 

		next_control_position --return
	),

	/** Get ntrol size
	 */
	function _getControlSize _control =
	(
		--format "\n"; print "GroupBoxCreator_v._getControlSize()"
		--format "_control	= % \n" _control

		control_height = try( _control.height ) catch()
		--format "control_height	= % \n" control_height
		case this._getControlType(_control) of
		(
			(#GroupboxControl):	control_height
			(#buttonControl):	_control_default_height
			(#ListBoxControl):	this. _getListboxHeight(_control)
			(#MultiListBoxControl):	this. _getListboxHeight(_control)

			default:	control_height +  groupbox_margin
		)
	),

	/** listbox without caption is shifted up
	 */
	function _getListboxHeight _control =
	(
		--format "\n"; print "GroupBoxCreator_v._getListboxHeight()"
		if _control.caption == "" then _control.height else _control.height + 16
	),

	/** Find next control after groupbox
	  *
	  * 	This control MUST NOT be in another groupbox
	 */
	function _getNextControlToGroupBox controls_in_rollout groupbox_id =
	(
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

	--/** _get bbox width
	-- */
	--function _getBboxWidth groupbox_controls =
	--(
	--	--format "\n"; print "GroupBoxCreator_v._getControlsBoundingBox()"
	--	max_width  = 0
	--
	--	for groupbox_control in groupbox_controls do
	--		max_width += if (_control_width = try( _control.width ) catch(128)) >  max_width then _control_width else 0
	--
	--	max_width  --return
	--),
	--
	--/** _get bbox height
	-- */
	--function _getBboxHeight groupbox_controls =
	--(
	--	--format "\n"; print "GroupBoxCreator_v._getBboxHeight()"
	--	max_height  = 0
	--
	--	for groupbox_control in groupbox_controls do
	--		max_height += try( _control.height ) catch(_control_default_height)
	--
	--	max_height  --return
	--),

	/**  
	 */
	on create do
	(

	)
)

global GroupBoxCreator = GroupBoxCreator_v()