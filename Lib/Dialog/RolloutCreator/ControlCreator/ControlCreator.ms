filein( getFilenamePath(getSourceFileName()) + "/../../Rollout/Controls/ControlParams/ControlParams.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlEvents/ControlEvents.ms" )
/** ControlCreator_v
 */
struct ControlCreator_v
(
	
	_Rollout,
	_Controls,
	
	ControlParams	= ControlParams_v(),
	ControlEvents	= ControlEvents_v(),

	/** Add controls
	 */
	function addControls _Rollout _Controls =
	(
		--print "ControlCreator_v.addControls()"
		--format "_Controls.Defaults	= % \n" _Controls.Defaults
		this._Rollout  = _Rollout
		this._Controls = _Controls
		
		ControlParams.setDefaults (_Controls.Defaults)
		
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
		--format "\n"
		--print ("ControlCreator_v.addControl()	" +_Control.id)
		
		events_list = ControlEvents.getEvents(_Control)(_Rollout.id)
		
		this.addControlHandlers (_Control)(events_list)

		_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:(ControlParams.getParams(_Control)(_Rollout.id))
	),
	
	/** Test
	 */
	function addControlHandlers _Control events_list =
	(
		--print "ControlCreator_v.addControlHandlers()"
		for Event in events_list do
			--format "Event	= % \n" Event
			_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:Event.code paramStr:Event.params filter:on
	),


	private
	
	
	/**  
	 */
	on create do
	(
	)	
)