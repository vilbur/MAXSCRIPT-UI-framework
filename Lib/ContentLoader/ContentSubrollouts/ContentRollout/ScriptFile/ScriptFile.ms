filein( getFilenamePath(getSourceFileName()) + "/MacroScript/MacroScript.ms" )
filein( getFilenamePath(getSourceFileName()) + "/MacroScriptFileParser/MacroScriptFileParser.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/ContentControlCreator/ContentControlCreator.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../../../../Menus/QuadMenu/QuadMenu.ms" )

/** Process ".ms" & ".mcr" files
  *
  * Every ".mcr" file creates its own ControlsBox
  *
  * 1) Get all macroscripts from single '.mcr' file
  * 2) Create by macroscripts
  * 3) Filein ".mcr" files
  * 
  * 
  * @property	string	file	Path to file
  *
  *
  
  RENAME THIS TO contentCotnrolCreator
  
  */
struct ScriptFile_Content_v
(
	/* public properties */
	path,

	/* private properties */
	filename, -- filename of ".mcr" file
	MacroScripts	= #(),

	
	_Controls,
	ControlEventBinder,
	QuadMenu,
	
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
		macro_type = Macro.getType()
		macro_params = Macro.getParamsArray()
		format "macro_type	= % \n" macro_type
		format "macro_params	= % \n" macro_params
		
		_Control = _Controls.control (Macro.getType()) Macro.buttontext params:(Macro.getParamsArray())  add_to_controls:false
		--format "_Control.id	= % \n" _Control.id
		
		--this._addToQuadMenu (_Control)(Macro)
		
		
		if( (_Control_Exist = _Controls.get(_Control.id)) != undefined ) then
			_Control = _Control_Exist -- update existing control
		
		--format "_Control_Exist	= % \n" _Control_Exist			
		this._setEventCallMacro (_Control) (Macro)
		
		if( _Control_Exist == undefined ) then
			_Controls.add _Control
	),
	
	/** Add to quad menu
	 */
	function _addToQuadMenu _Control Macro =
	(
		if( ( quad_name = _Control.Params.getVal #quad ) != undefined ) then
		(
			format "\n"; print "ScriptFile_Content_v.addToQuadMenu()"
			format "Macro	= % \n" Macro
			--format "filename	= % \n" filename
			format "quad_name	= % \n" quad_name
			--format "quad_name	= % \n" (classOf quad_name)
			
			quad_name_split	= filterString quad_name "."
			format "quad_name_split	= % \n" quad_name_split
			
			QuadMenu = QuadMenu_v(quad_name_split[1])
			
			quad_index = quad_name_split[2] as integer
			--menu_name = if matchPattern filename pattern:"_*" then filename else "_"+ filename -- REMOVE THIS LINE
			
			--QuadMenu.Quads[quad_index].addItem (Macro.macro_name)(Macro.category) title:Macro.buttontext
			QuadMenu.Quads[quad_index].addItem (Macro.category)(Macro.macro_name)
		)
		else if( ( menu_name = _Control.Params.getVal #menu ) != undefined ) then
		(
			format "\n"; print "ScriptFile_Content_v.addToQuadMenu()"
			format "Macro	= % \n" Macro
			format "menu_name	= % \n" menu_name
			
			Menu 	= Menu_v (menu_name)

			Menu.addItem (Macro.category) (Macro.macro_name)
		)
	),
	
	/** Set events which call macro
	 */
	function _setEventCallMacro &_Control Macro =
	(
		--format "\n"; print "ScriptFile_Content_v._setEventCallMacro()"
		event_type = this._getEventType (_Control) (Macro)
		
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
		if( (event_type = Macro.getParam "event") == undefined ) then
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
