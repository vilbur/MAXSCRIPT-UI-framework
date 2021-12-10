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
	groupbox_size_fix	= 21,
	--padding_control_top	= 16,
	controls_in_rollout,

	/** Test
	 */
	function sortControlsToGroupBoxes rollout_id =
	(
		print "GroupBoxCreator_v.sortControlsToGroupBoxes()"
		format "rollout_id	= % \n" rollout_id
		if( GroupBoxes != undefined ) then
			for i = 1 to GroupBoxes.keys.count where ( groupbox_id = GroupBoxes.keys[i] ) != "" do
				if( (controls_count =  GroupBoxes.values[i].count) > 0  ) then
					this._sortControlsInGroupBox(rollout_id)(groupbox_id)(GroupBoxes.values[i])
	),

	private

	/** _sort controls in group box
	 */
	function _sortControlsInGroupBox rollout_id groupbox_id groupbox_controls =
	(
		format "\n"; print ("GroupBoxCreator_v._sortControlsInGroupBox() " +groupbox_id)
		format "groupbox_controls	= % \n" groupbox_controls
		_groupbox = execute (rollout_id+"."+groupbox_id as string )
		groupbox_position =_groupbox.pos

		control_position = groupbox_position

		for c = 1 to groupbox_controls.count where  ( control_id = groupbox_controls[c] ) != ""  do
			this._moveControlToGroupbox (rollout_id+"."+control_id)(control_position)

		this._setGroupBoxSize (execute(rollout_id+".controls")) (groupbox_controls) (_groupbox)

	),

	/** _move control to groupbox
	 */
	function _moveControlToGroupbox control_id_full &control_position =
	(
		--format "\n"; print "GroupBoxCreator_v._moveControlToGroupbox()"
		this._setParameter control_id_full #pos control_position

		control_position.y += this._getParameter(control_id_full)(#height) default:(21)

		control_position --return
	),

	/** _set group box dimensions
	 */
	function _setGroupBoxSize controls_in_rollout groupbox_controls _groupbox =
	(
		format "\n"; print "GroupBoxCreator_v._setGroupBoxSize()"
		format "!!!!!!!!"
		format "_groupbox	= % \n" _groupbox

		if ( _groupbox_width = _groupbox.width ) == 90 then -- 90px is default width of groupbox 
		(

			if( ( next_control = this._getNextControlToGroupBox(controls_in_rollout)(controls_in_rollout)(this._getControlId(_groupbox)) ) != undefined ) then
				_groupbox.width = next_control.pos.x - _groupbox.pos.x - groupbox_margin

		)

		--this._setParameter(rollout_id+"."+groupbox_id)(#width) (groupbox_size.x - groupbox_size_fix)
	),

	/** _get groupbox height
	 */
	function _getNextControlHeight next_control =
	(
		format "\n"; print "GroupBoxCreator_v._getNextControlHeight()"

		control_type = this._getControlType( next_control)

		next_control.height

	),

	/** _set parameter
	 */
	function _setParameter control_id_full param val =
	(
		--print "GroupBoxCreator_v._setParameter()"
		execute (control_id_full+"."+param as string +" = "+(val) as string)
	),

	/** _set parameter
	 */
	function _getParameter control_id_full param default:undefined =
	(
		if ((val =  try(execute (control_id_full+"."+param as string ) )  catch() ) == undefined ) then
			val = default
		--print "GroupBoxCreator_v._setParameter()"
		val --return
	),
	/** Find next control after groupbox
	  * This control must not be in another groupbox
	  *
	 */
	function _getNextControlToGroupBox groupbox_controls controls_in_rollout groupbox_id =
	(
		--format "controls_in_rollout	= % \n" controls_in_rollout
		format "groupbox_controls	= % \n" groupbox_controls
		local current_control_index
		local next_control_index

		for i = 1 to controls_in_rollout.count where this._getControlId(controls_in_rollout[i]) == groupbox_id do current_control_index = i
	
		                                           /* start loop up current control */
		for i = 1 to controls_in_rollout.count where i >= current_control_index and this._controlIsInGroupbox (controls_in_rollout[i+1]) == false  do
			if( next_control_index == undefined ) then -- get only first occurence
				next_control_index = i+1

		if( next_control_index != undefined ) then
			controls_in_rollout[next_control_index] --return 
	),

	/** _is controlin groupbox
	 */
	function _controlIsInGroupbox next_control =
	(
		--format "\n"; print "GroupBoxCreator_v._controlIsInGroupbox()"
		is_in_groupbox = false

		for groupbox_controls in GroupBoxes.values where findItem groupbox_controls (this._getControlId(next_control)) > 0 do is_in_groupbox = true

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