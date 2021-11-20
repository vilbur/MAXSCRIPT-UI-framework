
/** ControlCreator_v
 */
struct ControlCreator_v
(
	_Rollout,
	_Controls,
	
	/** Add controls
	 */
	function addControls _Rollout _Controls =
	(
		--print "ControlCreator_v.addControls()"
		this._Rollout  = _Rollout
		this._Controls = _Controls
		
		this.addControlsGroup #start 
		
		for _Control in _Controls.list do
			this.addControl (_Control)
		
		this.addControlsGroup #end 
	),
	
	/** Add controls group
	 */
	function addControlsGroup mode =
	(
		--print "ControlCreator_v.addControlsGroup()"
		if( _Controls.group == undefined ) do
			return false

		start_or_end	= if( mode == #start ) then "group @"+_Controls.group+"@ (" else ")" 

		_Rollout._RolloutCreator.addText start_or_end filter:on
	),

	/** Add control
	 */
	function addControl _Control =
	(
		--print ("ControlCreator_v.addControl()	" +_Control.id)
		this.addControlHandlers (_Control)

		_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption)
	),
	
	/** Test
	 */
	function addControlHandlers _Control =
	(
		--print "ControlCreator_v.addControlHandlers()"
		for _Event in _Control.Events.list do
			_Rollout._RolloutCreator.addHandler _Control.id _Event.type codeStr:_Event.code paramStr:_Event.params filter:on 
	),


	private
	
	
	/**  
	 */
	on create do
	(
	)	
)