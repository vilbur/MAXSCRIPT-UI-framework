/** AcrossParameterModifier_v
 */
struct AcrossParameterModifier_v
(
	
	/** _set controls parameters
	 */
	function _acrossParameterModify &_Controls =
	(
		print "ControlCreator_v._acrossParameterModify()"
		last_across   = undefined 
		control_count = 0
		next_start_new_row = true
		
		_Controls_list_copy = deepCopy  _Controls.list
		
		
		for i = 1 to _Controls.list.count do
		(
			_Control = _Controls.list[i]
			control_count += 1
			format "\n"
			format "%	= % \n" _Control.id _Control.Params
			format "control_count	= % \n" control_count
		

			across =  _Control.Params.getVal #across
			format "across      = % \n" across
			format "last_across = % \n" last_across 

			if( across != last_across ) then 
				last_across = across
			else
				_Control.Params.delete #across
			
			
			row_position = control_count / last_across as float
			--format "row_position	= % \n" row_position
			last_in_row = (floor row_position == row_position ) -- test if first control in row
			--format "last_in_row	= % \n" last_in_row
			
			if( next_start_new_row ) then
				_Control.Params.setVal #across last_across
			
			
	
			_Control_NEXT = _Controls.list[i+1]
			
			if( _Control_NEXT != undefined ) then
			(
				across_next = _Control_NEXT.Params.getVal #across
				
				if( across_next != across ) then 
				(
					fake_controls_count = ((ceil row_position - row_position) * last_across) as integer
					format "fake_controls_count	= % \n" fake_controls_count
					
					print "ADD FAKE CONTROLS"
					format "_Control_NEXT	= % \n" _Control_NEXT
					
					if( fake_controls_count > 0 ) then
					(
						
						for x = 1 to fake_controls_count do
						(
							Control_fake = _Controls.control #label "FAKE" id:("label"+x as string) add_to_controls:false
							format "(i+x)	= % \n" (i+x)
							insertItem Control_fake _Controls_list_copy (i+x)
							--insertItem Control_fake _Controls.list (i+x)

						)
							
						
					)

				)
				
				
			)
			

			
			next_start_new_row = if ( last_in_row ) then true else false
			--format "next_start_new_row	= % \n" next_start_new_row
			

		)
		format "_Controls.list.count	= % \n" _Controls.list.count
		format "_Controls_list_copy.count	= % \n" _Controls_list_copy.count

		
		_Controls.list = _Controls_list_copy
		
		_Controls --return 
	),
	
	
	/**  
	 */
	on create do
	(
	)	
)