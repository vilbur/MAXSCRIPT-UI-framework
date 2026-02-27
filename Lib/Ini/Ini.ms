filein( getFilenamePath(getSourceFileName()) + "/IniSaver/IniSaver.ms" )	-- "./IniSaver/IniSaver.ms"

/** Save Load ini settings
  *
  *
  * TODO: remove unused properties and methods OR make it work
  *
  */
struct Ini_v
(
	/* required */
	_path,	-- full pah to *.ini file*

	/** Set ini
	 */
	function setIni ini_path =
	(
		--print "Ini.setIni()"
		if( ini_path == undefined ) then
			return false
		--print "Ini_v.setIni()"
		--format "ini_path	= % \n" ini_path
		if( matchPattern ini_path pattern:@"*.ini" ) then
			this._path = ini_path

		else if( matchPattern ini_path pattern:@"*.ms" or matchPattern ini_path pattern:@"*.mcr" ) then
			this._path =  (getFilenamePath(ini_path) + getFilenameFile(ini_path) + ".ini")

		else
			messageBox ("Path to ini file is not valid\n\n"+ini_path) title:"Ini file error"
	),

	/** Ini save control state
	  * @property	string|name	_section
	  * @property	string|name	key
	  * @property	mixed	value
	 */
	function save _section key val =
	(
		string_val = val as string
		
		if classOf val == name then
			string_val = "#" + string_val
		
		setINISetting _path ( _section as string ) ( key as string ) string_val
	),

	/** Ini load control state
	 */
	function load _section _key default:undefined =
	(
		--print "Ini.load()"
		--format "_section	= % \n" _section
		--format "_key	= % \n" _key
		val	= default
		--format "val	= % \n" val
		--format "default	= % \n" default
		--format "classOf default	= % \n" (classOf default)
		val_from_ini = getINISetting _path ( _section	as string ) ( _key as string ) -- return
		--format "\nval_from_ini = % \n" val_from_ini
		if( val_from_ini == "" or val_from_ini == undefined ) then val else this.convertDatatype(val_from_ini) --return
	),

	/** Get keys of section
	  */
	function keys _section =
	(
		--format "\n"; print "Ini_v.keys()"
		if _path == undefined then
			return undefined

		 getINISetting _path ( _section	as string ) --return
	),

	/** Get path
	 */
	function getPath =
	(
		_path --return
	),

	/** Open ini file in Notepad++
	 */
	function open =
	(
		--format "\n"; print "Ini_v.open()"
		ShellLaunch  "Notepad++" ("\""+_path+"\"")
	),

	/** Delete ini entry
	  *
	  */
	function delete _section _key: =
	(
		--format "\n"; print "Ini_v.delete()"
		if _path == undefined then
			return false

		if _key != unsupplied then
			delINISetting  _path ( _section	as string ) ( _key as string )
		else
			delINISetting  _path ( _section	as string )
	),

	/** Delete ini file
	 */
	function deleteIni =
	(
		--format "\n"; print "Ini_v.deleteFile()"
		if _path != undefined then
			deleteFile _path
	),

	/** Is defined
	 */
	function isDefined =
	(
		--format "\n"; print "Ini_v.isDefined()"
		_path != undefined --return
	),

	/** Load values on init
	 */
	function loadValuesOnInit =
	(
		--print ( "Ini_v.loadValuesOnInit()" )
		this.isDefined() and load_values_on_init
	),

	/** Format string value to valid datatype
	 */
	function convertDatatype _string =
	(
		--_string = substituteString _string "\\" "\\\\"
		/** Join array
		 */
		function joinPatterns params_input =
		(
			--format "\n"; print ".joinArray()"
			params_string = ""
	
			for param in params_input do params_string += param + "|"
	
			trimRight params_string "|"
		)
		
		patterns = #(
			"-*\d+.*\d*",	-- integer or float
			"true|false",
			"undefined|unsupplied",
			"red|green|blue|white|black|orange|yellow|brown|gray",
			"\[.*\]",	-- point2, point3
			"\(*color\s+\d+\s+\d+\s+\d+\s*\)*",	-- color E.G.: "color 128 128 128" or "(color 128 128 128)"
			"#[^\s\(\{]+",	-- #name but not array or bitarray
			"#[\(\{].*[\)\}]",	--array or bitarray
			""
		)
		
		RegEx	= dotNetClass "System.Text.RegularExpressions.RegEx"
		RegEx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
		
		is_variable = (RegEx.match _string ("^("+joinPatterns(patterns)+")$") RegEx_options.IgnoreCase ).success
	
		--if is_variable and not (is_string = ( RegEx.match _string "(^'*[A-Za-z0-1_\s]+'*$)" RegEx_options.IgnoreCase ).success ) then
		if is_variable then
		(
			try((execute(_string)))catch(_string) -- IS VARIABLE
		)
		else
		(
			@"" + _string -- IS STRING
		)
	),
	
	private

	/** Combine path
	 */
	function _combinePath =
	(
		if( _path == undefined and _dir != undefined and _file != undefined ) then
			_path = _dir +"\\" + _file
	),

	/** Set default path to ini file
	  *
	  * Default dir:	"#temp\ini-files\" E.G.: ""C:\Users\[USERNAME]\AppData\Local\Autodesk\3dsMax\2016 - 64bit\ENU\temp""
	  * Default file:	"%dialog_id%.ini"
	 */
	function _setDefaultIniFile =
	(
		if( dir #get == undefined ) then
			dir (( pathConfig.GetDir #temp ) + "\ini-files")

		if( file #get == undefined ) then
			file ( (getFilenameFile id) + ".ini" )

		this._combinePath()
	),

	/** Get\set value of property
	  * @param	string|name key	Name  of property E.G.: "foo_key" OR #foo_key
	  * @param	string|#get value	Value of property
	  *
	  * @return	string|self Value or self
	  *
	  * @example this._getSetProp "foo" "bar" -- SET "bar" to property "foo"
	  * @example this._getSetProp #foo  #get  -- GET value of property "foo"
	  *
	  */
	function _getSetProp key value =
	(
		if( value != #get ) then
		(
			setProperty  this ( key as string ) value
			this --return
		) else
			getProperty this ( key as string ) --return
	),


	/** Escape path
	 */
	function _escapePath path_for_escape =
	(
		--if( path_for_escape != #get ) then ( substituteString ( path_for_escape as string ) "\\" "\\\\" ) else path_for_escape  --return
		if( path_for_escape != #get ) then ( pathConfig.normalizePath path_for_escape ) else path_for_escape  --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print("Ini_v.onCreate()")
		--format "_path	= % \n" _path
		this.setIni (_path) -- try set path on construct
	)
)