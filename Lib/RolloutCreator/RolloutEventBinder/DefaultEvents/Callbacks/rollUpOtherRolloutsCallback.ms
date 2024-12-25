/** Roll up other rollouts callback
 */
function rollUpOtherRolloutsCallback parent_rollout slot_id rollout_id =
(
	--format "\n"; print ".autoRollUpRolloutCallback()"

	/** Is current slot
	 */
	function isCurrentSlot slot slot_id = matchPattern ( slot as string ) pattern:("*:"+slot_id as string )
	
	/** Is not current rollout
	 */
	function isCurrentRollout _rollout rollout_id = matchPattern ( _rollout as string ) pattern:("*"+rollout_id )
	
	parent_rollout	= execute (parent_rollout as string )

	/* CLOSE OTHER ROLLOUTS */ 
	for slot in parent_rollout.controls where classOf slot == SubRollout and isCurrentSlot slot slot_id do
			for _rollout in slot.rollouts do
				_rollout.open = isCurrentRollout _rollout rollout_id

)
