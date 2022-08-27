/** Subollouts creator
 */
struct SubolloutsCreator_v
(
	--__construct = #( #property_name ),
	_Rollout,
	
	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	ini_path,
	
	padding_bottom 	= 16,
	slot_height	= 64, -- default minimal height of slot

	/** Get height of subrollouts slot
	 */
	function setSubrolloutsSlotHeight rollout_height =
	(
		format "\n"; print "SubolloutsCreator_v.setSubrolloutsHeight()"
		--format "_Rollout.hasSubrollouts()	= % \n" (_Rollout.hasSubrollouts())
		if not _Rollout.hasSubrollouts()  then 
			return false
		
		if rollout_height == unsupplied or rollout_height == undefined  then 
			return slot_height
		
		all_Subrollouts	= this._getSubrollouts(_Rollout)
		heights_of_slots	= (this._getHeightsOfSubrollouts())
		defined_height_sum	= 0;for val in heights_of_slots do defined_height_sum += val;

		undefined_space_in_rollout = rollout_height - defined_height_sum
		format "rollout_height             = % \n" rollout_height
		--format "all_Subrollouts.count      = % \n" all_Subrollouts.count
		format "heights_of_slots           = % \n" heights_of_slots
		format "defined_height_sum         = % \n" defined_height_sum           
		--format "heights_of_slots.count     = % \n" heights_of_slots.count
		format "undefined_space_in_rollout = % \n" undefined_space_in_rollout
		slot_height = this._getSlotHeight(undefined_space_in_rollout)(all_Subrollouts.count - heights_of_slots.count)
		format "slot_height	= % \n" slot_height
		for Subrollout in all_Subrollouts where Subrollout.height == undefined or Subrollout.height == unsupplied do
			Subrollout.height = slot_height
	),
	
	 /** _create subrollouts
	  */
	 --function addSubrolloutsSlot _Rollout Subrollouts =
	 function addSubrolloutSlots Subrollouts =
	 (
		format "\n\n=====================================	SubolloutsCreator_v.addSubrolloutSlots() %.%	=====================================\n" ( _Rollout.id as string ) ( Subrollouts.slot as string );
		format "Subrollouts.height	= % \n" Subrollouts.height
		
		--if Subrollouts.height == unsupplied then 
			--Subrollouts.height = 256 --dev
		
		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:"+Subrollouts.height as string )
	 ),
	
	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--format "\n"; print "SubolloutsCreator_v._addSubRollouts()"
		this._Rollout = _Rollout

		for Subrollouts in this._getSubrollouts(_Rollout) do
		(
			subrollout_ids	= for Subrollout in Subrollouts.Rollouts collect Subrollout.id			

			rollouts_order	= this._getOrderOfsubrollouts(Subrollouts)
			
			for subrollout_id in rollouts_order where ( index = findItem subrollout_ids subrollout_id ) > 0 do
			(
				Subrollout = Subrollouts.Rollouts[index]
				
				execute  ( "AddSubRollout "+_Rollout.id+"." + Subrollouts.slot +" "+ Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(Subrollout.id)) )

				this.addSubRollouts (Subrollout)
			)	
		)
	),
	
	
	private
	

	/** Get nested level
	 */
	function _getNestedLevel = -- split parent_rollout_id and slot id E.G.: ROLLOUT_Parent.children 
	(
		--format "\n"; print "SubolloutsCreator_v._getNestedLevel()"
		if( _Rollout.parent_rollout_id == undefined ) then 0 else (filterString _Rollout.parent_rollout_id ".").count/2 --return
	),
	
	/** Get subrollout with height defined
	 */
	function _getHeightsOfSubrollouts =
	(
		--format "\n"; print "SubolloutsCreator_v.getSubrolloutWithHeightDefined()"
		for Subrollout in this._getSubrollouts(_Rollout) do
			format "Subrollout.%.height	= % \n" (Subrollout.slot as string) Subrollout.height
		
		
		for Subrollout in this._getSubrollouts(_Rollout) where Subrollout.height != undefined and Subrollout.height != unsupplied collect Subrollout.height --return
	),

	/** Get slot height
	 */
	function _getSlotHeight undefined_space_in_rollout subrollouts_count =
	(
		--format "\n"; print "SubolloutsCreator_v._getSlotHeight()"
		if( subrollouts_count > 0 ) then
			slot_height = (undefined_space_in_rollout - padding_bottom) / subrollouts_count

		slot_height -= 34*(this._getNestedLevel())

		slot_height --return
	),
	
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
	
	/** _get subrollouts count
	 */
	function _getSubrollouts _Rollout =
	(
		--print "SubolloutsCreator_v._getSubrollouts()"
		for Subrollouts in _Rollout._Controls where matchPattern (classOf Subrollouts  as string ) pattern:@"*subrollouts_v*" collect Subrollouts--return
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
