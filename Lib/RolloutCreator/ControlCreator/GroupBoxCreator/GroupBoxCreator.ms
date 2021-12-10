/** Group box creator
 */
struct GroupBoxCreator_v
(
	GroupBoxes,
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	padding_top	= 16,
	groupbox_size_fix	= 21,
	padding_control_top	= 16,
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
		--format "groupbox_id	= % \n" groupbox_id
		controls_count = groupbox_controls.count

		groupbox_position = execute (rollout_id+"."+groupbox_id  as string +".pos")
		--format "groupbox_position	= % \n" groupbox_position 
		next_control = this._getNextControlToGroupBox(groupbox_controls)(rollout_id)(groupbox_id)
		format "NEXT_CONTROL	= % \n" next_control
		groupbox_size = this._getSizeValues (next_control) (controls_count)
		
		this._setGroupBoxSize (rollout_id+"."+groupbox_id)(groupbox_size)

		for c = 1 to groupbox_controls.count where  ( control_id = groupbox_controls[c] ) != ""  do
			this._moveControlToGroupbox (rollout_id+"."+control_id)(groupbox_position)(groupbox_size.y / controls_count)( c )
	),

	/** _move control to groupbox
	 */
	function _moveControlToGroupbox control_id_full control_position control_row_height c =
	(
		format "\n"; print "GroupBoxCreator_v._moveControlToGroupbox()"
		control_width = this._getParameter(control_id_full)(#width)(96)

		control_height = this._getParameter(control_id_full)(#height)(21)

		--if( (control_type = (filterString control_id "_")[1] as name ) == #dropdownlsit ) then 
			--control_height = 24

		if( c > 1 ) then
			control_position.y +=  (control_row_height*(c) )

		execute (control_id_full+".pos = " + control_position as string )
	),
	
	/** Get groupbox size
	 */
	function _getSizeValues next_control controls_count =
	(
		format "\n"; print "GroupBoxCreator_v._getSizeValues()"
		--format "next_control	= % \n" next_control
		groupbox_size = [0,0]
		if( next_control != undefined ) then
			groupbox_size_height = next_control.height
			
		--format "groupbox_size_height	= % \n" groupbox_size_height
		groupbox_size.x	= if( next_control != undefined ) then next_control.pos.x	else 128
		groupbox_size.y	= if( next_control != undefined ) then this._getNextControlHeight next_control	else controls_count * 96
		
		groupbox_size --return
		--groupbox_size = [96,128]
	),
	
	/** _get groupbox height
	 */
	function _getNextControlHeight next_control =
	(
		format "\n"; print "GroupBoxCreator_v._getNextControlHeight()"
		
		control_type = this._getControlType( next_control)
		
		
		
		
		next_control.height
		 
		 
	),
	
	/** _set group box dimensions
	 */
	function _setGroupBoxSize groupbox_id_full groupbox_size =
	(
		this._setParameterInUi(groupbox_id_full)(#width) (groupbox_size.x - groupbox_size_fix)
		--this._setParameterInUi(groupbox_id_full)(#height)(groupbox_size.y + groupbox_size_fix)
	),
	
	/** _set parameter
	 */
	function _setParameterInUi control_id param val =
	(
		--print "GroupBoxCreator_v._setParameterInUi()"
		execute (control_id+"."+param as string +" = "+(val) as string)
	),

	/** _set parameter
	 */
	function _getParameter control_id param default =
	(
		if ((val =  try(execute (control_id+"."+param as string ) )  catch() ) == undefined ) then
			val = default
		--print "GroupBoxCreator_v._setParameterInUi()"
		val --return
	),
	/** Find next control after groupbox
	  * This control must not be in another groupbox
	  *
	 */
	function _getNextControlToGroupBox groupbox_controls rollout_id groupbox_id =
	(

		controls_in_rollout = execute(rollout_id+".controls" )
		--format "controls_in_rollout	= % \n" controls_in_rollout
		format "groupbox_controls	= % \n" groupbox_controls
		local current_control_index
		local next_control_index

		for i = 1 to controls_in_rollout.count where this._getControlId(controls_in_rollout[i]) == groupbox_id do current_control_index = i
		format "current_control_index	= % \n" current_control_index
		--for i = 1 to controls_in_rollout.count where i > current_control_index and (_next_control = controls_in_rollout[i+1]) != undefined and this._controlIsInGroupbox (_next_control) == false do
		--for i = 1 to controls_in_rollout.count where i >= current_control_index do
		for i = 1 to controls_in_rollout.count where i >= current_control_index /* start loop up current control */ and this._controlIsInGroupbox (controls_in_rollout[i+1]) == false  do
			if( next_control_index == undefined ) then -- get only first occurence
				next_control_index = i+1
		--for i = 1 to controls_in_rollout.count
		--where	(
		--			(_next_control	= controls_in_rollout[i+1]) != undefined	and
		--			(find_current_control	= this._getControlId(controls_in_rollout[i])) == groupbox_id	and
		--			(control_is_not_in_groupbox	= findItem groupbox_controls (this._getControlId(_next_control))) == 0
		--	) do
		--		next_control_index = i+1

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
		
		--format "next_control	= % \n" next_control
		--format "is_in_groupbox	= % \n" is_in_groupbox
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
		--format "control_type	= % \n" control_type
		control_type as name --return
		
	),
	
	/** _get control height
	 */
	function _getControlHeight =
	(
		--print "GroupBoxCreator_v._getControlHeight()"
		try
		(

		)
		catch()

	),

	/**  
	 */
	on create do
	(

	)

)

global GroupBoxCreator = GroupBoxCreator_v()