/** Auto close rollout callback
 */
function autoRollUpRolloutCallback parent_rollout slot_id rollout_id =
(
	--format "\n"; print ".autoRollUpRolloutCallback()"
	--format "parent_rollout: %\n" parent_rollout
	--format "slot_id: %\n" slot_id
	--format "rollout_id: %\n" rollout_id

	parent_rollout	= parent_rollout as string
	rollout_id	= rollout_id as string
	slot_id	= slot_id as string
	
	/** Is current slot
	 */
	function isCurrentSlot slot slot_id = matchPattern ( slot as string ) pattern:("*:"+slot_id )
	
	/** Is not current rollout
	 */
	function isCurrentRollout _rollout rollout_id = matchPattern ( _rollout ) pattern:("*"+rollout_id )
	
	/** Is keep opened
	 */
	function isKeepOpened not_close_rollouts _rollout = findItem not_close_rollouts ((filterString ( _rollout as string ) ":")[2]) > 0 
	
	
	parent_rollout	= execute parent_rollout

	for slot in parent_rollout.controls where classOf slot == SubRollout and isCurrentSlot slot slot_id do
	(
		if classOf ( slot_data = execute slot.text ) == Dictionary then
		(
			open_rollouts_count = if classOf slot_data[#AUTOROLLUP] == integer then slot_data[#AUTOROLLUP] else 1

			not_close_rollouts = if slot_data[#KEEP_OPEN_ROLLOUTS] != undefined then slot_data[#KEEP_OPEN_ROLLOUTS] else #()
			
			/* ADD CURRENT ROLLOUT */ 
			insertItem rollout_id not_close_rollouts 1
			
			/* KEEP MAX OPENED ROLLOUTS COUNT */ 
			not_close_rollouts = makeUniqueArray (for i = 1 to not_close_rollouts.count where i <= open_rollouts_count collect not_close_rollouts[i])
			
			for _rollout in slot.rollouts where _rollout.open and not isKeepOpened not_close_rollouts _rollout do
				_rollout.open = false

			
			slot_data[#KEEP_OPEN_ROLLOUTS] = not_close_rollouts

			/* UPDATE SLOT DATA */ 	
			slot.text = slot_data as string
		)

	)
)
