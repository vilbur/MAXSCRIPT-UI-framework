filein( getFilenamePath(getSourceFileName()) + "/IniSaver/IniSaver.ms" )

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
		if( ini_path == undefined ) then 
			return false
		--print "Ini_v.setIni()"
		--format "ini_path	= % \n" ini_path	
		if( matchPattern ini_path pattern:@"*.ini" ) then
			_path = ini_path
			
		else if( matchPattern ini_path pattern:@"*.ms" or matchPattern ini_path pattern:@"*.mcr" ) then
			_path =  (getFilenamePath(ini_path) + getFilenameFile(ini_path) + ".ini")
		
		else
			messageBox ("Path to ini file is not valid\n\n"+ini_path) title:"Ini file error"
	),
	
	/** Ini save control state
	  * @property	string|name	_section
	  * @property	string|name	key
	  * @property	mixed	value
	 */
	function save _section key value =
	(
		setINISetting _path ( _section as string ) ( key as string ) ( value as string )
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
		if( val_from_ini == "" or val_from_ini == undefined ) then val else this._convertDatatype(val_from_ini) --return
	),

	/** Format string value to valid datatype
	 */
	function _convertDatatype _string =
	(	
		--_string = substituteString _string "\\" "\\\\"

		rx	= dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
		
		is_variable = (rx.match _string "^\s*(\d+|true|false|undefined|unsupplied|\(\s*color\s+\d+\s+\d+\s+\d+\s*\))\s*$" rx_options.IgnoreCase ).success
	
		if not is_variable and (is_string = ( rx.match _string "(^'*[A-Za-z0-1_\s]+'*$)" rx_options.IgnoreCase ).success ) then
		(
			@"" + _string -- IS STRING
		)
		else
		(
			try((execute(_string)))catch(_string) -- IS VARIABLE
		)
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
	
	/** Delete ini file
	 */
	function delete =
	(
		--format "\n"; print "Ini_v.deleteFile()"
		deleteFile _path
	),

	/** Is defined
	 */
	function isDefined =
	(
		--format "\n"; print "Ini_v.isDefined()"
		_path != undefined --return
	),

	/** Is defined
	 */
	function isDefined =
	(
		_path != undefined
	),

	/** Load values on init
	 */
	function loadValuesOnInit =
	(
		--print ( "Ini_v.loadValuesOnInit()" )
		this.isDefined() and load_values_on_init
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