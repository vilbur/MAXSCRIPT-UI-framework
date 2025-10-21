filein( getFilenamePath(getSourceFileName()) + "/ControlValue/ControlValue.ms" )	-- "./ControlValue/ControlValue.ms"
filein( getFilenamePath(getSourceFileName()) + "/TooltipCreator/TooltipCreator.ms" )	-- "./TooltipCreator/TooltipCreator.ms"
filein( getFilenamePath(getSourceFileName()) + "/GroupBoxCreator/GroupBoxCreator.ms" )	-- "./GroupBoxCreator/GroupBoxCreator.ms"
filein( getFilenamePath(getSourceFileName()) + "/ControlEventBinder/ControlEventBinder.ms" )	-- "./ControlEventBinder/ControlEventBinder.ms"
filein( getFilenamePath(getSourceFileName()) + "/ControlParamsCreator/ControlParamsCreator.ms" )	-- "./ControlParamsCreator/ControlParamsCreator.ms"
filein( getFilenamePath(getSourceFileName()) + "/AcrossParameterModifier/AcrossParameterModifier.ms" )	-- "./AcrossParameterModifier/AcrossParameterModifier.ms"

filein( getFilenamePath(getSourceFileName()) + "/EventTypes/EventTypes.ms" )	-- "./EventTypes/EventTypes.ms"
filein( getFilenamePath(getSourceFileName()) + "/ControlEventCreator/ControlEventCreator.ms" )	-- "./ControlEventCreator/ControlEventCreator.ms"

/** ControlCreator_v
 */
