filein( getFilenamePath(getSourceFileName()) + "/BrowsePath/BrowsePath.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlParamsCreator/ControlParamsCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlEventBinder/ControlEventBinder.ms" )
filein( getFilenamePath(getSourceFileName()) + "/AcrossParameterModifier/AcrossParameterModifier.ms" )
filein( getFilenamePath(getSourceFileName()) + "/GroupBoxCreator/GroupBoxCreator.ms" )

/** ControlCreator_v
 */
struct ControlCreator_v
(
	__construct = #( #_Rollout, #ini_path ),

	/* construct */ 
	_Rollout,
	ini_path, -- set in RolloutCreator_v._setIniToRollouts()

	/* dependency */
	_Controls,

	AcrossModifier	= AcrossParameterModifier_v(),
	ParamsCreator	= ControlParamsCreator_v(),
	EventBinder	= ControlEventBinder_v _Rollout:_Rollout ini_path:ini_path,

	/** Add controls
	 */
	function addControls _Controls =
	(
		format "\n\n--------------	Controls group:%	--------------\n" _Controls.group;
		--print ("ControlCreator_v.addControls()"  )

		--this._Rollout  = _Rollout
		this._Controls = _Controls
		--format "_Controls	= % \n" this._Controls
		--format "_Controls.group	= % \n" this._Controls.group

		GroupBoxCreator.addGrouboxesForRollout (_Rollout.getFullId()) (_Controls.GroupBoxes)

		/* set DEFAULT PARAMETERS */ 
		ParamsCreator.setControlDefaults (_Controls.Defaults)

		for _Control in _Controls.list do
		(
			ParamsCreator.mergeParams(_Control)

			EventBinder.combineEvents(_Control)

			this._mutateCustomControlTypes(_Control)
		)

		/* modify ACROSS PARAMETER */ 
		AcrossModifier.addFakeControls(this._Controls)

		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout()

		/* add TEXT */ 
		this._addTextToRollout()

		/* add CONTROLS */ 
		this._addControlsToRollout()

		/* add HANDLERS */ 
		this._addHandlersToRollout()

	),

	/** Controls to groupbox will be rendered as last

			MOVE THIS METHOD TO GroupboxCreator

	 */
	function createControlsInGroupboxLast &_Rollout_ =
	(
		--format "\n"; print ("ControlCreator_v._createControlsInGroupboxLast() "+_Rollout_.id as string) 
		--format "_Rollout_.id	= % \n" _Rollout_.id
		--format "_Rollout_._Controls	= % \n" _Rollout_._Controls

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
		)

		local Controls_in_Groupboxes = #()

		for _Controls in _Rollout_._Controls where this._isControls(_Controls) do
		(
				rollout_groupbox_controls = for _Control in _Controls.list where _Control.Params.getVal #GroupBox != undefined and _Control.type != #GroupBox collect _Control
				_Controls.list = ( diffArray _Controls.list rollout_groupbox_controls)

				Controls_in_Groupboxes += rollout_groupbox_controls
		)

		if( Controls_in_Groupboxes.count > 0 ) then
		(
			local _Controls_groupbox = _Rollout_.Controls group:( toUpper _Rollout_.title+" CONTROLS")

			--_Controls_groupbox.control #button (_Rollout_.title+" GOOOOOOD") 
			for Control_in_Groupbox in Controls_in_Groupboxes do
				_Controls_groupbox.add Control_in_Groupbox
		)

		_Rollout_ --return
	),

	private

	/** _add controls
	 */
	function _addControlsToRollout =
	(
		--print "ControlCreator_v._addControlsToRollout()"

		this._addControlsGroup #start

		for _Control in _Controls.list do
			this._addControlToRollout (_Control) -- add control first before variables, functions and events

		this._addControlsGroup #end 
	),

	/* Add control to RolloutCreator
	 */
	function _addControlToRollout _Control =
	(
		format "\n"; print ("ControlCreator_v._addControlToUi() " +_Control.id )
		--format "_Control.id.full	= % \n"( _Rollout.getFullId() +"." +_Control.id)
		this._addValueParameter  (_Control) (_Rollout.id)

		params = ParamsCreator.join(_Control.params)
		--format "\n% %\n" _Control.id params
		--format "_Control	= % \n" _Control
		_Rollout._RolloutCreator.addControl (_Control.type) (_Control.id) (this._emptyCaptionIfInBrackets(_Control.caption)) paramStr:params
	),

	/** Add Handlers of Events
	 */
	function _addHandlersToRollout =
	(
		for _Control in _Controls.list do
			EventBinder.addHandlers(_Control)
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
	
	/** Add controls group
	  * 
	  * https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_1361B847_7878_4C52_98DE_5BC5CA830B40_htm
	 */
	function _addControlsGroup start_or_end =
	(
		--print ("ControlCreator_v._addControlsGroup() " + start_or_end as string )
		if( _Controls.group == undefined or  matchPattern _Controls.group pattern:("[*]") or _Controls.group == "" ) do
			return false

		start_or_end_string = if( start_or_end == #start ) then "group @"+_Controls.group+"@ (" else ")"

		_Rollout._RolloutCreator.addText ( start_or_end_string ) filter:on
	),

	/** Empty caption if caption is in brackets E.G.: "[Groupboxname]"
	  *
	  * used for generated groupbox
	 */
	function _emptyCaptionIfInBrackets caption =
	(
		if( matchPattern caption pattern:("[*]")  ) then
			caption	= ""

		caption --return
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

	/** Convert custom controls to native maxscript controls
	 */
	function _mutateCustomControlTypes _Control =
	(
		--print "ControlCreator_v._mutateCustomControlTypes()"
		if _Control.type == #browsePath do
			(BrowsePath_v()).mutateControl(_Control)
	),

	/** _is controls
	 */
	function _isControls _Struct =
	(
		--format "\n"; print "ControlCreator_v._isControls()"
		toLower (( filterString( classof _Struct as string ) "_*(:" )[2]) == "controls"  --return		
	),

	/**  
	 */
	on create do
	(
		--print "ControlCreator_v.onCreate()"
		--ConstructPropeties test:this
		EventBinder.ini_path	= ini_path
	)	
)