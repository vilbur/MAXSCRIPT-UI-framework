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
	function addControls _Controls =
	(
		--if DEBUG then format "\n\n-------------- ControlCreator_v.addControls() group:% --------------\n" _Controls.group
		--format "\n\n-------------- ControlCreator_v.addControls() group:% --------------\n" _Controls.group
		--format "_Controls.list.count: %\n" _Controls.list.count

		/* EXIT IF ANY CONTROLS EXISTS */ 
		if _Controls.list.count == 0 then
			return false
		
		
		/* SET CONTROLS TO PROPERTY */ 
		this.Controls = _Controls
		

		/* ADD CONTROL TO GROUPBOX */ 
		if not this.isGroupControl() then
			GROUPBOXCREATOR.addGrouboxes (_Rollout.getFullId() as name ) (this.Controls.GroupBoxes)

			
		/* pass DEFAULT PARAMETERS to params creator */
		ParamsCreator.setDefaultParameters(this.Controls.DefaultParameters)
		
		
		
		/* PREPARE EACH CONTROL */
		for _Control in this.Controls.list do
		(
			--format "_Control.params: %\n" _Control.params
			/* MERGE DEFAULT NAD USER PARAMS */ 
			ParamsCreator.mergeParams(_Control)
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
		if not this.isGroupControl() then
			( AcrossParameterModifier = AcrossParameterModifier_v()).addFakeControls(this.Controls)

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

	/** Controls to groupbox will be rendered as last

			TODO: MOVE moveGrouboxControlsToEnd() TO GroupboxCreator and REFRACT IT

	 */
	function moveGrouboxControlsToEnd &_Rollout_ =
	(
		--format "\n"; print ("ControlCreator_v.createControslInGroupboxAsLast() "+_Rollout_.id as string)
		Controls_in_all_groupboxes = #()

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
		--format "_Rollout_._Controls.count	= % \n" _Rollout_._Controls.count

		for _Controls in _Rollout_._Controls where this._isControls(_Controls) do
		(
			controls_in_groupboxes = for _Control in _Controls.list where _Control.Params[#GROUPBOX] != undefined and _Control.type != #GROUPBOX collect _Control -- Get controls with defined groupbox in params AND they are not groupbox

			_Controls.list = ( diffArray _Controls.list controls_in_groupboxes)

			Controls_in_all_groupboxes += controls_in_groupboxes
		)

		/** CREATE CONTROLS LIST WHICH IS NOT RENDERED
		  *
		  */
		if( Controls_in_all_groupboxes.count > 0 ) then
		(
			--local _Controls_groupbox = _Rollout_.Controls group:( toUpper _Rollout_.title+" CONTROLS")
			_Controls_groupbox = _Rollout_.Controls group:#CONTROLS_IN_GROUPBOXES

			--_Controls_groupbox.control #button (_Rollout_.title+" GOOOOOOD")
			for Control_in_Groupbox in Controls_in_all_groupboxes do
				_Controls_groupbox.add Control_in_Groupbox
		)

		_Rollout_ --return
	),

	private

	/** ADD CONTROLS BOX TO UI
	 */
	function _addControlsToRollout =
	(
		--format "\n"; print "ControlCreator_v._addControlsToRollout()"
		--format "this.isGroupControl()	= % \n" (this.isGroupControl())
		
		/** ADD START OR END OF GROUP
		  *
		  * wrap controls to "group(...)"
		  *
		  *
		  * GROUP IS IGNORED IF
		  * 		1) _Controls.group name is empty string E.G.: ""
		  *		2) _Controls.group name is wraped in square brackets like [Foo Controls]
		  *
		  * HELP: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_1361B847_7878_4C52_98DE_5BC5CA830B40_htm&v=2015#WS73099CC142F48755-2231E4B3128E0E4A0FC-69B6
		 */
		function _addControlsGroup start_or_end =
		(
			format "\n"; print "ControlCreator_v._addControlsGroup()"
			--format "_Controls.group:-%-\n" Controls.group
			--format "MATCH: %\n" (matchPattern _Controls.group pattern:("[*]"))
			if( Controls.group == undefined or matchPattern Controls.group pattern:("[*]") or Controls.group == "" ) do
				return false
	
			start_or_end_string = if( start_or_end == #START ) then "group @"+Controls.group+"@ (" else ")"
			
			if( start_or_end == #START ) then
				format "ADD GROUP: %" Controls.group
				
			_Rollout.RCI.addText ( start_or_end_string ) filter:on
		)
		
		
		/* BEGIN GROUP */ 
		if not this.isGroupControl() then
			_addControlsGroup #start

			
		/* ADD EACH CONTROL */ 
		for _Control in this.Controls.list do
			this._addControlToRollout (_Control) -- add control first before variables, functions and events

			
		/* END GROUP */ 
		if not this.isGroupControl() then
			_addControlsGroup #end
	),

	/*------------------------------------------------------------------------------
		
		ADD CONTROL TO UI
		
	--------------------------------------------------------------------------------*/
	function _addControlToRollout _Control =
	(
		--format "\n\n"; print "ControlCreator_v._addControlToRollout()"
		--format "_Control.params: %\n" _Control.params
		params = if _Control.is_in_groupbox then _Control.params else this._offsetControlsInGroupbox (_Control)
		
		param_str = ParamsCreator.join(params)
	
		--format "CONTROL: %		PARAMS: %\n" ( _Control.id) params
		--format "_Control.is_in_groupbox: %\n" _Control.is_in_groupbox
		/* ADD CONTROL */ 
		_Rollout.RCI.addControl (_Control.type) (_Control.id) (this._getCaption(_Control)) paramStr:param_str filter:true;
	),
	
	/** Offset controls in groupbox
	 */
	function _offsetControlsInGroupbox _Control =
	(
		--format "\n"; print "ControlCreator_v._offsetControlsInGroupbox()"
		
		params = _Control.params

		--params[#ACROSS] = 1
		--params[#ACROSS] = #LEFT
		--params[#POS] = [0,0]
		
		params --return
	),

	/** ADD HANDLERS OF EVENTS
	 */
	function _addHandlersToRollout =
	(
		for _Control in this.Controls.list do
			ControlEventBinder.addHandlers(_Control)
	),

	--/** Add controls group
	--  *
	--  * GROUP IS IGNORED IF
	--  * 		1) _Controls.group name is empty string E.G.: ""
	--  *		2) _Controls.group name is wraped in square brackets like [Foo Controls]
	--  *
	--  * https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_1361B847_7878_4C52_98DE_5BC5CA830B40_htm
	-- */
	--function _addControlsGroup start_or_end =
	--(
	--	--format "\n"; print "ControlCreator_v._addControlsGroup()"
	--	--format "_Controls.group:-%-\n" Controls.group
	--	--format "MATCH: %\n" (matchPattern _Controls.group pattern:("[*]"))
	--	if( Controls.group == undefined or matchPattern Controls.group pattern:("[*]") or Controls.group == "" ) do
	--		return false
	--
	--	start_or_end_string = if( start_or_end == #start ) then "group @"+Controls.group+"@ (" else ")"
	--
	--	_Rollout.RCI.addText ( start_or_end_string ) filter:on
	--),

	/** Empty caption if caption is in square brackets
	  *
	  * Mainly used for groupbox control
	  *
	  *
	  * @return	string return empty string if caption is for instance "[Foo Control Caption]"
	 */
	function _getCaption _Control =
	(
		--format "\n"; print "ControlCreator_v._getCaption()"
		--format "caption	= % \n" caption
		--format "_Control.type	= % \n" _Control.type

		caption = _Control.caption

		if( matchPattern _Control.caption pattern:("[*]")  ) then
			caption	= case _Control.type of
			(
				#Groupbox:	" "

				default:	""
			)


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
			#BROWSEPATH:	(BrowsePath_v()).convertToEditText(_Control)	-- "./BrowsePath/BrowsePath.ms"
			#RADIOBUTTONS:	(RadioButtons_v()).setParams(_Control)	-- "./RadioButtons/RadioButtons.ms"
			--#SLIDER:	(Slider_v()).setLocalsForCustomEvents(_Control)	-- "./Slider/Slider.ms"
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
			ini_enabled = if ( ini_param = _Control.Params.getVal (#ini) ) != undefined then ini_param else true
			
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