struct ControlCreator_v
(
	__construct = #( #_Rollout, #ini_path ),

	/* construct */
	_Rollout,
	Ini,

	/* properties */
	--DEBUG = true,
	DEBUG = false,

	/* dependency */
	Controls,

	ControlValue 	= ControlValue_v(),	-- "./ControlValue/ControlValue.ms"
	ParamsCreator	= ControlParamsCreator_v(), 	-- "./ControlParamsCreator/ControlParamsCreator.ms"
	ControlEventCreator	= ControlEventCreator_v _Rollout:_Rollout, 	-- "./ControlEventCreator/ControlEventCreator.ms"
	ControlEventBinder	= ControlEventBinder_v  _Rollout:_Rollout,	-- "./ControlEventBinder/ControlEventBinder.ms"

	/** Add controls to rollout
	 */
	function addControls Controls =
	(
		--if DEBUG then format "\n\n-------------- ControlCreator_v.addControls() group:% --------------\n" Controls.group
		--format "\n\n-------------- ControlCreator_v.addControls() group:% --------------\n" Controls.group
		--format "Controls.list.count: %\n" Controls.list.count

		/* EXIT IF ANY CONTROLS EXISTS */ 
		if Controls.list.count == 0 then
			return false
		
		
		/* SET CONTROLS TO PROPERTY */ 
		this.Controls = Controls
		
	
		/* pass DEFAULT PARAMETERS to params creator */
		ParamsCreator.setDefaultParameters(this.Controls.DefaultParameters)
		
		
		
		/*------------------------------------------------------------------------------
			PREPARE EACH CONTROL
		--------------------------------------------------------------------------------*/
		for _Control in this.Controls.list do
		(
			--format "_Control.params: %\n" _Control.params
			
			/* SET CAPTION */ 
			this._setCaption(_Control)
			
			
			/* MERGE DEFAULT AND USER PARAMS */ 
			ParamsCreator.mergeDefaultParams(_Control)
			--format "_Control.params: %\n" _Control.params

			/* SET VALUE OF CONTROL */ 
			ControlValue.setControlValue (_Control) (this._getIniValue(_Control))
			--format "_Control.params: %\n" _Control.params


			/* PREPARE CONTROL EVENTS */ 
			ControlEventCreator.prepareEvents(_Control)

			/* MUTATE EXTRA CONTROL TYPYES TO STADARD CONTROLS */ 
			this._customizeControlTypes(_Control)
		)

		
		/* modify ACROSS PARAMETER */
		--if not this.isGroupControl() then
			( AcrossParameterModifier = AcrossParameterModifier_v()).addFakeControls(this.Controls)

		
		/* JOIN PARAMETERS */ 
		this._joinParamsToString()
		
		

		/* ADD CONTROLS TO GROUPBOX */ 
		GROUPBOXCREATOR.createTempRollouts( this.Controls.List)(_Rollout.width)
		
			
		/* add LOCAL VARIABLES */
		this._addLocalVariablesToRollout()

		/* add TEXT */
		this._addTextToRollout()

		/* add CONTROLS */
		this._addControlsToRollout()

		/* add HANDLERS */
		this._addHandlersToRollout()

		
		
		/* REMOVE FAKE CONTROLS -- it allows to add controls when dialog exists */
		if AcrossParameterModifier != undefined then
			AcrossParameterModifier.removeFakeControls(this.Controls)
	),

	--/** Controls to groupbox will be rendered as last
	--
	--		TODO: MOVE moveGrouboxControlsToEnd() TO GroupboxCreator and REFRACT IT
	--
	-- */
	--function moveGrouboxControlsToEnd &_Rollout_ =
	--(
	--	format "\n"; print ("ControlCreator_v.createControslInGroupboxAsLast() "+_Rollout_.id as string)
	--	Controls_in_all_groupboxes = #()
	--	
	--	fn diffArray array_to_remove items_to_remove =
	--	(
	--		for item_to_remove in items_to_remove where ( index = findItem array_to_remove item_to_remove ) > 0 do 
	--			deleteItem array_to_remove index
	--		
	--		array_to_remove --return
	--	)
	--	
	--	/*  */ 
	--	for Controls in _Rollout_._Controls where this._isControls(Controls) do
	--	(
	--		controls_in_groupboxes = for _Control in Controls.list where _Control.Params[#GROUPBOX] != undefined and _Control.type != #GROUPBOX collect _Control -- Get controls with defined groupbox in params AND they are not groupbox
	--	
	--		Controls.list = ( diffArray Controls.list controls_in_groupboxes)
	--	
	--		Controls_in_all_groupboxes += controls_in_groupboxes
	--	)
	--	
	--	/** CREATE CONTROLS LIST WHICH IS NOT RENDERED
	--	  *
	--	  */
	--	if( Controls_in_all_groupboxes.count > 0 ) then
	--	(
	--		--local _Controls_groupbox = _Rollout_.Controls group:( toUpper _Rollout_.title+" CONTROLS")
	--		_Controls_groupbox = _Rollout_.Controls group:#CONTROLS_IN_GROUPBOXES
	--	
	--		--_Controls_groupbox.control #button (_Rollout_.title+" GOOOOOOD")
	--		for Control_in_Groupbox in Controls_in_all_groupboxes do
	--			_Controls_groupbox.add Control_in_Groupbox
	--	)
	--	
	--	_Rollout_ --return
	--),

	private

	/*------------------------------------------------------------------------------
	
		ADD CONTROLS TO UI
	
	--------------------------------------------------------------------------------*/
	function _addControlsToRollout =
	(
		--clearListener(); print("Cleared in:\n"+getSourceFileName())
		--format "\n"; print "ControlCreator_v._addControlsToRollout()"
		--format "this.isGroupControl()	= % \n" (this.isGroupControl())
		
		/** ADD START OR END OF GROUP
		  *
		  * wrap controls to "group(...)"
		  *
		  *
		  * GROUP IS IGNORED IF
		  * 		1) Controls.group name is empty string E.G.: ""
		  *		2) Controls.group name is wraped in square brackets like [Foo Controls]
		  *
		  * HELP: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_1361B847_7878_4C52_98DE_5BC5CA830B40_htm&v=2015#WS73099CC142F48755-2231E4B3128E0E4A0FC-69B6
		 */
		function _addControlsGroup start_or_end =
		(
			--format "\n"; print "ControlCreator_v._addControlsGroup()"
			--format "start_or_end: %\n" start_or_end
			--format "Controls.group:-%-\n" Controls.group
			--format "MATCH: %\n" (matchPattern Controls.group pattern:("[*]"))
			if( Controls.group == undefined or matchPattern Controls.group pattern:("[*]") or Controls.group == "" ) do
				return false
	
			start_or_end_string = if( start_or_end == #START ) then "group @"+Controls.group+"@ (" else ")"
			
			--if( start_or_end == #START ) then
				--FORMAT "ADD GROUP: %" Controls.group
				
			_Rollout.RCI.addText ( start_or_end_string ) filter:on
		)
		
		/*------------------------------------------------------------------------------
			GROUP BEGIN
		--------------------------------------------------------------------------------*/
		
		if not this.isGroupControl() then
			_addControlsGroup #start

			
		/*------------------------------------------------------------------------------
		  
			ADD EACH CONTROL
			
		--------------------------------------------------------------------------------*/
		
		for _Control in this.Controls.list do
			this._addControlToRollout (_Control) -- add control first before variables, functions and events

			
		/*------------------------------------------------------------------------------
			GROUP END
		--------------------------------------------------------------------------------*/
			
		if not this.isGroupControl() then
			_addControlsGroup #end
	),

	/*------------------------------------------------------------------------------
		
		ADD CONTROL TO UI
		
	--------------------------------------------------------------------------------*/
	function _addControlToRollout _Control =
	(
		--format "\n\n"; print "ControlCreator_v._addControlToRollout()"
		--format "_Control.id: %\n" _Control.id
		--format "_Control.type: %\n" _Control.type
		--format "\n%: %\n" _Control.id _Control.params_str

		params_str = _Control.params_str
		
		if (groupbox_id = _Control.Params[#GROUPBOX]) != undefined then
			params_str = "pos:[ 0, 0 ] " + _Control.params_str
		
		/* ADD CONTROL */ 
		_Rollout.RCI.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:params_str filter:true;
	),
	
	/** Join params to string
	 */
	function _joinParamsToString =
	(
		--format "\n"; print "ControlCreator_v._joinParamsToString()"
		for _Control in this.Controls.list do
			_Control.params_str = ParamsCreator.join(_Control.params)
	),

	/*------------------------------------------------------------------------------
	
		ADD HANDLERS OF EVENTS
	
	--------------------------------------------------------------------------------*/
	function _addHandlersToRollout =
	(
		for _Control in this.Controls.list do
			ControlEventBinder.addHandlers(_Control)
	),

	/** Empty caption if caption is in square brackets
	  *
	  * Mainly used for groupbox control
	  *
	  *
	  * @return	string return empty string if caption is for instance "[Foo Control Caption]"
	 */
	function _setCaption &_Control =
	(
		--format "\n"; print "ControlCreator_v._setCaption()"

		if( matchPattern _Control.caption pattern:("[*]")  ) then
			_Control.caption	= case _Control.type of
			(
				#Groupbox:	" "

				default:	""
			)

		_Control --return
	),

	/** Add local variables from Control_v to rollout
	  * IMPORTANT: local variables must be defined outside group
	  *
	  * 	Control_v.rollout_locals =  #(#variable_name1, init_value1, #variable_name2, init_value2)
	 */
	function _addLocalVariablesToRollout =
	(
		--print "ControlCreator_v._addLocalVariablesToRollout()"
		for _Control in this.Controls.list where _Control.add_locals != undefined do
			for local_var_name in _Control.add_locals.keys do
				_Rollout.RCI.addLocal ( local_var_name as string )  init:_Control.add_locals[local_var_name]
	),

	/** Add functions to rollout
	  * IMPORTANT: functions must be defined outside group
	 */
	function _addTextToRollout =
	(
		--print "ControlCreator_v._addTextToRollout()"
		for _Control in this.Controls.list where _Control.add_text != undefined do
			_Rollout.RCI.addText  _Control.add_text filter:true
	),

	/** Convert custom controls to native maxscript controls
	 */
	function _customizeControlTypes _Control =
	(
		--print "ControlCreator_v._customizeControlTypes()"
		case _Control.type of
		(
			#BROWSEPATH:	(BrowsePath_v()).convertToEditText(_Control)	
			#RADIOBUTTONS:	(RadioButtons_v()).setParams(_Control)	
			#DROPDOWNLIST:	(DropdownList_v()).setHeightByItemsCount(_Control)	
			--#SLIDER:	(Slider_v()).setLocalsForCustomEvents(_Control)	
		)
	),

	/** _is controls
	 */
	function _isControls _Struct =
	(
		--format "\n"; print "ControlCreator_v._isControls()"
		toLower (( filterString( classof _Struct as string ) "_*(:" )[2]) == "controls"  --return
	),
	
	/** Get value from ini file
	 */
	function _getIniValue _Control =
	(
		--format "\n"; print "ControlValue_v._getIniValue()"
		if Ini.isDefined() then
		(
			ini_enabled = if ( ini_param = _Control.Params[#ini] ) != undefined then ini_param else true
			
			if ini_enabled and (ini_value = Ini.load(_Rollout.id)(_Control.id)) != undefined then
				ini_value --return
		)
	),
	
	/** If controls list is not temporary
	 */
	function isGroupControl =
	(
		--format "\n"; print "ControlCreator_v.isGroupControl()"
		this.Controls.group == #CONTROLS_IN_GROUPBOXES
	),

	/**
	 */
	on create do
	(
		--print "ControlCreator_v.onCreate()"
	)
)