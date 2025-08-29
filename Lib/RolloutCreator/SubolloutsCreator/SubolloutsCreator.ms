/** Create slots and add subrollouts 
  *
  *	IMPORRTANT:
  *		WIDTHS OF SUBROLLOUTS AND SLOTS ARE MAXIMIZED AS IS POSSIBLE:  "./_readme/maximized_rollout_width.jpg"

  * @method addSubrolloutSlot	Create subollouts slot
  * @method addSubRollouts	Create subollouts slot
  *
 */
struct SubolloutsCreator_v
(
	--__construct = #( #property_name ),
	/* construct */
	/* properties */
	ini_path,

	padding_bottom = 8, -- slot is slightly shorter without this compesation

	slot_width_decrement = 14, -- amount of pixel removed from with of parent rollout

	slot_offset_x = -12, -- move slot ( rollouts indeed ) to left side as possible

	DEBUG = false,

	/* dependency */
	/* reference */
	/* inhered */

	 /** CREATE SUBROLLOUTS SLOT IN UI
	  */
	 function addSubrolloutSlot _Rollout Subrollouts =
	 (
		if DEBUG then format "\n\n===================================== SubolloutsCreator_v.addSubrolloutSlot() %.% =====================================\n\n" ( _Rollout.id as string ) ( Subrollouts.slot as string );
		--format "\n\n===================================== SubolloutsCreator_v.addSubrolloutSlot() %.% =====================================\n\n" ( _Rollout.id as string ) ( Subrollouts.slot as string );
		--format "_Rollout.nested_level: %\n" _Rollout.nested_level

		slot_height = (Subrollouts.height + this.padding_bottom ) as string
		--slot_height = 512 as string
		--slot_height = 256 as string

		slot_id = Subrollouts.slot as string
		--format "SLOT: %\nHEIGHT: %\n" slot_id SLOT_HEIGHT

		slot_offset = [slot_offset_x, 0]
		
		slot_width  = Subrollouts.width - (  _Rollout.nested_level * slot_width_decrement ) - 2
		
		--_Rollout.RCI.addText ("subRollout "+slot_id +" \""+slot_id+"\"  )
		_Rollout.RCI.addText ("subRollout "+slot_id +" \""+(this._getSlotData(Subrollouts))+"\" height:"+ slot_height + " offset:" + slot_offset as string + " width:" + slot_width as string )
	 ),

	/** ADD SUBROLLOUTS TO ROLLOUT
	 */
	function addSubRollouts _Rollout =
	(
		--format "\n"; print "SubolloutsCreator_v.addSubRollouts()"
		--print "============================================================="

		/** Get subrollouts slot
		 *
		 */
		function getSubrolloutsSlot SubrolloutsSlots slot =
		(
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
		
				/*  DEBUG:
						FOR FLOATEBLE SUBROLLOUTS disable AddSubRollout
				*/
				AddSubRollout SubrolloutsSlot	_Subrollout.RCI.def rolledUp:(this._getRolledUpState(_Subrollout)(subrollout_id))
		
				this.addSubRollouts (_Subrollout)
			)
		)
	),


	private

	/** Get slot data
	 */
	function _getSlotData Subrollouts =
	(
		--format "\n"; print "SubolloutsCreator_v._getSlotData()"
		
		if ( Subrollouts.auto_roll_up ) != undefined then
		(
			slot_data	=  Dictionary()
			
			 slot_data[#AUTOROLLUP] = Subrollouts.auto_roll_up
			 
			 
			slot_data as string --return
		)
		else
			Subrollouts.slot as string --return
	),

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