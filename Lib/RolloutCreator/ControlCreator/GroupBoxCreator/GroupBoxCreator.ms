/** Group box creator
 */
struct GroupBoxCreator_v
(
	__construct = #(  ),
	GroupBoxes,
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	/** Test
	 */
	function test rollout_id =
	(
		print "GroupBoxCreator_v.test()"
		format "rollout_id	= % \n" rollout_id
		for i = 1 to  GroupBoxes.keys.count where ( groupbox_name = GroupBoxes.keys[i] ) != "" do
		(
	
			--format "groupbox_name	= % \n" groupbox_name
			groupbox_id_full = rollout_id+"."+groupbox_name

			groupbox_position = execute (rollout_id+"."+groupbox_name  as string +".pos")
			format "groupbox_position	= % \n" groupbox_position
			
			next_control = this._getNextControl (rollout_id)(groupbox_name)
				format "next_control	= % \n" next_control
			format "groupbox_id_full	= % \n" groupbox_id_full
			next_control_posx = next_control.pos.x
			 execute (groupbox_id_full+".width = "+(next_control_posx - 21) as string)
			--groupbox_position = execute (groupbox_id_full+"."+".width = "+next_control.pos.x as string  )

			for c = 1 to GroupBoxes.values[i].count where  ( control_id = GroupBoxes.values[i][c] ) != ""  do
			(
				control_id_full = rollout_id+"."+control_id
				try(get_height = execute (control_id_full +".height")) catch()
				try(get_caption = execute (control_id_full +".caption")) catch()
	
	
	
				control_type	= (filterString control_id "_")[1] as name
				control_height = if( get_height == undefined ) then
									case control_type of
									(
										#button: 24
										default:21	
									)
								else
									case control_type of
									(
										#dropdownlist: if( get_caption == "" ) then 24 else 44
										default:get_height	
									)
						
						
				
				groupbox_position.y += control_height
				--if( get_height != undefined )
				--	then
				--		--get_height
				--		21
				--	else
				--		--48
				--		21
				format "\n"
				format "control_id	= % \n" control_id
				format "control_type	= % \n" control_type
				format "control_height	= % \n" control_height
				format "get_caption	= % \n" get_caption	
				format "get_height	= % \n" get_height
				
				format "groupbox_position	= % \n" groupbox_position
				
				
				execute (rollout_id+"."+control_id+".pos = " + groupbox_position as string )
			)
			
			--for control_id in  GroupBoxes.values[i]  do

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
	
	
	/** Get\set value of property 
	 * @param	string|name key	Name  of property E.G.: "foo_key" OR #foo_key 
	 * @param	string|#get value	Value of property
	 *
	 * @return	string|self Value or self
	 *
	 * @example this._getSetProp "foo" "bar" -- SET "bar" to property "foo"
	 * @example this._getSetProp #foo  #get  -- GET value of property "foo"
	 */
	function _getSetProp key value =
	(
		if( value != #get ) then
		(
			if( value != undefined ) then
				setProperty  this ( key as string ) value
			this --return
		) else
			getProperty this ( key as string ) --return
	),
	
	/** Check if required properties are defined when an instance of the struct is created.
	 *	
	 * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("GroupBoxCreator\nUndefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	/**  
	 */
	on create do
	(
		--print("GroupBoxCreator_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)

global GroupBoxCreator = GroupBoxCreator_v()