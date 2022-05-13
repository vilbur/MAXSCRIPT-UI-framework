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
	slot_height = 164,
	
	/** Get height of subrollouts slot
	 */
	function getSubrolloutsHeight rollout_height slots_count =
	(
		format "\n"; print "SubolloutsCreator_v.getSubrolloutsHeight()"
		format "rollout_height	= % \n" rollout_height
		format "slots_count	= % \n" slots_count
		
		slot_height = 64 -- default minimal height of slot
		padding_bottom = 16

		nested_level = if( _Rollout.parent_rollout == undefined ) then 0 else (filterString _Rollout.parent_rollout ".").count/2 -- split parent_rollout_id and slot id E.G.: ROLLOUT_Parent.children
		format "nested_level	= % \n" nested_level
		
		if( slots_count > 0 ) then 
			if( rollout_height != undefined and rollout_height != unsupplied ) then
				slot_height = (rollout_height - padding_bottom) / slots_count
				--slot_height = ((rollout_height - padding_bottom) / slots_count) - 512
				
		slot_height -= 34*nested_level

		slot_height --return
	),
	
	 /** _create subrollouts
	  */
	 --function addSubrolloutsSlot _Rollout Subrollouts =
	 function addSubrolloutsSlot Subrollouts =
	 (
		print ( "RolloutCreator_v._createSubrollouts " + Subrollouts.slot as string  )
		format "_Rollout	= % \n" _Rollout.id
		format "Subrollouts.slot	= % \n" Subrollouts.slot
		format "Subrollouts	= % \n" Subrollouts.rollouts
		
		--ini_file = IniFile.getPath()
		
		--if( ini_file != undefined ) then 
		--(
		--	rollouts_order = getINISetting ini_file (_Rollout.id as string ) (Subrollouts.slot as string )
		--	
		--	format "rollouts_order	= % \n" rollouts_order
		--)
		
		format "SLOT_HEIGHT	= % \n" slot_height

		/**  DISABLE ADDING SUBROLLOUTS SLOT INTO ACROSS LAYOUT
		  */
		--ControlsCreator.AcrossModifier.fakeControlsOnEndofGroup(_Rollout._RolloutCreator) --fake_control_caption:"SUBROLLOUTS"

		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:"+slot_height as string )

	 ),
	
	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--print "RolloutCreator_v._addSubRollouts()"
		for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) do
			for _Subrollout in _Subrollouts.Rollouts do
			(
				--execute  ( "AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot +" "+ _Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(_Subrollout.id)) )
				execute  ( "AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot +" "+ _Subrollout.id + " rolledUp:false" )

				this.addSubRollouts (_Subrollout)
			)	
	),
	
	private
	
	
	--/** _get subrollouts count
	-- */
	--function _getSubrolloutsCount _Rollout =
	--(
	--	--print "RolloutCreator_v._getSubrolloutsCount()"
	--	(for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) collect _Subrollouts).count --return
	--),
	
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

		--for _Subrollout in Subrollouts.Rollouts do
		--	this.createRollout (_Subrollout)
		
	),
	
	/**  
	 */
	on create do
	(
		print("SubolloutsCreator_v.onCreate()")
		--ConstructPropeties test:this
		--this._createSubrollouts()
	)
	
)
