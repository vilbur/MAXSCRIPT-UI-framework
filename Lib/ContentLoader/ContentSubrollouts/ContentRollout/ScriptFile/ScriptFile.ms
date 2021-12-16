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
	
	/** Create controls from ".mcr" file to ui
	 */
	function addToUi &_Rollout =
	(
		--print "!!!!!!!!!!!!!!!!!!!!!!!!"
		--print("ScriptFile_Content_v.addToUi() " +_Rollout.id)
		name	= if( name == undefined )then "" else "";
		
		if( this.isMacrosriptFile() and MacroScripts.count > 0 ) then
			this._createControls (_Rollout)

		
		_Rollout --return
	),
	
	/** _create controls
	 */
	function _createControls _Rollout =
	(
		_Controls = _Rollout.Controls group:(this._getGroupName())
		--print("ScriptFile_Content_v._createControls()" )
		--format "MacroScripts = % \n" MacroScripts
		for m = 1 to MacroScripts.count do
			_Controls = (ContentControlCreator_v Macro:MacroScripts[m] _Rollout:_Rollout _Controls:_Controls).getControls()
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
