/** Auto close rollout callback
 */
function autoRollUpRolloutCallback parent_rollout slot_id current_rollout_id =
(
	if ENABLE_CALLBACK_AUTOROLL_ROLLOUT == true then
	(
		ENABLE_CALLBACK_AUTOROLL_ROLLOUT = false
		
		--format "\n"; print ".autoRollUpRolloutCallback()"
		--format "parent_rollout: %\n" parent_rollout
		--format "slot_id: %\n" slot_id
		--format "current_rollout_id: %\n" current_rollout_id
	
		parent_rollout	= parent_rollout as string
		current_rollout_id	= current_rollout_id as string
		slot_id	= slot_id as string
		
		/** Is current slot
		 */
		function isCurrentSlot slot slot_id = matchPattern ( slot as string ) pattern:("*:"+slot_id as string )
		
		/** Is not current rollout
		 */
		function isCurrentRollout _rollout current_rollout_id = matchPattern ( _rollout as string ) pattern:("*"+current_rollout_id as string )
		
		/** Is keep opened
		 */
		function isKeepOpened not_close_rollouts _rollout = findItem not_close_rollouts ((filterString ( _rollout as string ) ":")[2]) > 0 
		
		
		parent_rollout	= execute parent_rollout
		
		--format "PARENT_ROLLOUT.controls: %\n" parent_rollout.controls
		
		for slot in parent_rollout.controls where classOf slot == SubRollout and isCurrentSlot slot slot_id do
		(
			--format "\n"
			--format "slot.name: %\n" slot.name
			--format "slot.text: %\n" slot.text
			
			--if classOf ( slot_data = execute slot.text ) == Dictionary and slot_data[#AUTOROLLUP] == true then
			if classOf ( slot_data = execute slot.text ) == Dictionary then
			(
				autoroll_enabled	= slot_data[#AUTOROLLUP] == true 
				ctrl_pressed	= keyboard.controlPressed
				
				if ( autoroll_enabled and not ctrl_pressed ) or ( not autoroll_enabled and ctrl_pressed ) then
				(
					--format "SLOT_DATA: %\n" slot_data
					--format "slot_data[#AUTOROLLUP]: %\n" slot_data[#AUTOROLLUP]
					
					open_rollouts_count = if classOf slot_data[#AUTOROLLUP] == integer then slot_data[#AUTOROLLUP] else 1
					--format "open_rollouts_count: %\n" open_rollouts_count
			
					not_close_rollouts = if slot_data[#KEEP_OPEN_ROLLOUTS] != undefined then slot_data[#KEEP_OPEN_ROLLOUTS] else #()
					--format "not_close_rollouts: %\n" not_close_rollouts
					
					/*==============================================================================
					
					   COMMENTED CODE IS FOR SUPPORT MUTLIPLE OPENED ROLLOUTS AT ONCE
						
					   IT SEEM TO BE RUNDAND
						
					================================================================================*/
					
			----		/* ADD CURRENT ROLLOUT */ 
			----		insertItem current_rollout_id not_close_rollouts 1
			----		
			----		/* KEEP MAX OPENED ROLLOUTS COUNT */ 
			----		not_close_rollouts = makeUniqueArray (for i = 1 to not_close_rollouts.count where i <= open_rollouts_count collect not_close_rollouts[i])
			----		
					for _rollout in slot.rollouts do
						_rollout.open = isCurrentRollout _rollout current_rollout_id
			------
			------		
			------		slot_data[#KEEP_OPEN_ROLLOUTS] = not_close_rollouts
			
					/* UPDATE SLOT DATA */ 	
					slot.text = slot_data as string
					
					
				)
			)
			
			ENABLE_CALLBACK_AUTOROLL_ROLLOUT = true
		)
	)
)
