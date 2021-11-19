filein( getFilenamePath(getSourceFileName()) + "/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollout/Subrollouts/Subrollouts.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	--Rollout_main,

	/** New
	 */
	function new title id: =
	(
		 Rollout_v title:title id:id --return
		
		--_RolloutCreator = rolloutCreator ( title as string ) title
		--append _Rollouts _Rollout
		--_RolloutCreator.begin()
		--Rollout_main --return
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
		_Rollout._RolloutCreator.begin()
		
		for ControlsBox_or_Subrollouts in _Rollout._Controls do
			this.addControlsOrSubrolloutes (_Rollout) (ControlsBox_or_Subrollouts)
		
		_Rollout._RolloutCreator.end()
	),

	/** Add controls or subrolloutes
	 */
	function addControlsOrSubrolloutes _Rollout ControlsBox_or_Subrollouts =
	(
		--print "RolloutCreator_v.addControlsOrSubrolloutes()"
		if( this._isControls(ControlsBox_or_Subrollouts) ) then
		
			this.addControls (_Rollout)(ControlsBox_or_Subrollouts)
		
		else
			this.addSubrolloutsSlots (_Rollout)(ControlsBox_or_Subrollouts)
	),
	
	/** Add controls
	 */
	function addControls _Rollout _Controls =
	(
		--print "RolloutCreator_v.addControls()"
		for _Control in _Controls.list do
		(
			this.addControlHandlers _Rollout _Control

			_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption)
		)
	),

	/** Test
	 */
	function addControlHandlers _Rollout _Control =
	(
		--print "RolloutCreator_v.addControlHandlers()"
		for _Event in _Control.Events.list do
			_Rollout._RolloutCreator.addHandler _Control.id _Event.type codeStr:_Event.code paramStr:_Event.params filter:on 
	),
	
	/** Add subrollouts slot
	 */
	function addSubrolloutsSlots _Rollout Subrollouts =
	(
		--print ("RolloutCreator_v.addSubrolloutsSlot()" + Subrollouts.slot)
		
		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:128")
		
		for _Subrollout in Subrollouts.Rollouts do
			this.createRollout (_Subrollout)

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
	
	
	

	--
	--/** Add controls box to ui
	-- */
	--function addControlsBoxToUi ControlsBox =
	--(
	--	--print "RolloutCreator_v.addControlsBoxToUi()"
	--	_RolloutCreator.addText ("group \"" + ControlsBox.caption + "\" (") 
	--				
	--	for i = 1 to ControlsBox.controls.count do
	--			this.addControlToUI (ControlsBox.controls[i])
	--	
	--	_RolloutCreator.addText (")")
	--),
	--
	--/** Add control to UI
	-- */
	--function addControlToUI _Control =
	--(
	--	print ("RolloutCreator_v.addControlToUI() " + _Control.id)
	--	
	--	/** Test
	--	 */
	--	(function addControlHandlers _Control =
	--	(
	--		print "RolloutCreator_v.addControlHandlers()"
	--		
	--		for _Event in _Control.Events.list do
	--			_RolloutCreator.addHandler _Control.id _Event.type codeStr:_Event.code paramStr:_Event.params filter:on 
	--	
	--	))(_Control)
	--
	--	_RolloutCreator.addControl _Control.type ( _Control.id as string ) _Control.caption paramStr:_Control.params
	--),
	--




	
	/**  
	 */
	on create do
	(
	)	
)