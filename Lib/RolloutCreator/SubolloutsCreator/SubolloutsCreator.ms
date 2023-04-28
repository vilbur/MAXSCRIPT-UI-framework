/** Subollouts creator
 */
struct SubolloutsCreator_v
(
	--__construct = #( #property_name ),
	/* construct */
	/* properties */
	_Rollout,

	ini_path,

	padding_bottom	= 16,
	slot_height	= 64, -- default minimal height of slot


	/* dependency */
	/* reference */
	/* inhered */




	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		format "\n"; print "SubolloutsCreator_v.addSubRollouts()"
		print "!!!!!!!!!!!!!!!!!!!!"
		--format "_Rollout.id	= % \n" _Rollout.id
		this._Rollout = _Rollout

		for Subrollouts in _Rollout.getSubrollouts() do
		(
			--format "Subrollouts	= % \n" Subrollouts


			slot_height = execute( (Subrollouts.getSlotId()) + ".height" )

			--format "slot_height	= % \n" slot_height

			--execute( (Subrollouts.getSlotId()) + ".height = 512" )



			subrollout_ids	= for Subrollout in Subrollouts.Rollouts collect Subrollout.id

			rollouts_order	= this._getOrderOfsubrollouts(Subrollouts)


			for subrollout_id in rollouts_order where ( index = findItem subrollout_ids subrollout_id ) > 0 do
			(
				_Subrollout = Subrollouts.Rollouts[index]




				execute( "try( destroyDialog "+_Subrollout.id as string +" )catch()" )

				--format "_Rollout.id	= % \n" _Rollout.id
				--format "Subrollouts.slot	= % \n" Subrollouts.slot
				format "_Subrollout.id	= % \n" _Subrollout.id
				--format "Subrollouts.height	= % \n" Subrollouts.height
				--print  ( "AddSubRollout "+_Rollout.id+"." + Subrollouts.slot +" "+ _Subrollout.id + "	rolledUp:"+(this._getRolledStateFromIni(_Subrollout.id)) )


				execute  ( "AddSubRollout "+_Rollout.id+"." + Subrollouts.slot +" "+ _Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(_Subrollout.id)) )


				this.addSubRollouts (_Subrollout)


			)
		)
	),

	/** Add sub rollouts
	 */
	function XXXXaddSubRollouts _Rollout =
	(
		--format "\n"; print "SubolloutsCreator_v._addSubRollouts()"
		this._Rollout = _Rollout

		for Subrollouts in _Rollout.getSubrollouts() do
		(
			subrollout_ids	= for Subrollout in Subrollouts.Rollouts collect Subrollout.id

			rollouts_order	= this._getOrderOfsubrollouts(Subrollouts)

			for subrollout_id in rollouts_order where ( index = findItem subrollout_ids subrollout_id ) > 0 do
			(
				Subrollout = Subrollouts.Rollouts[index]
				--format "_Rollout.id	= % \n" _Rollout.id
				--format "Subrollouts.slot	= % \n" Subrollouts.slot
				--format "Subrollout.id	= % \n" Subrollout.id
				--format "Subrollouts.height	= % \n" Subrollouts.height
				--print  ( "AddSubRollout "+_Rollout.id+"." + Subrollouts.slot +" "+ Subrollout.id + "	rolledUp:"+(this._getRolledStateFromIni(Subrollout.id)) )

				execute  ( "AddSubRollout "+_Rollout.id+"." + Subrollouts.slot +" "+ Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(Subrollout.id)) )

				this.addSubRollouts (Subrollout)
			)
		)
	),

	 /** _create subrollouts
	  */
	 function addSubrolloutSlot _Rollout Subrollouts =
	 (
		format "\n\n\n\n=====================================	SubolloutsCreator_v.addSubrolloutSlot() %.%	=====================================\n" ( _Rollout.id as string ) ( Subrollouts.slot as string );

		this._Rollout = _Rollout

		--this.setSubrolloutsSlotHeight()

		_Rollout.RCI.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:"+Subrollouts.height as string )
	 ),

	/** Get height of subrollouts slot
	 */
	function setSubrolloutsSlotHeight =
	(
		format "\n"; print "SubolloutsCreator_v.setSubrolloutsHeight()"
		--format "_Rollout.hasSubrollouts()	= % \n" (_Rollout.hasSubrollouts())
		--rollout_height = _Rollout.height

		if not _Rollout.hasSubrollouts()  then
			return false

		if _Rollout.height == unsupplied or _Rollout.height == undefined  then
			return false

		all_Subrollouts	= this._Rollout.getSubrollouts()
		heights_of_slots	= this._getHeightsOfSubrollouts()
		defined_height_sum	= 0;for val in heights_of_slots do defined_height_sum += val

		undefined_space_in_rollout = _Rollout.height - defined_height_sum
		--format "_Rollout.height             = % \n" _Rollout.height
		--format "all_Subrollouts.count      = % \n" all_Subrollouts.count
		--format "heights_of_slots           = % \n" heights_of_slots
		--format "defined_height_sum         = % \n" defined_height_sum
		--format "heights_of_slots.count     = % \n" heights_of_slots.count
		--format "undefined_space_in_rollout = % \n" undefined_space_in_rollout
		slot_height = this._getSlotHeight(undefined_space_in_rollout)(all_Subrollouts.count - heights_of_slots.count)
		--format "slot_height	= % \n" slot_height
		for SubrolloutSlot in all_Subrollouts where SubrolloutSlot.height == undefined or SubrolloutSlot.height == unsupplied do
			SubrolloutSlot.height = slot_height

	),


	private


	/** Get subrollout with height defined
	 */
	function _getHeightsOfSubrollouts =
	(
		--format "\n"; print "SubolloutsCreator_v.getSubrolloutWithHeightDefined()"
		--for Subrollout in this._getSubrollouts(_Rollout) do --DEBUG
			--format "Subrollout.%.height	= % \n" (Subrollout.slot as string) Subrollout.height

		for Subrollout in this._Rollout.getSubrollouts() where Subrollout.height != undefined and Subrollout.height != unsupplied collect Subrollout.height --return
	),

	/** Get slot height
	 */
	function _getSlotHeight undefined_space_in_rollout subrollouts_count =
	(
		--format "\n"; print "SubolloutsCreator_v._getSlotHeight()"
		if( subrollouts_count > 0 ) then
			slot_height = (undefined_space_in_rollout - padding_bottom) / subrollouts_count

		slot_height -= 34*(_Rollout.getNestedLevel())

		slot_height --return
	),

	/** Get rolled state from ini
	 */
	function _getRolledStateFromIni subrollout_id =
	(
		--print "SubolloutsCreator_v._getRolledStateFromIni()"
		--format "subrollout_id	= % \n" subrollout_id
		--format "ini_path	= % \n" ini_path
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

	/** _merge arrays


	/**
	 */
	on create do
	(
		--print("SubolloutsCreator_v.onCreate()")
		--ConstructPropeties test:this
		--this._createSubrollouts()
	)

)
