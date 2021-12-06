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
	controls_all,
	
	/** Test
	 */
	function test rollout_id =
	(
		print "GroupBoxCreator_v.test()"
		format "rollout_id	= % \n" rollout_id
	
		for i = 1 to  GroupBoxes.keys.count where ( groupbox_name = GroupBoxes.keys[i] ) != "" do
		(
			if( (controls_count =  GroupBoxes.values[i].count) == 0  ) then
				exit
			
			format "\n"
			format "groupbox_name	= % \n" groupbox_name
			groupbox_id_full = rollout_id+"."+groupbox_name

			groupbox_position = execute (rollout_id+"."+groupbox_name  as string +".pos")

			next_control = this._getNextControl (rollout_id)(groupbox_name)

			groupbox_width	= next_control.pos.x - 21
			groupbox_height	= next_control.height + 21
			
			 execute (groupbox_id_full+".width =  "+(groupbox_width ) as string)
			 execute (groupbox_id_full+".height = "+(groupbox_height) as string)

			 format "groupbox_height	= % \n" groupbox_height
			 format "GroupBoxes.count	= % \n" GroupBoxes.values[i].count
			 
			 control_row =groupbox_height / (controls_count+1)
			 
			 control_position = [groupbox_position.x, groupbox_position.y ]
			 --control_width = groupbox_height / controls_all.count
			 format "control_row	= % \n" control_row
			 
			for c = 1 to GroupBoxes.values[i].count where  ( control_id = GroupBoxes.values[i][c] ) != ""  do
			(
				control_id_full = rollout_id+"."+control_id
				
				try(get_height  = execute (control_id_full +".height"))  catch()
				try(get_caption = execute (control_id_full +".caption")) catch()

				control_type	= (filterString control_id "_")[1] as name
	
				control_position.y += control_row

				execute (rollout_id+"."+control_id+".pos = " + control_position as string )
			)
		)
		format "GroupBoxes	= % \n" GroupBoxes
	),

	private

	/** _get_next_control
	 */
	function _getNextControl rollout_id control_id =
	(
		print "GroupBoxCreator_v._getNextControl()"
		format "control_id	= % \n" control_id
				--control_id_full = rollout_id+"."+control_id

			controls_all = execute(rollout_id+".controls" )
			format "controls_all	= % \n" controls_all
			local next_control_index
			local next_control_id

			for i = 1 to controls_all.count where (next_control_id = (filterString ( controls_all[i] as string) ":")[2]) == control_id do next_control_index =  i+1

				format "next_control_id	= % \n" next_control_id
				format "next_control_index	= % \n" next_control_index
				format "next_control	= % \n" (controls_all[next_control_index])
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