filein( getFilenamePath(getSourceFileName()) + "/../../Events/Events.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollout/Subrollouts/Subrollouts.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlCreator/ControlCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/RolloutEvent/RolloutEvent.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	ControlCreator = ControlCreator_v(),
	RolloutEvents  = RolloutEvents_v(),

	/** New
	 */
	function new title id: =
	(
		Rollout_v title:title id:id --return
	),
	
	/** Get definition
	 */
	function getDefinition _Rollout =
	(
		_Rollout._RolloutCreator.def
	),

	/** Create dialog
	 */
	function createRollout _Rollout =
	(
		format "\n"
		print ("RolloutCreator_v.createRollout() " + _Rollout.id)
		--format "_Rollout	= % \n" _Rollout
		_Rollout._RolloutCreator.begin()
		
		
		this.addControlsAndSubrolloutes (_Rollout)
		
		RolloutEvents.bindEvents (_Rollout)
		
		_Rollout._RolloutCreator.end()
	),

	/** Add controls or subrolloutes
	 */
	function addControlsAndSubrolloutes _Rollout =
	(
		--print "RolloutCreator_v.addControlsAndSubrolloutes()"
		for ControlsBox_or_Subrollouts in _Rollout._Controls do
			if( this._isControls(ControlsBox_or_Subrollouts) ) then
			
				ControlCreator.addControls (_Rollout)(ControlsBox_or_Subrollouts)
			
			else
			
				this._createSubrollouts (_Rollout)(ControlsBox_or_Subrollouts)
	),
	 
	 /** _create subrollouts
	  */
	 function _createSubrollouts  _Rollout Subrollouts =
	 (
		--print "RolloutCreator_v._createSubrollouts()"
		this.addSubrolloutsSlots (_Rollout) (Subrollouts)
		
		for _Subrollout in Subrollouts.Rollouts do
			this.createRollout (_Subrollout)
	 ),
	 
	/** Add subrollouts slot
	 */
	function addSubrolloutsSlots _Rollout Subrollouts =
	(
		--print ("RolloutCreator_v.addSubrolloutsSlot()" + Subrollouts.slot)
		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:128")
	),

	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--print "RolloutCreator_v.addSubRollouts()"
		for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) do
			for _Subrollout in _Subrollouts.Rollouts do
			(
				execute  ( "AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot + " "+ _Subrollout.id )
				
				this.addSubRollouts _Subrollout
			)	
	),
	
	private
	

	/** _is control box
	 */
	function _isControls _Struct =
	(
		this._getType _Struct == "controls"
	),
	
	/** _is subrollouts
	 */
	function _isSubrollouts _Struct =
	(
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
	
	/**  
	 */
	on create do
	(
	)	
)