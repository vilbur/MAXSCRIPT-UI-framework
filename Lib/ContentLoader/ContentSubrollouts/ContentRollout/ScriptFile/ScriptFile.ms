filein( getFilenamePath(getSourceFileName()) + "/MacroScriptFileParser/MacroScriptFileParser.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ContentControlCreator/ContentControlCreator.ms" )
/** Process ".ms" & ".mcr" file
  * 1) Get macroscripts from '.mcr' files
  * 2) Filein '.ms' files
  *
  * @property	string	file	Path to file
  *
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

	/** File
	 */
	function loadMacroscriptFile =
	(
		--print ("------------\nScriptFile.loadMacroscriptFile file:\n"+ (path)+"\n")
		if ( this.isMacrosriptFile() ) then
			MacroScripts = (MacroScriptFileParser_v path:path).MacroScripts
	),
	
	/** Insert controls to ui
	 */
	function addToUi _Rollout =
	(	
		--print("ScriptFile_Content_v.addToUi() " +_Rollout.id)
		name	= if( name == undefined )then "" else "";
		
		if( this.isMacrosriptFile() ) then
		(
			_Controls	= _Rollout.Controls group:(this._getGroupboxName())
			--format "_Controls	= % \n" _Controls
			--format "MacroScripts = % \n" MacroScripts
			for m = 1 to MacroScripts.count do
				ContentControlCreator_v Macro:MacroScripts[m] ControlBox:_Controls
		)
		else
		(
			--format "!!! ScriptFile_Content_v.loadMacroscriptFile filein % \n" path
			filein path
		)
	),
	
	--/** Add groupbox
	-- */
	--function addGroupbox _Rollout =
	--(
	--	_Rollout.controls groupbox:( this._getGroupboxName() ) -- get new container for controls
	--),

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
	function _getGroupboxName =
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
