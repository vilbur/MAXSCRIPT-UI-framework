filein( getFilenamePath(getSourceFileName()) + "/ControlTypes/BrowsePath/BrowsePath.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlTypes/Radiobuttons/Radiobuttons.ms" )

filein( getFilenamePath(getSourceFileName()) + "/ControlValue/ControlValue.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlParamsCreator/ControlParamsCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/TooltipCreator/TooltipCreator.ms" )
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
	Ini,
	
	/* properties */
	--DEBUG = true,
	DEBUG = false,
	
	/* dependency */
	_Controls,

	ParamsCreator	= ControlParamsCreator_v(),
	ControlValue 	= ControlValue_v(),
	TooltipCreator	= TooltipCreator_v(),
	EventBinder	= ControlEventBinder_v _Rollout:_Rollout,

	
	/** Add controls to rollout
	 */
	function addControls _Controls =
	(
		format "\n\n-------------- Controls group:% --------------\n" _Controls.group
		--format "_Controls.list.count	= % \n" _Controls.list.count
		
		if _Controls.list.count == 0 then
			return false
		
		this._Controls = _Controls

		if not this.isGroupboxControls() then 
			GroupBoxCreator.addGrouboxes (_Rollout.getFullId()) (_Controls.GroupBoxes)
		
		/* pass DEFAULT PARAMETERS to params creator */ 
		ParamsCreator.setDefaultParameters(_Controls.DefaultParameters)
		
		
		for _Control in _Controls.list do
		(
			ParamsCreator.mergeParams(_Control)
			--format "_Control.Params	= % \n" _Control.Params
			ControlValue.setControlValue (_Control) (_Rollout.id)

			TooltipCreator.addTooltips(_Control)

			this.addToAutoRunEvents(_Control) -- MUST RUN BEFORE EventBinder.combineEvents(), because only custom events are used to autorun

			EventBinder.combineEvents(_Control)

			this._customizeControlTypes(_Control)
		)
		
		
		/* modify ACROSS PARAMETER */
		if not this.isGroupboxControls() then 
			(AcrossParameterModifier_v()).addFakeControls(this._Controls)
		
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

			MOVE THIS METHOD TO GroupboxCreator and REFRACT IT

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
			controls_in_groupboxes = for _Control in _Controls.list where _Control.Params.getVal #GroupBox != undefined and _Control.type != #GroupBox collect _Control -- Get controls with defined groupbox in params AND they are not groupbox
			
			_Controls.list = ( diffArray _Controls.list controls_in_groupboxes)

			Controls_in_all_groupboxes += controls_in_groupboxes
		)

		/** CREATE CONTROLS LIST WHICH IS NOT RENDERED
		  *	
		  */
		if( Controls_in_all_groupboxes.count > 0 ) then
		(
			--local _Controls_groupbox = _Rollout_.Controls group:( toUpper _Rollout_.title+" CONTROLS")
			local _Controls_groupbox = _Rollout_.Controls group:#controls_in_groupboxes

			--_Controls_groupbox.control #button (_Rollout_.title+" GOOOOOOD") 
			for Control_in_Groupbox in Controls_in_all_groupboxes do
				_Controls_groupbox.add Control_in_Groupbox
		)

		_Rollout_ --return
	),

	private

	/** Add controls box to UI
	 */
	function _addControlsToRollout =
	(
		--format "\n"; print "ControlCreator_v._addControlsToRollout()"
		if not this.isGroupboxControls() then 
			this._addControlsGroup #start

			
		for _Control in _Controls.list do
			this._addControlToRollout (_Control) -- add control first before variables, functions and events
			
			
		if not this.isGroupboxControls() then 
			this._addControlsGroup #end 
	),

	/* Add control to RolloutCreator
	 */
	function _addControlToRollout _Control =
	(
		params = ParamsCreator.join(_Control.params)

		/* DEBUG LOG */ 
		--if not matchPattern _Control.id pattern:"LABEL_fake*" then -- DEBUG - don`t print
		--format "_Control.type	= % \n" _Control.type
		--if _Control.type == #GroupBox then -- DEBUG - don`t print
		if DEBUG then 
		(
			format "\nControl:%.%" ( _Rollout.id as string ) _Control.id
			
			format "	Params: % \n" params
		)
		
		_Rollout.RCI.addControl (_Control.type) (_Control.id) (this._getCaption(_Control.caption)) paramStr:params filter:true;
	),

	/** Add Handlers of Events
	 */
	function _addHandlersToRollout =
	(
		for _Control in _Controls.list do
			EventBinder.addHandlers(_Control)
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

		_Rollout.RCI.addText ( start_or_end_string ) filter:on
	),

	/** Empty caption if caption is in square brackets
	  *
	  * Mainly used for groupbox control
	  * 
	  * @property	string	caption	of control
	  *
	  * @return	string return empty string if caption is for instance "[Foo Control Caption]"
	 */
	function _getCaption caption =
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
				_Rollout.RCI.addLocal ( _Control.add_locals[i] as string )  init:_Control.add_locals[i+1]
	),

	/** Add functions to rollout
	  * IMPORTANT: functions must be defined outside group 
	 */
	function _addTextToRollout =
	(
		--print "ControlCreator_v._addTextToRollout()"
		for _Control in _Controls.list where _Control.add_text != undefined do
			_Rollout.RCI.addText  _Control.add_text filter:true
	),

	/** Convert custom controls to native maxscript controls
	 */
	function _customizeControlTypes _Control =
	(
		--print "ControlCreator_v._customizeControlTypes()"
		if _Control.type == #browsePath then
			(BrowsePath_v()).convertToEditText(_Control)
		
		else if _Control.type == #Radiobuttons then
			(RadioButtons_v()).setParams(_Control)
	),
	/** Add to auto run
	 */
	function addToAutoRunEvents _Control =
	(
		--format "\n"; print "ControlCreator_v.addToAutoRunEvents()"
		if( Event = _Control.Events.get #changed ) != undefined and _Control.Params.getVal "checked" == true then
			append AUTORUN_EVENTS Event.CODE
	), 

	/** _is controls
	 */
	function _isControls _Struct =
	(
		--format "\n"; print "ControlCreator_v._isControls()"
		toLower (( filterString( classof _Struct as string ) "_*(:" )[2]) == "controls"  --return		
	),

	/** If controls list is not temporary
	 */
	function isGroupboxControls =
	(
		--format "\n"; print "ControlCreator_v.isNotGroupboxControls()"
		--this._Controls.group == #controls_in_groupboxes or this._Controls.group == #hotkeys_timers
		this._Controls.group == #controls_in_groupboxes
	),
	
	/**  
	 */
	on create do
	(
		--print "ControlCreator_v.onCreate()"
		ControlValue.Ini = Ini
		
		EventBinder.ini_path	= Ini.getPath()
	)	
)