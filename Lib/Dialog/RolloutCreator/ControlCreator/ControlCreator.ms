
/** ControlCreator_v
 */
struct ControlCreator_v
(

	
	/** Add controls
	 */
	function addControls _Rollout _Controls =
	(
		print "ControlCreator_v.addControls()"
		this.addControlsGroup (_Rollout) (_Controls) #start 
		
		for _Control in _Controls.list do
			this.addControl _Rollout _Control
		
		this.addControlsGroup (_Rollout) (_Controls) #end 
	),
	
	/** Add controls group
	 */
	function addControlsGroup _Rollout _Controls mode =
	(
		print "ControlCreator_v.addControlsGroup()"
		if( _Controls.group == undefined ) do
			return false

		start_or_end	= if( mode == #start ) then "group @"+_Controls.group+"@ (" else ")" 

		_Rollout._RolloutCreator.addText start_or_end filter:on
	),

	/** Add control
	 */
	function addControl _Rollout _Control =
	(
		--print "ControlCreator_v.addControl()"
		this.addControlHandlers _Rollout _Control

		_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption)
	),
	
	/** Test
	 */
	function addControlHandlers _Rollout _Control =
	(
		--print "ControlCreator_v.addControlHandlers()"
		for _Event in _Control.Events.list do
			_Rollout._RolloutCreator.addHandler _Control.id _Event.type codeStr:_Event.code paramStr:_Event.params filter:on 
	),
	 
	/** Add subrollouts slot
	 */
	function addSubrolloutsSlots _Rollout Subrollouts =
	(
		--print ("ControlCreator_v.addSubrolloutsSlot()" + Subrollouts.slot)
		
		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:128")
		
		for _Subrollout in Subrollouts.Rollouts do
			this.createRollout (_Subrollout)

	),

	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--print "ControlCreator_v.addSubRollouts()"
		for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) do
			for _Subrollout in _Subrollouts.Rollouts do
			(
				execute  ( "AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot + " "+ _Subrollout.id )
				
				this.addSubRollouts _Subrollout
			)	
	),


	private
	
	
	/**  
	 */
	on create do
	(
	)	
)