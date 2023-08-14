/** Subollouts creator
 */
struct SubolloutsCreator_v
(
	--__construct = #( #property_name ),
	/* construct */
	/* properties */
	--_Rollout,

	ini_path,

	/* dependency */
	/* reference */
	/* inhered */


	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--format "\n"; print "SubolloutsCreator_v.addSubRollouts()"
		--print "============================================================="
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

		/* GET ALL Rollouts from Subrollouts_v.Rollouts */
		for Subrollouts in _Rollout.getSubrollouts() do
		(
			SubrolloutsSlot = getSubrolloutsSlot(SubrolloutsSlots)(Subrollouts.slot)

			subrollouts_in_slot	= for Subrollout in Subrollouts.Rollouts collect Subrollout.id

			rollouts_order	= this._getOrderOfsubrollouts(_Rollout)(Subrollouts)

			for subrollout_id in rollouts_order where ( index = findItem subrollouts_in_slot subrollout_id ) > 0 do
			(
				_Subrollout = Subrollouts.Rollouts[index]

				try(destroyDialog _Subrollout.RCI.def )catch() -- destroy dialog of subrollout created for find of height

				AddSubRollout SubrolloutsSlot	_Subrollout.RCI.def rolledUp:(this._getRolledUpState(subrollout_id))

				this.addSubRollouts (_Subrollout)
			)
		)
	),

	 /** _create subrollouts
	  */
	 function addSubrolloutSlot _Rollout Subrollouts =
	 (
		--format "\n\n\n\n=====================================	SubolloutsCreator_v.addSubrolloutSlot() %.%	=====================================\n" ( _Rollout.id as string ) ( Subrollouts.slot as string );

		--format "Subrollouts.height:	% \n" Subrollouts.height

		slot_id = Subrollouts.slot as string

		_Rollout.RCI.addText ("subRollout "+slot_id +" \""+slot_id+"\" height:"+Subrollouts.height as string )
	 ),


	private


	/** Get rolled state from ini
	 */
	function _getRolledUpState subrollout_id =
	(
		--print "SubolloutsCreator_v._getRolledStateFromIni()"

		rolledup_state = false

		if( ini_path != undefined and (rolledup_state_ini = getINISetting (ini_path) subrollout_id "rolledUp") != "" ) then
			rolledup_state = execute rolledup_state_ini

		rolledup_state --return
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