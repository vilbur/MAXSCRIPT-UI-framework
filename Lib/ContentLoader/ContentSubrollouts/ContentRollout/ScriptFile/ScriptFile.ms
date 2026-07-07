filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator/ControlsCreator/EventTypes/EventTypes.ms" )	--"./../../../../RolloutCreator/ControlsCreator/EventTypes/EventTypes.ms"


/*
		TODO:

		RENAME THIS FILE TO ContentControlCreator

*/


/** Process ".ms" & ".mcr" files
  *
  * Every ".mcr" file creates its own ControlsBox
  *
  * 1) Get all macroscripts from single '.mcr' file
  * 2) Create by macroscripts
  * 3) Filein ".mcr" files
  *
  * NOTICE: files can be ordered with prefixes like "_Filename|-Filename|1_Filename|1-Filename"
  *
  *
  * @property	string	file	Path to file
  *
  */
struct ScriptFile_Content_v
(
	
	/* public properties */
	_path, -- _path to *.mcr file
	
	/*------------------------------------------------------------------------------
		INHERIT PARAMETERS
	--------------------------------------------------------------------------------*/
	inherit_by_type	= #( #WIDTH, #HEIGHT, #ACROSS, #BORDER, #OFFSET ), -- parameters of controls which are propagated to next control type

	inherit_global	= #( #BORDER ), -- parameters of controls which are propagated to next control
	
	
	/* private properties */
	filename, -- filename of ".mcr" file
	MacroScripts	= #(),

	/* Dependency */
	_Controls,
	ControlEventBinder,
	QuadMenu,
	EventTypes = EventTypes_v(), 	-- "./../../../../RolloutCreator/ControlsCreator/EventTypes/EventTypes.ms"

	/* Store */
	InheritParams = Dictionary(),
	

	/** PARSE *.mcr FILE
	 */
	function loadAndParseMacroscriptFile =
	(
		--print ("------------\n\nScriptFile.loadAndParseMacroscriptFile file:\n"+ (_path) )
		if ( this.isMacrosriptFile() ) then
		(
			filein _path
			--format "MENU_MANAGER_GLOBAL: %\n" MENU_MANAGER_GLOBAL
			MacroScripts = MENU_MANAGER_GLOBAL.addMacrosToMenus (_path)
		)
	),

	/** Create controls from ".mcr" file to ui
	 */
	function addToUi &_Rollout =
	(
		--print("ScriptFile_Content_v.addToUi() " +_Rollout.id)
		if( this.isMacrosriptFile() and MacroScripts.count > 0 ) then
			this._createControls (_Rollout)

		_Rollout --return
	),


	
	private
	
	--/** ADD TO MENU
	-- */
	--function _addToMenu _MacroScript =
	--(
	--	--format "\n"; print "ScriptFile_Content_v._addToMenu()"
	--	
	--	if (menu_name_param = _MacroScript.Params[#menu]) != undefined then
	--		if menu_name_param != false then
	--		(
	--			
	--			title = case of
	--			(
	--				(menu_name_param	== true ): case of
	--				(
	--					(_MacroScript.buttontext	!= undefined):	_MacroScript.buttontext
	--					(_MacroScript.tooltip	!= ""):	_MacroScript.tooltip
	--					
	--					default: _MacroScript.macro_name
	--				)
	--				
	--				(menu_name_param as name	== #TOOLTIP ):	if _MacroScript.tooltip != undefined then _MacroScript.tooltip else _MacroScript.buttontext
	--				
	--				default: 	menu_name_param
	--			)
	--	
	--			/*------------------------------------------------------------------------------
	--				ADD TO MENU
	--			--------------------------------------------------------------------------------*/
	--			MENU_MANAGER_GLOBAL.addItemToMenu (_MacroScript.category) (_MacroScript.macro_name) (title)  --return
	--			
	--		)
	--),
	
	
	/** CREATE CONTROLS for each macroscript
	  * 
	 */
	function _createControls _Rollout =
	(
		--format "\n"; print("ScriptFile_Content_v._createControls()" )
		--format "MacroScripts.count: %\n" MacroScripts.count
		_Controls	= _Rollout.Controls	group:(this._getControlsGroupName())
		ControlEventBinder	= ControlEventBinder_v 	_Rollout:_Rollout

		/* ONLY macroscripts with BUTTONTEXT are created */ 
		for i = 1 to MacroScripts.count where MacroScripts[i].buttontext != undefined do
			this._createControlfromMacro (MacroScripts[i])
	),

	/** CREATE CONTROL FROM MACRO
	 */
	function _createControlfromMacro Macro =
	(
		--format "\n----------------------------------------------------------------------------------\n"
		--format "\n"; print "ScriptFile_Content_v.createControlfromMacro()"

		/* CREATE CONTROL */ 
		_Control = _Controls.Control (Macro.getControlType()) Macro.buttontext params:(Macro.getParamsArray()) add_to_controls:false

		/* ADD TO MENU */ 
		--this._addToMenu (Macro)(_Control.Params)		
		
		/* TRY GET CONTROL FOR MACRO */ 
		if(_Control_Exist = _Controls.get(_Control.id)) != undefined then
		
			/* UPDATE EXISTING CONTROL */ 
			_Control = _Control_Exist
		else
			/* GET PARAMETERS FROM PREVIOUS CONTROL */ 
			this._inheritParameters (_Control)

			
		/* ADD EVENTS */ 
		this._setEvent (_Control) (Macro)

		
		/* ADD TO CONTROLS - if control is new */ 
		if( _Control_Exist == undefined ) then
			_Controls.add _Control

	),

	/** Get filename of groupbox by file filename
	  *
	  *  Remove numbers, empty space and characters like "-_" from start of string E.G.: "1_Filename" >> "Filename"
	  *
	  * @return	string	Name of groupbox
	 */
	function _getControlsGroupName =
	(
		filename = getFilenameFile _path
		
		filename = trimLeft ( trimRight filename "_ " )  "_ " -- -- remove prefix & suffix E.G.: " _Foo-Bar _ " >>>  "Foo-Bar"
		
		filename = substituteString filename "_" " " -- replace underscore with whitepsace E.G.: "Foo_Bar" >>> "Foo Bar"
		
		( dotNetObject "System.Text.RegularExpressions.Regex" @"^[\d\.\s_-]+" ).Replace filename "" -- remove prefix & suffix E.G.: " 1-Foo Bar" >>> "" 1-Foo Bar"
	),

	/** INHERIT PARAMETERS of previous same control type
	  * 	So in ".mcr" file is not necessary define for each control
	  *
	  * params types are defined in this.inherit_params
	 */
	function _inheritParameters &_Control =
	(
		--format "\n"; print "ScriptFile_Content_v._inheritParameters()"
		--format "_Control: %\n" _Control
		--format "InheritParams	= % \n" InheritParams

		
		if InheritParams[_Control.type] == undefined then
			InheritParams[_Control.type] = Dictionary()
		
		for key in inherit_by_type do 
		(
			inherit_val = if InheritParams[_Control.type] != undefined then InheritParams[_Control.type][key] 
			
			if( param_value = _Control.Params[key] ) != undefined then -- if controls has parameter defined, then save if for next control
				/* SAVE VALUE FOR NEXT CONTROL */ 
				InheritParams[_Control.type][key] = param_value
			
			else if inherit_val != undefined then
				_Control.Params[key] = (inherit_val)
				--case key of
				--(
				--	#OFFSET: _Control.Params[#OFFSET] ) ( [ 0, inherit_val[2] ] ) -- INHERT ONLY Y VALUE OF OFFSET
				--	default: _Control.Params[key] = (inherit_val)
				--)
		)
		
		--for i = 1 to inherit_params.count do
		--(
		--	param_type	= inherit_params[i]
		--	param_value = _Control.Params[param_type]
		--
		--	if( param_value = _Control.Params[param_type] ) != undefined then -- if controls has parameter defined, then save if for next control
		--		inherit_values[i] = param_value
		--
		--	else if inherit_values[i] != undefined then -- inherit param value
		--		_Control.Params[param_type] = (inherit_values[i])
		--)
		--
		--InheritParams[Control] =type) (inherit_values)

		_Control --return
	),

	/** Set events which call macroscript
	  
		ADD AUTORUN EVENT
	  
	 */
	function _setEvent &_Control Macro =
	(
		--format "\n\n"; print "ScriptFile_Content_v._setEvent()"
		--format "%: %\n" _Control.caption _Control
		--format "%: %\n" _Control.caption _Control.Params

		if ( event_type = this._getEventType (_Control) (Macro)) != undefined then
		(
			callback = "(macros.run \""+Macro.category+"\" \""+Macro.macro_name+"\")"

			autorun = ( autorun_param = Macro.params[#AUTORUN] ) != undefined and autorun_param == true
			
			_Control.Event event_type callback tooltip:Macro.toolTip autorun:autorun
		)

		_Control --return
	),

	/** Get type of event by occurence of macro in ".mcr" file
	  *
	  * Event types are ordered by arrays in ControlEventBinder.event_types
	  *
	  * @return	#type_of_event
	 */
	function _getEventType _Control Macro =
	(
		--print "ScriptFile_Content_v._getEventType()"
		--format "event_type	= % \n" (Macro.getParam #event)

		if (event_type = Macro.params[#event]) == undefined then
			event_type = this.EventTypes.getNextEvent(_Control.type)(_Control.Events.count +1)

		event_type --return
	),

	/** Is maxscript file
	 */
	function isMaxscriptFile =
	(
		 getFilenameType _path == ".ms" --return
	),

	/** Is maxscript file
	 */
	function isMacrosriptFile =
	(
		 getFilenameType _path == ".mcr" --return
	),

	/** Has macro scripts
	 */
	function hasMacroScripts =
	(
		MacroScripts.count > 0 --return
	),

	--/** If filename starts with underscore "_"
	--  * @return	boolean
	-- */
	--function hasGroupbox =
	--(
	--	( dotNetClass "System.Text.RegularExpressions.Regex" ).isMatch ( getFilenameFile file ) "^_" == false --return
	--),


	/** Set rollout filename by folder filename E.g.: "Rollout-1" >> "Rollout 1"
	 */
	function _setName =
	(
		filename = getFilenameFile _path
	),

	on create do
	(
		--format "\n"; print "ScriptFile_v.onCreate()"

		this._setName()
		--format "\n"
		--print ("ScriptFile_v.onCreate " + _path )

		this.loadAndParseMacroscriptFile()
	)
)



