/** Group box creator
 */
struct GroupBoxCreator_v
(
	GroupBoxes,
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	padding_top = 16,
	padding_control_top = 16,
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
		--format "\n"; print "GroupBoxCreator_v._sortControlsInGroupBox()"
		format "\n"
		format "groupbox_id	= % \n" groupbox_id
		controls_count = groupbox_controls.count
		groupbox_id_full = rollout_id+"."+groupbox_id

		groupbox_position = execute (rollout_id+"."+groupbox_id  as string +".pos")

		
		next_control = this._getNextControl(groupbox_controls)(rollout_id)(groupbox_id)
		
		if( next_control != undefined ) then
		(
			groupbox_width	= next_control.pos.x 
			groupbox_height	= next_control.height
		)
		else
		(
			groupbox_width	= 128
			groupbox_height	= 64
		)

		this._setParameterInUi(groupbox_id_full)(#width) (groupbox_width  - 21)
		this._setParameterInUi(groupbox_id_full)(#height)(groupbox_height + 21)

		groupbox_axis	= [ groupbox_position.x+(groupbox_width/2), groupbox_position.y+(groupbox_height/2) ]
		control_position	= [ groupbox_position.x, groupbox_position.y ]

		for c = 1 to groupbox_controls.count where  ( control_id = groupbox_controls[c] ) != ""  do
		(
			control_type	= (filterString control_id "_")[1] as name

			control_id_full = rollout_id+"."+control_id

			control_width = this._getParameter(control_id_full)(#width)(96)

			control_height = this._getParameter(control_id_full)(#height)(21)

			if( control_type == #dropdownlsit ) then 
				control_height = 24
			
			control_row	= groupbox_height / (controls_count-1)

			if( c == 1 ) then
			(
				control_position.y = groupbox_position.y
				
				control_position.x = (groupbox_width - control_width) / 2
			)
			else
				control_position.y = groupbox_position.y + (control_row*(c-1) )

			execute (rollout_id+"."+control_id+".pos = " + control_position as string )
		)
	
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
	/** _get_next_control
	 */
	function _getNextControl groupbox_controls rollout_id control_id =
	(

		controls_in_rollout = execute(rollout_id+".controls" )
		--format "controls_in_rollout	= % \n" controls_in_rollout
		local next_control_index
		local next_control_id

		for i = 1 to controls_in_rollout.count where (next_control_id = (filterString ( controls_in_rollout[i] as string) ":")[2]) == control_id and (control_is_not_in_groupbox	= findItem groupbox_controls control_id) > 0 do next_control_index =  i+1

		
		if( next_control_index != undefined ) then
			controls_in_rollout[next_control_index] --return 
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