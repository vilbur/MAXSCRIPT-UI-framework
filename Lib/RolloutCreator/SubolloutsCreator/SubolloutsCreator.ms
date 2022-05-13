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
		format "\n"; print "SubolloutsCreator_v.getSubrolloutsHeight()"
		
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
		print ( "RolloutCreator_v._createSubrollouts " + Subrollouts.slot as string  )
		format "_Rollout	= % \n" _Rollout.id
		format "Subrollouts.slot	= % \n" Subrollouts.slot
		format "Subrollouts	= % \n" Subrollouts.rollouts
		
		--ini_path = IniFile.getPath()
		
		--if( ini_path != undefined ) then 
		--(
		--	rollouts_order = getINISetting ini_path (_Rollout.id as string ) (Subrollouts.slot as string )
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
		for _Subrollouts in this._getSubrollouts(_Rollout) do
			for _Subrollout in _Subrollouts.Rollouts do
			(
				execute  ( "AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot +" "+ _Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(_Subrollout.id)) )

				this.addSubRollouts (_Subrollout)
			)	
	),
	
	
	private
	
	
	/** Get rolled state from ini
	 */
	function _getRolledStateFromIni subrollout_id =
	(
		--print "RolloutCreator_v._getRolledStateFromIni()"
		rolledup_state = "false"

		if( ini_path != undefined and (rolledup_state_ini = getINISetting (ini_path) subrollout_id "rolledUp") != "" ) then
			rolledup_state = rolledup_state_ini

		rolledup_state --return
	),
	
	/** _get subrollouts count
	 */
	function _getSubrollouts _Rollout =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		for _Subrollouts in _Rollout._Controls where matchPattern (classOf _Subrollouts  as string ) pattern:@"*subrollouts_v*" collect _Subrollouts--return
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

	/**  
	 */
	on create do
	(
		print("SubolloutsCreator_v.onCreate()")
		--ConstructPropeties test:this
		--this._createSubrollouts()
	)
	
)
