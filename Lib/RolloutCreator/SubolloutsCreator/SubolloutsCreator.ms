/** Subollouts creator
 */
struct SubolloutsCreator_v
(
	--__construct = #( #property_name ),
	/* construct */
	/* properties */

	ini_path,

	slot_height_fix = 8, -- slot is slightly shorter without this compesation

	slot_width_fix = 2, -- make slot wide as possible, remove this value from width of parent rollout
	--slot_width_fix = 0, -- make slot wide as possible, remove this value from width of parent rollout

	slot_offset_x = -12,

	DEBUG = false,

	/* dependency */
	/* reference */
	/* inhered */

	 /** CREATE SUBROLLOUTS SLOT IN UI
	  */
	 function addSubrolloutSlot _Rollout Subrollouts =
	 (

		if DEBUG then format "\n\n===================================== SubolloutsCreator_v.addSubrolloutSlot() %.% =====================================\n\n" ( _Rollout.id as string ) ( Subrollouts.slot as string );

		--slot_height = (Subrollouts.height + this.slot_height_fix ) as string
		slot_height = 512 as string
		slot_height = 256 as string

		slot_id = Subrollouts.slot as string

		--_Rollout.RCI.addText ("subRollout "+slot_id +" \""+slot_id+"\"  )
		_Rollout.RCI.addText ("subRollout "+slot_id +" \""+slot_id+"\" height:"+ slot_height + " width:" + (Subrollouts.width - slot_width_fix) as string + " offset:["+slot_offset_x as string +", 0]" )

	 ),

	/** ADD SUBROLLOUTS TO ROLLOUT
	 */
	function addSubRollouts _Rollout =
	(
		--format "\n"; print "SubolloutsCreator_v.addSubRollouts()"
		--print "============================================================="
		timer_addSubRollouts = timeStamp()
		--format "_ROLLOUT:	% \n" _Rollout.id

		/** Get subrollouts slot
		 *
		 */
		function getSubrolloutsSlot SubrolloutsSlots slot =
		(
			--format "\n"; print "SubolloutsCreator_v.getSubrolloutsSlot()"

			local SubrolloutsSlot

			for Subrollouts in SubrolloutsSlots where matchPattern (Subrollouts as string ) pattern:( "SubRollout:"+slot as string ) do
				SubrolloutsSlot = Subrollouts

			SubrolloutsSlot --return
		)

		SubrolloutsSlots = for Subrollouts in _Rollout.RCI.Def.controls where classOf Subrollouts == SubRollout collect Subrollouts
		
		/* FOR EACH SUBROLLOUTS SLOT
		
		*/
		all_subrollouts = _Rollout.getSubrollouts()
		
		for Subrollouts in all_subrollouts do
		--for Subrollouts in _Rollout.getSubrollouts() do
		(
			SubrolloutsSlot = getSubrolloutsSlot(SubrolloutsSlots)(Subrollouts.slot)
		
			subrollouts_in_slot	= for Subrollout in Subrollouts.Rollouts collect Subrollout.id
		
			rollouts_order	= this._getOrderOfsubrollouts(_Rollout)(Subrollouts)
			
			/* ADD EACH SUB ROLLOUT
			*/ 
			for subrollout_id in rollouts_order where ( index = findItem subrollouts_in_slot subrollout_id ) > 0 do
			(
				_Subrollout = Subrollouts.Rollouts[index]
		
				try(destroyDialog _Subrollout.RCI.def )catch() -- destroy dialog of subrollout created for find of height
		
		--		/*  DEBUG:
		--				FOR FLOATEBLE SUBROLLOUTS disable AddSubRollout
		--		*/
				AddSubRollout SubrolloutsSlot	_Subrollout.RCI.def rolledUp:(this._getRolledUpState(_Subrollout)(subrollout_id))
		
				this.addSubRollouts (_Subrollout)
			)
		)
	),


	private


	/** Get rolled state from ini
	 */
	function _getRolledUpState _Subrollout subrollout_id =
	(
		--print "SubolloutsCreator_v._getRolledStateFromIni()"

		if ( rolledup_state = _Subrollout.rolledUp ) == undefined \
		and( ini_path != undefined and (rolledup_state_ini = getINISetting (ini_path) subrollout_id "rolledUp") != "" ) then
			rolledup_state = execute rolledup_state_ini


		if rolledup_state != undefined then
			rolledup_state --return
		else
			false --return
	),

	/** Get order ofsubrollouts
	 */
	function _getOrderOfsubrollouts _Rollout Subrollouts =
	(
		--format "\n"; print "SubolloutsCreator_v._getOrderOfsubrollouts()"
		result_order = #()

		all_rollouts = for Subrollout in Subrollouts.rollouts collect Subrollout.id -- return

		--format "all_rollouts	= % \n" all_rollouts
		if ini_path != undefined and (rollouts_order_ini = getINISetting ini_path (_Rollout.id as string ) (Subrollouts.slot as string )) != "" then
		(
			for rollout_id in (execute(rollouts_order_ini)) + all_rollouts do appendIfUnique result_order rollout_id

			result_order --return
		) else
			all_rollouts --return
	),


	/**
	 */
	on create do
	(
		--print("SubolloutsCreator_v.onCreate()")
	)
)