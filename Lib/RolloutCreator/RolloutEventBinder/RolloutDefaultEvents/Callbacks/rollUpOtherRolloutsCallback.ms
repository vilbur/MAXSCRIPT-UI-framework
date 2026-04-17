global ALLOW_BLOCK_AOTOLL_CALLBACK = true

/** Roll up other rollouts callback
 */
function rollUpOtherRolloutsCallback parent_rollout slot_id open_rollout_id =
(
	if ALLOW_BLOCK_AOTOLL_CALLBACK then
	(
		--format "\n"; print ".rollUpOtherRolloutsCallback()"
		--format "parent_rollout: %\n" parent_rollout
		--format "slot_id: %\n" slot_id
		--format "open_rollout_id: %\n" open_rollout_id
		
		ALLOW_BLOCK_AOTOLL_CALLBACK = false -- avoid fire up this callback

		parent_rollout	= parent_rollout as string
		open_rollout_id	= open_rollout_id as string
		slot_id	= slot_id as string
		
		/** Is current slot
		 */
		function isCurrentSlot slot slot_id = matchPattern ( slot as string ) pattern:("*:"+slot_id as string )
		
		/** Is not current rollout
		 */
		function isCurrentRollout _rollout open_rollout_id = matchPattern ( _rollout as string ) pattern:("*"+open_rollout_id )
		
		parent_rollout	= execute (parent_rollout as string )
	
		/* FIND SLOT */ 
		for slot in parent_rollout.controls where classOf slot == SubRollout and isCurrentSlot slot slot_id do
			/* CLOSE OTHER ROLLOUTS */ 
			for _subrollout in slot.rollouts do
				_subrollout.open = isCurrentRollout _subrollout open_rollout_id
		
		ALLOW_BLOCK_AOTOLL_CALLBACK = true
	)

)
