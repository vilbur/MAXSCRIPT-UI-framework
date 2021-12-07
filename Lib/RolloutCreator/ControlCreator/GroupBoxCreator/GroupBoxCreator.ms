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
	controls_all,

	/** Test
	 */
	function sortControlsToGroupBoxes rollout_id =
	(
		--print "GroupBoxCreator_v.sortControlsToGroupBoxes()"
		--format "rollout_id	= % \n" rollout_id
		if( GroupBoxes != undefined ) then

			for i = 1 to  GroupBoxes.keys.count where ( groupbox_name = GroupBoxes.keys[i] ) != "" do
			(
				if( (controls_count =  GroupBoxes.values[i].count) == 0  ) then
					exit
				--format "\n"
				--format "groupbox_name	= % \n" groupbox_name
				groupbox_id_full = rollout_id+"."+groupbox_name
				--control_height = 20
				--control_width  = 20
	
				groupbox_position = execute (rollout_id+"."+groupbox_name  as string +".pos")
	
				next_control = this._getNextControl (rollout_id)(groupbox_name)
	
				groupbox_width	= next_control.pos.x 
				groupbox_height	= next_control.height
	
				this._setParameter(groupbox_id_full)(#width) (groupbox_width  - 21)
				this._setParameter(groupbox_id_full)(#height)(groupbox_height + 21)
	
				groupbox_axis	= [ groupbox_position.x+(groupbox_width/2), groupbox_position.y+(groupbox_height/2) ]
				control_position	= [ groupbox_position.x, groupbox_position.y ]
	
				for c = 1 to GroupBoxes.values[i].count where  ( control_id = GroupBoxes.values[i][c] ) != ""  do
				(
					control_type	= (filterString control_id "_")[1] as name

					control_id_full = rollout_id+"."+control_id
	
					control_width = this._getParameter(control_id_full)(#width)(96)

					control_height = this._getParameter(control_id_full)(#height)(21)

					--get_caption =  this._getParameter(control_id_full)(#caption)""
					--
					if( control_type == #dropdownlsit ) then 
						control_height = 24
					
				--if( (control_row = (groupbox_height / (controls_count)) - control_height) > 5  ) then  -- dos not work on marosript genrated controls
				--if( (control_row = (groupbox_height / (controls_count)) ) > 5  ) then  
					--control_row	= groupbox_height / (controls_count+1)
					--control_row	= groupbox_height / (controls_count)
					control_row	= groupbox_height / (controls_count-1)



					if( c == 1 ) then
					(
						control_position.y = groupbox_position.y
						
						control_position.x = (groupbox_width - control_width) / 2
						
					)
					--else if( c == controls_count ) then
					--(
					--	control_position.y = groupbox_position.y + groupbox_height - control_height
					--	
					--)
					else
						control_position.y = groupbox_position.y + (control_row*(c-1) )
						
					--control_position.y = groupbox_position.y + (control_row*c) - (control_height/2)

					execute (rollout_id+"."+control_id+".pos = " + control_position as string )
				)
			)
			--format "GroupBoxes	= % \n" GroupBoxes
	),

	private

	/** _set parameter
	 */
	function _setParameter control_id param val =
	(
		--print "GroupBoxCreator_v._setParameter()"
		execute (control_id+"."+param as string +" = "+(val) as string)
	),

	/** _set parameter
	 */
	function _getParameter control_id param default =
	(
		if ((val =  try(execute (control_id+"."+param as string ) )  catch() ) == undefined ) then
			val = default
		--print "GroupBoxCreator_v._setParameter()"
		val --return
	),
	/** _get_next_control
	 */
	function _getNextControl rollout_id control_id =
	(
		--print "GroupBoxCreator_v._getNextControl()"
		--format "control_id	= % \n" control_id
				--control_id_full = rollout_id+"."+control_id

			controls_all = execute(rollout_id+".controls" )
			--format "controls_all	= % \n" controls_all
			local next_control_index
			local next_control_id

			for i = 1 to controls_all.count where (next_control_id = (filterString ( controls_all[i] as string) ":")[2]) == control_id do next_control_index =  i+1

				--format "next_control_id	= % \n" next_control_id
				--format "next_control_index	= % \n" next_control_index
				--format "next_control	= % \n" (controls_all[next_control_index])
			--for _control_id_split in  where _control_id_split[2] ==  do 
				--format "_control_id_split	= % \n" (filterString ( _control_id_split as string) ":")

			next_control = controls_all[next_control_index]
			--rollout_id+"."+next_control_id  --return

			next_control --return
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