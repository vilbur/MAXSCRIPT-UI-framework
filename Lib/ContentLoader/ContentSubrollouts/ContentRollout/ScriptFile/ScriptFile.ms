filein( getFilenamePath(getSourceFileName()) + "/MacroScript/MacroScript.ms" )
filein( getFilenamePath(getSourceFileName()) + "/MacroScriptFileParser/MacroScriptFileParser.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ContentControlCreator/ContentControlCreator.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../../../../Menus/QuadMenu/QuadMenu.ms" ) -- for adding macroscripts to menus

/*
		TODO:

		RENAME THIS TO contentCotnrolCreator

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
	path,

	/* private properties */
	filename, -- filename of ".mcr" file
	MacroScripts	= #(),

	/* Dependency */
	_Controls,
	ControlEventBinder,
	QuadMenu,

	/* Store */
	InheritParams = List_v(),
	inherit_params	= #( #width, #height, #across ),

	/** Load controls from .mcr file
	 */
	function loadMacroscriptFile =
	(
		--print ("------------\nScriptFile.loadMacroscriptFile file:\n"+ (path)+"\n")
		if ( this.isMacrosriptFile() ) then
		(
			filein path

			MacroScripts = (MacroScriptFileParser_v path:path).MacroScripts
		)

	),

	/** Create controls from ".mcr" file to ui
	 */
	function addToUi &_Rollout =
	(
		--print "!!!!!!!!!!!!!!!!!!!!!!!!"
		--print("ScriptFile_Content_v.addToUi() " +_Rollout.id)
		--format "filename	= % \n" filename
		--filename	= if( filename == undefined ) then "" else ""; -- ????????????

		if( this.isMacrosriptFile() and MacroScripts.count > 0 ) then
			this._createControls (_Rollout)

		_Rollout --return
	),

	/** _create controls
	 */
	function _createControls _Rollout =
	(
		--format "\n"; print("ScriptFile_Content_v._createControls()" )
		_Controls	= _Rollout.Controls	group:(this._getGroupName())
		ControlEventBinder	= ControlEventBinder_v 	_Rollout:_Rollout

		for i = 1 to MacroScripts.count do
			this._createControlfromMacro (MacroScripts[i])
	),

	/** Create control from macro
	 */
	function _createControlfromMacro Macro =
	(
		--format "\n"; print "ScriptFile_Content_v.createControlfromMacro()"
		--format "Macro	= % \n" Macro
		--macro_type   = Macro.getControlType()
		macro_params = Macro.getParamsArray()
		--format "macro_params	= % \n" macro_params

		_Control = _Controls.Control (Macro.getControlType()) Macro.buttontext params:(Macro.getParamsArray()) add_to_controls:false
		--format "_Control.id	= % \n" _Control.id

		this._addToQuadMenu (_Control)(Macro)

		if(_Control_Exist = _Controls.get(_Control.id)) != undefined then
			_Control = _Control_Exist -- update existing control

		else
			this.inheritParameters (_Control)

		this._setEventCallMacro (_Control) (Macro)

		if( _Control_Exist == undefined ) then
			_Controls.add _Control
	),

	/** Add to quad menu or menu
	 */
	function _addToQuadMenu _Control Macro =
	(
		--format "\n\n"; print "ScriptFile_Content_v.addToQuadMenu()"
		--format "Macro.macro_name	= % \n" Macro.macro_name
		quad_name	= _Control.Params.getVal #quad
		menu_name	= _Control.Params.getVal #menu
		title	= _Control.Params.getVal #title
		index	= _Control.Params.getVal #index

		if title == undefined then
			title = Macro.buttontext

		if quad_name != undefined then /* QUAD MENU */
		(
			quad_name_split	= filterString quad_name "."

			quad_index = quad_name_split[2]

			if quad_index == undefined then
				quad_index = 1

			(QuadMenu_v(quad_name_split[1])).Quads[quad_index as integer ].addItem (Macro.category)(Macro.macro_name) title:title index:index
		)
		else if menu_name != undefined then /* MENU */
			(Menu_v (menu_name)).addItem (Macro.category) (Macro.macro_name) title:title index:index

	),


	/** Inherit parameters of previous same control type
	  * 	So in ".mcr" file is not necessary define for each control
	  *
	  * params types are defined in this.inherit_params
	 */
	function inheritParameters &_Control =
	(
		--format "\n"; print "ScriptFile_Content_v.inheritParameters()"
		--format "InheritParams	= % \n" InheritParams

		inherit_values	= if (values_exists = InheritParams.getVal(_Control.type)) != undefined then values_exists else #()

		for i = 1 to inherit_params.count do
		(
			param_type	= inherit_params[i]
			param_value = _Control.Params.getVal (param_type)

			if( param_value = _Control.Params.getVal (param_type) ) != undefined then -- if controls has parameter defined, then save if for next control
				inherit_values[i] = param_value

			else if inherit_values[i] != undefined then -- inherit param value
				_Control.Params.setVal (param_type) (inherit_values[i])
		)

		InheritParams.setVal(_Control.type) (inherit_values)

		_Control --return
	),

	/** Set events which call macro
	 */
	function _setEventCallMacro &_Control Macro =
	(
		--format "\n"; print "ScriptFile_Content_v._setEventCallMacro()"
		event_type = this._getEventType (_Control) (Macro)
		--format "event_type	= % \n" event_type
		if( event_type != undefined ) then
		(
			callback = "(macros.run \""+Macro.category+"\" \""+Macro.macro_name+"\")"

			_Control.Event event_type callback tooltip:Macro.toolTip
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

		if( (event_type = Macro.getParam #event) == undefined ) then
			event_type = (ControlEventBinder.EventTypes.getEventTypesOfControl (_Control.type))[ _Control.Events.list.count+1] -- get next event type in list

		--if( event_type != undefined ) then
			--event_type = event_type as filename --return

		event_type --return
	),

	/** Is maxscript file
	 */
	function isMaxscriptFile =
	(
		 getFilenameType path == ".ms" --return
	),

	/** Is maxscript file
	 */
	function isMacrosriptFile =
	(
		 getFilenameType path == ".mcr" --return
	),

	/** Has macro scripts
	 */
	function hasMacroScripts =
	(
		MacroScripts.count > 0 --return
	),


	/** Get filename of groupbox by file filename
	  *
	  *  Remove numbers, empty space and characters like "-_" from start of string E.G.: "1_Filename" >> "Filename"
	  *
	  * @return	string	Name of groupbox
	 */
	function _getGroupName =
	(
		( dotNetObject "System.Text.RegularExpressions.Regex" @"^\d*\s*_-*" ).Replace ( trimLeft ( trimRight (getFilenameFile path) "_ " )  "_ " ) " "
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
		filename = getFilenameFile path
	),

	on create do
	(
		this._setName()
		--format "\n"
		--print ("ScriptFile_v.onCreate " + path )

		this.loadMacroscriptFile()
	)
)
