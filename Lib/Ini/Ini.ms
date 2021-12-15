/** Save Load ini settings
  *
  *
  * TODO: remove unused properties and methods OR make it work
  *
  */
struct Ini_v
(
	_path,	-- full pah to *.ini file*
	--_dir,	-- dir of *.ini file
	--file,	-- *.ini filename
	--
	--load_values_on_init = true,
	
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
			
		else if( matchPattern ini_path pattern:@"*.ms" ) then
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
		val	= default
		
		val_from_ini = getINISetting _path ( _section	as string ) ( _key as string ) -- return
		--format "\nval_from_ini = % \n" val_from_ini
		if( val_from_ini == "" or val_from_ini == undefined ) then val else this._convertDatatype(val_from_ini) --return
	),

	/** Format string value to valid datatype
	 */
	function _convertDatatype val =
	(		
		if( (for pattern in #( "true", "false", "color*", "[*,*]" ) where matchPattern val pattern:pattern collect pattern).count > 0 ) then 
			execute val

		else if( ( val_as_number = val as number) != undefined ) then 
			val_as_number --return
			
		else
			substituteString val "\\" "\\\\" -- escape string
	),
	
	/** Get path
	 */
	function getPath =
	(
		_path --return
	),
	
	
	
	
	/*------------------------------------------------------------------------------
		DEPRECATED
	--------------------------------------------------------------------------------*/
	
	
	/** Set path to dir which contains *.ini fie
	  * @property	string	_path	path to dir
	 */
	function dir _path =
	(
		--print ( "Ini_v.dir() = " + _path as string )
		_path = this._escapePath _path
		
		this._getSetProp #_dir _path --return
	),

	--/** Set filename of *.ini file
	--  * @property	string	filename	of *.ini file E.G.: "foo.ini" 
	-- */
	--function file filename =
	--(
	--	--print ( "Ini_v.file() = " + filename as string )
	--	this._getSetProp #_file filename --return
	--),

	--/** Get\set ini file path
	--  * @param	string|#get _path	Path to ini file, or #get
	--  *
	--  * @return	string|self path to ini file if _path=#get	
	--  */
	--function path _path =
	--(
	--	--print ("------------\nIni.path() " + _path as string) 
	--	if( _path != #get ) then
	--		_path = this._escapePath _path
	--
	--	this._getSetProp #_path _path --return
	--),

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
		--print("Ini_v.onCreate()")
		this.setIni (_path) -- try set path on construct
	)
)