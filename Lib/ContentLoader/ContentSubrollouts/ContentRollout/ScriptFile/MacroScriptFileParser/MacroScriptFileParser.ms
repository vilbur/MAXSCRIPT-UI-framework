filein( getFilenamePath(getSourceFileName()) + "/MacroScript/MacroScript.ms" )

/** Parese macroscripts in "*.mcr file"
  *
  * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_6E21C768_7256_4500_AB1F_B144F492F055_htm
  * 
  */
struct MacroScriptFileParser_v
(
	__construct = #( #path ),
	/* required */
	path,
	
	file_content = #(),
	
	MacroScripts	= #(),
	MacroScript_last,	-- store currently parsed Macro file

	RegEx	= dotNetClass "System.Text.RegularExpressions.Regex",
	RegEx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions",
			
	/** Parse MacroScripts
	  *
	  * IMPORTANT: Keep EACH PROPERTY on SEPARATE LINE
	  *
	  *	MacroScript <macro_name>
	  *		category:	  ""
	  *		buttontext: ""
	  *		toolTip:	   ""
	  *		icon:	   "#(path, index)"
	  *	(
	  *		messagebox "MacroScript";
	  *	)
	  *
	  */
	function _parseMacros =
	(
		--format ( "MacroScriptParser._parseMacros()\n" )
		for line in file_content do
		(
			if( this._lineIsMacroName line ) then
				--format "line = % \n" line
				this._setNewMacroSript (this._getMacroName line)
			else
				this._parseProperties line
		)
		
		this._addLastMacroscript()
	),

	/** _get new macro sript
	 */
	function _setNewMacroSript name =
	(
		this._addLastMacroscript()

		MacroScript_last = MacroScript_Content_v macro_name:name

		MacroScript_last --return
	),
	
	/** _parse macro props
	 */
	function _parseProperties line =
	(
		if( this._lineIsProperty line ) then
			this._parseLine line
			--MacroScript_last.setProp (this._getKeyValuePair line)
	),
	
	/** _parse line
	 */
	function _parseLine line =
	(
		--print "MacroScriptParser._parseLine()"
		key_value = (filterString line ":")
		key       = toLower key_value[1]
		--format "key_value	= % \n" key_value
		setProperty MacroScript_last key (this._joinAndSanitizeValues (deleteItem key_value 1))
		--format "MacroScript_last = % \n" MacroScript_last
	),
	
	/** Find if line start with "MacroScript <macro_name>"
	 */
	function _lineIsMacroName line =
	(
		RegEx.isMatch line "^\s*MacroScript\s+.+" RegEx_options.IgnoreCase == true --return
	),
	
	/** _line is property
	 */
	function _lineIsProperty line =
	(
		RegEx.isMatch line "^\s*(category|buttonText|toolTip|icon|silentErrors|autoUndoEnabled)\s*:\s*" RegEx_options.IgnoreCase == true --return
	),
	/** Get name of macro from line
	  * remove whitespace and tab
	  *
	  * @property	string	line	"MacroScript macro_name"
	  *
	  * @return	string	macro_name
	 */
	function _getMacroName line =
	(
		(filterString line " 	")[2] --return
	),
	
	/** Join and sanitize values
	 */
	function _joinAndSanitizeValues values =
	(
		this._stripQuotes ( this._trimWhiteSpace (this._joinValues values) )
	),
	
	/** Join values
	 */
	function _joinValues values =
	(
		val_join = ""
		
		for val in values do
			val_join += ( trimLeft ( trimRight val ) + ":")
	
		trimRight val_join ":"	
	),
	
	/** Remove leading and trailing white space
	 */
	function _trimWhiteSpace _string =
	(
		trimLeft ( trimRight _string ) --return
	),
	
	/** Strip leading and trailing quotes
	  *
	  * @property	string	_string	quoted string
	  * @return	string	
	 */
	function _stripQuotes _string =
	(
		trimLeft ( trimRight _string "\"" ) "\"" --return
	),
	
	
	/** _add latest parsed macroscript
	 */
	function _addLastMacroscript =
	(
		if( MacroScript_last != undefined ) then
			append MacroScripts MacroScript_last
	),


	/** Get file content
	 */
	function _setFileContent =
	(
		file_opened	= openFile path mode:"r+"
		counter	= 0
		--lines	= #()

		while not eof file_opened do 
		(
			line =  readLine file_opened
			if( line.count > 1 ) then 
				append file_content ( this._trimWhiteSpace(line))
				
			counter += 1
		)

		seek file_opened 0    -- reset position to beginning

		close file_opened -- closes the file

		file_content --return
	),
	
	/*------------------------------------------------------------------------------
		CONSTRUCT
	--------------------------------------------------------------------------------*/
	
	/** Check if properties in __construct are defined when an instance of the struct is created.
	  * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("Undefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	
	on create do
	(
		--format "\n"
		--print ("MacroScriptFileParser_v.onCreate ")
		this._checkConstctructProperties()
		
		this._setFileContent()
		--format "file_content = % \n" file_content
		this._parseMacros()
	)
)