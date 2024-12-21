/** Auto close rollout callback
 */
function autoCloseRolloutCallback parent_rollout slot_id rollout_id =
(
	format "\n"; print ".autoCloseRolloutCallback()"
	--format "parent_rollout: %\n" parent_rollout
	--format "slot_id: %\n" slot_id
	format "rollout_id: %\n" rollout_id

	/** Is current slot
	 */
	function isCurrentSlot slot slot_id = matchPattern ( slot as string ) pattern:("*:"+slot_id as string )
	
	/** Is not current rollout
	 */
	function isCurrentRollout _rollout rollout_id = matchPattern ( _rollout as string ) pattern:("*"+rollout_id )
	
	/** Is keep opened
	 */
	function isKeepOpened not_close_rollouts _rollout = findItem not_close_rollouts ((filterString ( _rollout as string ) ":")[2]) > 0 
	
	
	parent_rollout	= execute (parent_rollout as string )

	for slot in parent_rollout.controls where classOf slot == SubRollout and isCurrentSlot slot slot_id do
	(
		
		if classOf ( slot_data = execute slot.text ) == Dictionary then
		(
			open_rollouts_count = if classOf slot_data[#AUTOCLOSE_ROLLOUTS] == integer then slot_data[#AUTOCLOSE_ROLLOUTS] else 1

			not_close_rollouts = if slot_data[#KEEP_OPEN_ROLLOUTS] != undefined then slot_data[#KEEP_OPEN_ROLLOUTS] else #()
			
			--current_rollout	= for _rollout in slot.rollouts where isCurrentRollout _rollout rollout_id collect _rollout

			for _rollout in slot.rollouts where _rollout.open and not isCurrentRollout _rollout rollout_id and not isKeepOpened not_close_rollouts _rollout do
				_rollout.open = false
			
			
			/* ADD CURRENT ROLLOUT */ 
			insertItem rollout_id not_close_rollouts 1
			
			/* KEEP MAX OPENED ROLLOUTS COUNT */ 
			not_close_rollouts = makeUniqueArray (for i = 1 to not_close_rollouts.count where i <= open_rollouts_count collect not_close_rollouts[i])

			
			slot_data[#KEEP_OPEN_ROLLOUTS] = not_close_rollouts

			/* UPDATE SLOT DATA */ 	
			slot.text = slot_data as string
		)

	)
)
