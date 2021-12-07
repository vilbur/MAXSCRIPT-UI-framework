filein( getFilenamePath(getSourceFileName()) + "/ControlParamsCreator/ControlParamsCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlEventsCreator/ControlEventsCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/AcrossParameterModifier/AcrossParameterModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/GroupBoxCreator/GroupBoxCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/BrowsePath/BrowsePath.ms" )

/** ControlCreator_v
 */
struct ControlCreator_v
(

	_Rollout,
	_Controls,

	--AcrossModifier,
	AcrossModifier	= AcrossParameterModifier_v(),
	ParamsCreator	= ControlParamsCreator_v(),
	EventsCreator	= ControlEventsCreator_v(),

	/** Add controls
	 */
	function addControls _Controls =
	(
		--print "ControlCreator_v.addControls()"
		this._Rollout  = _Rollout
		this._Controls = _Controls
		--AcrossModifier	= AcrossParameterModifier_v()
		--format "_Controls.GroupBoxes	= % \n" _Controls.GroupBoxes
		
		GroupBoxCreator.GroupBoxes = _Controls.GroupBoxes
		
		this.moveGroupBoxcontrolsToEnd()
		
		/* set DEFAULT PARAMETERS */ 
		ParamsCreator.setControlDefaults (_Controls.Defaults)

		/* merge PARAMTERS */ 
		this._mergeControlsParameters()

		/* prepare CONTROL TYPES */ 
		this._convertCustomControls()

		/* modify ACROSS PARAMETER */ 
		AcrossModifier.addFakeControls(this._Controls)

		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout()

		/* add TEXT */ 
		this._addTextToRollout()

		/* add CONTROLS */ 
		this._addControlsToRollout()
	),

	private
	
	
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
		format "\n"
		print ("ControlCreator_v._addControl() " +_Control.id )
		--format "_Control	= % \n" _Control
		this._addValueParameter  (_Control) (_Rollout.id)
		
		params = ParamsCreator.join(_Control.params)
		format "params	= % \n" params
		_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:params
	),
	
	/** Move group boxcontrols to end
	 */
	function moveGroupBoxcontrolsToEnd =
	(
		--print "ControlCreator_v.moveGroupBoxcontrolsToEnd()"
		
		Controls_in_Groupboxes	= #()
		
		for _Control in _Controls.list do
		(
			if( (control_is_in_group_box = _Control.Params.getVal #GroupBox) != undefined ) then -- set controls positionin group box to zero
				_Control.param #pos	[0, 0]
			
			if( _Control.type == #groupbox ) then
			(

				if( (groupbox_height =  (_Controls.GroupBoxes.getVal(_Control.id)).count * 27) == 0 ) then 
					groupbox_height = 64

				_Control.param #height groupbox_height
			)
			else

			if( (group_box_name = _Control.Params.getVal #GroupBox) != undefined ) then
				append Controls_in_Groupboxes _Control
			
		)
		
		_Controls.list = ( this.diffArray _Controls.list Controls_in_Groupboxes) + Controls_in_Groupboxes

	),
	
	/**  
	  *	
	  */
	fn diffArray a b =
	(
		retArray = #()
		for element in a do
		(
			idx = finditem b element
			if idx == 0 then
			append retArray element
		)
		return retArray
	),
	
	/** _merge controls parameters
	 */
	function _mergeControlsParameters =
	(
		--print "ControlCreator_v._mergeControlsParameters()"
		for _Control in _Controls.list do
			ParamsCreator.mergeParams(_Control)
	),

	/** Convert custom controls to native maxscript controls
	 */
	function _convertCustomControls =
	(
		for _Control in _Controls.list do
			if( _Control.type == #browsePath ) then
				_Control = (BrowsePath_v _Control:_Control).getControl()
	),

	/** _add value parameter
	 */
	function _addValueParameter _Control rollout_id = 
	(
		--print "ControlCreator_v._addValueParameter()"
		val_ini	= ParamsCreator.ControlValue.getValueFromIni(_Control)(rollout_id)
		
		if( val_ini != undefined ) then
			_Control.Params.setVal val_ini[1] val_ini[2]
	),

	/** Add event handlers
	 */
	function _addControlHandlersToRollout _Control =
	(
		--print "ControlCreator_v._addControlHandlersToRollout()"
		events_list = EventsCreator.getEvents(_Control)(_Rollout.id)
		--for Event in events_list do format "Event	= % \n" Event

		for Event in events_list do
		(
			--format "Event	= % \n" Event
			_Rollout._RolloutCreator.addHandler _Control.id Event.type codeStr:(Event.code) paramStr:Event.params filter:on
		)
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
		--print "ControlCreator_v.onCreate()"
	)	
)