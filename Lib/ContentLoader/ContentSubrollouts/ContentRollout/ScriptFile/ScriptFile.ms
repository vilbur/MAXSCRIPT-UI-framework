filein( getFilenamePath(getSourceFileName()) + "/MacroScriptFileParser/MacroScriptFileParser.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ContentControlCreator/ContentControlCreator.ms" )


/** Process ".ms" & ".mcr" file
  *
  * Every ".ms" file creates its own ControlsBox
  *
  * 1) Get all macroscripts from single '.mcr' file
  * 2) Filein '.ms' files
  *
  * @property	string	file	Path to file
  *
  *
  */
struct ScriptFile_Content_v
(
	/* public properties */
	path,

	/* private properties */
	name,
	MacroScripts	= #(),

	
	_Controls,
	ControlEventBinder,
	
	/** File
	 */
	function loadMacroscriptFile =
	(
		--print ("------------\nScriptFile.loadMacroscriptFile file:\n"+ (path)+"\n")
		if ( this.isMacrosriptFile() ) then
			MacroScripts = (MacroScriptFileParser_v path:path).MacroScripts
	),
	
	/** Create controls from ".mcr" file to ui
	 */
	function addToUi &_Rollout =
	(
		--print "!!!!!!!!!!!!!!!!!!!!!!!!"
		--print("ScriptFile_Content_v.addToUi() " +_Rollout.id)
		name	= if( name == undefined ) then "" else ""; -- ????????????
		
		if( this.isMacrosriptFile() and MacroScripts.count > 0 ) then
			this._createControls (_Rollout)

		
		_Rollout --return
	),
	
	/** _create controls
	 */
	function _createControls _Rollout =
	(
		format "\n"; print("ScriptFile_Content_v._createControls()" )
		_Controls	= _Rollout.Controls	group:(this._getGroupName())
		ControlEventBinder	= ControlEventBinder_v 	_Rollout:_Rollout
		
		for i = 1 to MacroScripts.count do
			this._createControlfromMacro (MacroScripts[i])
	),
	
	/** Create controlfrom macro
	 */
	function _createControlfromMacro Macro =
	(
		format "\n"; print "ScriptFile_Content_v.createControlfromMacro()"
		--format "Macro	= % \n" Macro
		_Control = _Controls.control (Macro.getType()) Macro.buttontext params:(Macro.getParamsArray())  add_to_controls:false
		
		if( (_Control_Exist = _Controls.get(_Control.id)) != undefined ) then
			_Control = _Control_Exist -- update existing control
					
		this._setEventCallMacro (_Control) (Macro)
		
		if( _Control_Exist == undefined ) then
			_Controls.add _Control
	),
	
	/** Set events which call macro
	 */
	function _setEventCallMacro &_Control Macro =
	(
		format "\n"; print "ScriptFile_Content_v._setEventCallMacro()"
		format "Macro.toolTip	= % \n" Macro.toolTip
		
		event_type = this._getEventType (_Control) (Macro)
		
		callback = "(macros.run \""+Macro.category+"\" \""+Macro.macro_name+"\")"

		_Control.Event event_type callback tooltip:Macro.toolTip
		
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
		if( (event_type = Macro.getParam "event") == undefined ) then
			event_type = (ControlEventBinder.EventTypes.getEventTypesOfControl (_Control.type))[ _Control.Events.list.count+1] -- get next event type in list

		--if( event_type != undefined ) then
			--event_type = event_type as name --return
			
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


	/** Get name of groupbox by file name
	  * 
	  * @return	string	Name of groupbox, If filename starts with underscore "_", then return undefined and controls are placed to new controls box without groupbox
	 */
	function _getGroupName =
	(
		--if ( this.hasGroupbox() ) then
			( dotNetObject "System.Text.RegularExpressions.Regex" @"[_]+" ).Replace ( trimLeft ( trimRight (getFilenameFile path) "_" )  "_" ) " "
		--else
		--	undefined
	),

	--/** If filename starts with underscore "_"
	--  * @return	boolean	
	-- */
	--function hasGroupbox =
	--(
	--	( dotNetClass "System.Text.RegularExpressions.Regex" ).isMatch ( getFilenameFile file ) "^_" == false --return 
	--),


	/** Set rollout name by folder name E.g.: "Rollout-1" >> "Rollout 1"
	 */
	function _setName =
	(
		name = getFilenameFile path
	),
	
	on create do
	(
		this._setName()
		--format "\n"
		--print ("ScriptFile_v.onCreate " + path )

		this.loadMacroscriptFile()
	)
)
