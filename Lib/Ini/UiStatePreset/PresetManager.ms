filein( getFilenamePath(getSourceFileName()) + "/UiStateSaver/UiStateSaver.ms" )	--"./UiStateSaver/UiStateSaver.ms"
filein( getFilenamePath(getSourceFileName()) + "/UiStateLoader/UiStateLoader.ms" )	--"./UiStateLoader/UiStateLoader.ms"

filein( getFilenamePath(getSourceFileName()) + "/PresetManagerMenu/PresetManagerMenu.ms" )	--"./PresetManagerMenu/PresetManagerMenu.ms"

/** Ui state preset
 */
struct PresetManager_v
(
	/* construct */
	ini_file,

	/* required */
	/* properties */
	
	
	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Save
	  
	   @param string|name|RolloutClass _Rollout which preset is saved
	 */
	function save _Rollout =
	(
		--format "\n"; print "PresetManager_v.save()"
		--format "ini_file: %\n" ini_file
		_Rollout = this._getRollout( _Rollout )
	
		if ( ini_file = _Rollout.ini ) != undefined then
		(
			UiStateSaver = UiStateSaver_v ini_file
				
			UiStateSaver.saveControlsAndSubrollouts (_Rollout)
		)
	
	),
	
	/** Load
	 */
	function load _Rollout =
	(
		--format "\n"; print "PresetManager_v.load()"
		_Rollout = this._getRollout( _Rollout )
		
		if ( ini_file = _Rollout.ini ) != undefined then
		(
			UiStateLoader = UiStateLoader_v ini_file
			
			UiStateLoader.loadControlsAndSubrollouts (_Rollout)
		)
	),
	
	/** Open ini file in Notepad++
	 */
	function open =
	(
		--format "\n"; print "Ini_v.open()"
		--ShellLaunch  "Notepad++" ("\""+_path+"\"")
		DOSCommand ("\""+ini_file+"\"")
	),
	
	
	--/*------------------------------------------------------------------------------
	--	PRESET MENU
	--	
	--	Get preset names from ini filenames
	--	
	--	Save\Load menus for each preset
	----------------------------------------------------------------------------------*/
	--
	--/** Get preset menu
	-- */
	--function presetManagerMenu dialog_id ini_file =
	--(
	--	--format "\n"; print ".presetManagerMenu()"
	--	function getFileNameSuffixes file_path delimeter:"-" =
	--	(
	--		dir = getFilenamePath file_path
	--		baseName = getFilenameFile file_path
	--		extension = getFilenameType file_path
	--
	--		-- 3. Find all files in that directory starting with the base name
	--		-- We use a wildcard search: baseName + "*" + extension
	--		searchPattern = dir + baseName + delimeter +"*" + extension
	--		all_files = getFiles searchPattern
	--		
	--		suffixes = #()
	--		suffixes	= Dictionary #STRING -- KEY:"Preset Name" VALUE:"Preset file path"
	--	
	--		-- 4. Loop through files and extract the "difference"
	--		for f in all_files do
	--		(
	--			currentFileName = getFilenameFile f
	--			
	--			suffix = substring currentFileName (baseName.count + 1 + delimeter.count ) -1
	--
	--			suffixes[suffix] = f
	--		)
	--		
	--		return suffixes
	--	)
	--	
	--	/** Get callback
	--	 */
	--	function getCallback dialog_id ini_file method = "(PresetManager_v(@\""+ini_file +"\"))."+method+"( #"+dialog_id as string +") "
	--	
	--	presets_data = getFileNameSuffixes ini_file
	--
	--
	--	/* DEFINE MAIN MENU */
	--	Menu = RcMenu_v name:"Preset menu"
	--	
	--	--Menu.item ( "Presets Maneger" ) ( "(PresetManager_v(@\""+ini_file +"\"))."+method+"( #"+dialog_id as string +") " ) 
	--	
	--	/* CREATE SUBMENUS */ 
	--	for method in #( "Save", "Load" ) do
	--	(
	--		/* DEFINE MENU */
	--		submenu = Menu.menu (method + " Preset")
	--		
	--		/* DEFAULT PRESETS */
	--		if method == "Load" then
	--			submenu.item ( toUpper(method) + " Default") ( getCallback dialog_id ini_file method ) 
	--		
	--		
	--		/* SEPARATOR */ 
	--		if presets_data.keys.count > 0 then
	--			submenu.separator()
	--		
	--		/* PRESETS */ 
	--		for preset_name in presets_data.keys do
	--			submenu.item ( preset_name ) ( getCallback dialog_id presets_data[preset_name] method ) id:(method + "_"+preset_name)
	--	)
	--	
	--	Menu.create() --return
	--),
	
	
	private
	
	
	/** Get rollout
	 */
	function _getRollout _Rollout =
	(
		--format "\n"; print "PresetManager_v._getRollout()"
		
		if classOf _Rollout != RolloutClass then
			execute( _Rollout as string ) --return
		else
			_Rollout --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "PresetManager.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
