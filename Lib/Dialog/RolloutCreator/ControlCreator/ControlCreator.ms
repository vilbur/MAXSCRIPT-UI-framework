filein( getFilenamePath(getSourceFileName()) + "/../../Rollout/Controls/ControlParams/ControlParams.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlEvents/ControlEvents.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlCustomType/ControlCustomType.ms" )

/** ControlCreator_v
 */
struct ControlCreator_v
(
	
	_Rollout,
	_Controls,
	
	ControlParams	= ControlParams_v(),
	ControlEvents	= ControlEvents_v(),
	ControlCustomType	= ControlCustomType_v(),

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

	
	/* Add control to RolloutCreator
	 */
	function addControl _Control =
	(
		print ("ControlCreator_v.addControl()	" +_Control.id)
		if( _Control.type == #browsePath ) then
			_Control = ControlCustomType.getCustomControlType(_Control)
		
		/* add CONTROL */ 
		_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:(ControlParams.getParams(_Control)(_Rollout.id)) -- add control first before variables, functions and events

		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout (_Control)

		/* add FUNCTIONS */ 
		this._addFunctionsToRollout (_Control)

		/* add EVENTS */
		events_list = ControlEvents.getEvents(_Control)(_Rollout.id)

		this.addControlHandlersToRollout (_Control)(events_list)
	),
	
	/** Test
	 */
	function addControlHandlersToRollout _Control events_list =
	(
		--print "ControlCreator_v.addControlHandlersToRollout()"
		for Event in events_list do
			_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:("("+Event.code+")") paramStr:Event.params filter:on
	),
	
	/** Add local variables from Control_v to rollout
	  *
	  * 	Control_v.rollout_locals =  #(#variable_name1, init_value1, #variable_name2, init_value2)
	 */
	function _addLocalVariablesToRollout _Control =
	(
		--print "ControlCreator_v._addLocalVariablesToRollout()"
		--format "_Control.rollout_locals	= % \n" _Control.rollout_locals
		if( _Control.rollout_locals != unsupplied ) then
			for i = 1 to _Control.rollout_locals.count by 2 do
				_Rollout._RolloutCreator.addLocal ( _Control.rollout_locals[i] as string )  init:_Control.rollout_locals[i+1]
	),
	
	/** Add functions variables to rollout
	 */
	function _addFunctionsToRollout _Control =
	(
		--print "ControlCreator_v._addFunctionsToRollout()"
		--format "_Control.rollout_function	= % \n" _Control.rollout_function
		if( _Control.rollout_function != undefined ) then
				_Rollout._RolloutCreator.addText  _Control.rollout_function filter:true
	),
	
	
	private
	
	
	/**  
	 */
	on create do
	(
	)	
)