/** Subollouts creator
 */
struct SubolloutsCreator_v
(
	--__construct = #( #property_name ),
	/* construct */
	/* properties */
	_Rollout,

	ini_path,

	/* dependency */
	/* reference */
	/* inhered */


	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--format "\n"; print "SubolloutsCreator_v.addSubRollouts()"

		this._Rollout = _Rollout

		/** Get subrollouts slot
		 *
		 */
		function getSubrolloutsSlot slot =
		(
			for Subrollouts in  this._Rollout.RCI.Def.controls where classOf Subrollouts == SubRollout and matchPattern (Subrollouts as string ) pattern:( "SubRollout:"+slot as string ) do
				return Subrollouts
		)

		for Subrollouts in _Rollout.getSubrollouts() do
		(
			subrollout_ids	= for Subrollout in Subrollouts.Rollouts collect Subrollout.id

			rollouts_order	= this._getOrderOfsubrollouts(Subrollouts)

			Subrollouts_slot = getSubrolloutsSlot(Subrollouts.slot)

			for subrollout_id in rollouts_order where ( index = findItem subrollout_ids subrollout_id ) > 0 do
			(
				_Subrollout = Subrollouts.Rollouts[index]

				if _Subrollout.temporary_created then
					try(destroyDialog _Subrollout.RCI.def )catch()

				AddSubRollout Subrollouts_slot	_Subrollout.RCI.def

				this.addSubRollouts (_Subrollout)
			)
		)
	),

	 /** _create subrollouts
	  */
	 function addSubrolloutSlot _Rollout Subrollouts =
	 (
		--format "\n\n\n\n=====================================	SubolloutsCreator_v.addSubrolloutSlot() %.%	=====================================\n" ( _Rollout.id as string ) ( Subrollouts.slot as string );

		this._Rollout = _Rollout

		slot_id = Subrollouts.slot as string

		_Rollout.RCI.addText ("subRollout "+slot_id +" \""+slot_id+"\" height:"+Subrollouts.height as string )
	 ),


	private


	/** Get rolled state from ini
	 */
	function _getRolledStateFromIni subrollout_id =
	(
		--print "SubolloutsCreator_v._getRolledStateFromIni()"

		rolledup_state = "false"

		if( ini_path != undefined and (rolledup_state_ini = getINISetting (ini_path) subrollout_id "rolledUp") != "" ) then
			rolledup_state = rolledup_state_ini

		rolledup_state --return
	),

	/** Get order ofsubrollouts
	 */
	function _getOrderOfsubrollouts Subrollouts =
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