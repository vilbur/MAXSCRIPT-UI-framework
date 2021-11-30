filein( getFilenamePath(getSourceFileName()) + "/ControlParamsCreator/ControlParamsCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlEventsCreator/ControlEventsCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/AcrossParameterModifier/AcrossParameterModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/BrowsePath/BrowsePath.ms" )

/** ControlCreator_v
 */
struct ControlCreator_v
(
	
	_Rollout,
	_Controls,
	
	ParamsCreator	= ControlParamsCreator_v(),
	EventsCreator	= ControlEventsCreator_v(),
	AcrossModifier	= AcrossParameterModifier_v(),

	/** Add controls
	 */
	function addControls _Rollout _Controls =
	(
		--print "ControlCreator_v.addControls()"
		--format "_Controls.Defaults	= % \n" _Controls.Defaults
		this._Rollout  = _Rollout
		this._Controls = _Controls
		
		/* set DEFAULT PARAMETERS */ 
		ParamsCreator.ControlDefaults = _Controls.Defaults
	
		
		/* prepare CONTROL TYPES */ 
		this._convertCustomControls()
		
		
		/* merge PARAMTERS */ 
		this._mergeControlsParameters()
		
		
		/* modify ACROSS PARAMETER */ 
		AcrossModifier._acrossParameterModify(this._Controls)
		
		
		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout()
		
		
		/* add TEXT */ 
		this._addTextToRollout()
		
		
		/* add CONTROLS */ 
		this._addControlsToRollout()
	),
	
	
	private
	
	

	/** Convert custom controls to native maxscript controls
	 */
	function _convertCustomControls =
	(
		for _Control in _Controls.list do
			if( _Control.type == #browsePath ) then
				_Control = (BrowsePath_v _Control:_Control).getControl()
	),
	
	/** _add controls
	 */
	function _addControlsToRollout =
	(
		this._addControlsGroup #start 
		
		for _Control in _Controls.list do
		(
			this._addControl (_Control) -- add control first before variables, functions and events
			
			this._addControlHandlersToRollout(_Control)
		)
		
		this._addControlsGroup #end 
	),

	/** Add controls group
	  * 
	  * https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_1361B847_7878_4C52_98DE_5BC5CA830B40_htm
	 */
	function _addControlsGroup start_or_end =
	(
		--print ("ControlCreator_v._addControlsGroup() " + start_or_end as string )
		if( _Controls.group == undefined ) do
			return false

		_Rollout._RolloutCreator.addText (if( start_or_end == #start ) then "group @"+_Controls.group+"@ (" else ")" ) filter:on
	),

	
	/* Add control to RolloutCreator
	 */
	function _addControl _Control =
	(
		--format "\n"
		--print ("ControlCreator_v._addControl() " +_Control.id )
		--params = (ParamsCreator.getParams(_Control)(_Rollout.id))
		params = ParamsCreator.join(_Control.params)
		format "params	= % \n" params
		_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:params
		--_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:""1
	),
	
	/** _set controls parameters
	 */
	function _mergeControlsParameters =
	(
		for _Control in _Controls.list do
			ParamsCreator.mergeParams(_Control)
	),
	
	/** _add value parameter
	 */
	function _addValueParameter =
	(
		print "ControlCreator_v._addValueParameter()"
		
		val_ini	= ControlValue.getValueFromIni(_Control)(rollout_id)
		value_param	= this._getValueParameterArray(_Control)(val_ini)
	),
	
	/** Add event handlers
	 */
	function _addControlHandlersToRollout _Control =
	(
		--print "ControlCreator_v._addControlHandlersToRollout()"
		events_list = EventsCreator.getEvents(_Control)(_Rollout.id)
		--for Event in events_list do format "Event	= % \n" Event
		
		for Event in events_list do
			_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:(Event.code) paramStr:Event.params filter:on
	),
	
	/** Add local variables from Control_v to rollout
	  * IMPORTANT: local variables must be defined outside group 
	  *
	  * 	Control_v.rollout_locals =  #(#variable_name1, init_value1, #variable_name2, init_value2)
	 */
	function _addLocalVariablesToRollout =
	(
		--print "ControlCreator_v._addLocalVariablesToRollout()"
		for _Control in _Controls.list where _Control.add_locals != unsupplied do
			for i = 1 to _Control.add_locals.count by 2 do
				_Rollout._RolloutCreator.addLocal ( _Control.add_locals[i] as string )  init:_Control.add_locals[i+1]
				
	),
	
	/** Add functions to rollout
	  * IMPORTANT: functions must be defined outside group 
	 */
	function _addTextToRollout =
	(
		--print "ControlCreator_v._addTextToRollout()"
		for _Control in _Controls.list where _Control.add_text != undefined do
			_Rollout._RolloutCreator.addText  _Control.add_text filter:true
	),
	/**  
	 */
	on create do
	(
	)	
)