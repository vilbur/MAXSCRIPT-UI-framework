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
	
	slot_height = 64, -- default minimal height of slot
	padding_bottom = 16,

	/** Get height of subrollouts slot
	 */
	function setSubrolloutsHeight rollout_height =
	(
		--format "\n"; print "SubolloutsCreator_v.setSubrolloutsHeight()"
		
		slots_count = (this._getSubrollouts(_Rollout)).count 

		nested_level = if( _Rollout.parent_rollout == undefined ) then 0 else (filterString _Rollout.parent_rollout ".").count/2 -- split parent_rollout_id and slot id E.G.: ROLLOUT_Parent.children
		
		if( slots_count > 0 ) then 
			if( rollout_height != undefined and rollout_height != unsupplied ) then
				slot_height = (rollout_height - padding_bottom) / slots_count
				
		slot_height -= 34*nested_level
	),
	
	 /** _create subrollouts
	  */
	 --function addSubrolloutsSlot _Rollout Subrollouts =
	 function addSubrolloutSlots Subrollouts =
	 (
		--print ( "SubolloutsCreator_v._createSubrollouts " + Subrollouts.slot as string  )
		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:"+slot_height as string )
	 ),
	
	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		print "SubolloutsCreator_v._addSubRollouts()"
		this._Rollout = _Rollout
		
		for Subrollouts in this._getSubrollouts(_Rollout) do
		(
			subrollout_ids	= for Subrollout in Subrollouts.Rollouts collect Subrollout.id			

			rollouts_order	= this._getOrderOfsubrollouts(Subrollouts)
			--format "rollouts_order	= % \n" rollouts_order
			
			for subrollout_id in rollouts_order do
			(
				Subrollout = Subrollouts.Rollouts[findItem subrollout_ids subrollout_id]
				--format "Subrollout	= % \n" Subrollout
				execute  ( "AddSubRollout "+_Rollout.id+"." + Subrollouts.slot +" "+ Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(Subrollout.id)) )

				this.addSubRollouts (Subrollout)
			)	
		)
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
	
	/** _get subrollouts count
	 */
	function _getSubrollouts _Rollout =
	(
		--print "SubolloutsCreator_v._getSubrolloutsCount()"
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
