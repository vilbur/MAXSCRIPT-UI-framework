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
	
	/** Get height of subrollouts slot
	 */
	function getSubrolloutsHeight rollout_height =
	(
		--format "\n"; print "SubolloutsCreator_v.getSubrolloutsHeight()"
		slot_height = 64 -- default minimal height of slot
		padding_bottom = 16

		--print "RolloutCreator_v._setSubrolloutsHeight()"
		--print "DEDUG HEIGHT OF SUBROLLOUTS"
		--format "_Rollout.parent_rollout	= % \n" _Rollout.parent_rollout
		nested_level = if( _Rollout.parent_rollout == undefined ) then 0 else (filterString _Rollout.parent_rollout ".").count/2 -- split parent_rollout_id and slot id E.G.: ROLLOUT_Parent.children
		
		
		if( ( subrollouts_count = this._getSubrolloutsCount(_Rollout)) > 0 ) then 
			if( rollout_height != undefined and rollout_height != unsupplied ) then
				slot_height = (rollout_height - padding_bottom) / subrollouts_count
				--slot_height = ((rollout_height - padding_bottom) / subrollouts_count) - 512
				
		slot_height -= 34*nested_level
		
		slot_height --return
	),
	

	private
	
	
	/** _get subrollouts count
	 */
	function _getSubrolloutsCount _Rollout =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		(for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) collect _Subrollouts).count --return
	),
	
	/** _is subrollouts
	 */
	function _isSubrollouts _Struct =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		this._getType _Struct == "subrollouts"
	),
	
	/** Get name given struct
	  * @property	struct	_Struct
	  *
	  * @return	string lower case	name of given struc stripped of "_v" suffix E.G.: "FooStruct_v" returm "foostruct"
	 */
	function _getType _Struct =
	(
		toLower (( filterString( classof _Struct as string ) "_*(:" )[2])  --return
	),
	
	/** _create subrollouts
	 */
	function _createSubrollouts =
	(
		format "\n"; print "SubolloutsCreator_v._createSubrollouts()"
		
		--print ( "RolloutCreator_v._createSubrollouts " + Subrollouts.slot as string  )
		--format "_Rollout	= % \n" _Rollout.id
		--format "Subrollouts.slot	= % \n" Subrollouts.slot
		--format "Subrollouts	= % \n" Subrollouts.rollouts
		
		--ini_file = IniFile.getPath()
		--
		--if( ini_file != undefined ) then 
		--(
		--	rollouts_order = getINISetting ini_file (_Rollout.id as string ) (Subrollouts.slot as string )
		--	
		--	format "rollouts_order	= % \n" rollouts_order
		--)
		
		this._addSubrolloutsSlots (_Rollout) (Subrollouts)

		for _Subrollout in Subrollouts.Rollouts do
			this.createRollout (_Subrollout)
		
	),
	
	/**  
	 */
	on create do
	(
		--print("SubolloutsCreator_v.onCreate()")
		--ConstructPropeties test:this
		--this._createSubrollouts()
	)
	
)
