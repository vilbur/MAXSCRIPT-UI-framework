/*------------------------------------------------------------------------------
	PRESET MENU
	
	Get preset names from ini filenames
	
	Save\Load menus for each preset
	
	
	
	PRESET MANAGER
	
	input: preset names
	
	return
	
	
--------------------------------------------------------------------------------*/

/** Get preset menu
 */
function uiStatePresetMenu dialog_id ini_file =
(
	--format "\n"; print ".uiStatePresetMenu()"
	function getFileNameSuffixes file_path delimeter:"-" =
	(
		dir = getFilenamePath file_path
		baseName = getFilenameFile file_path
		extension = getFilenameType file_path

		-- 3. Find all files in that directory starting with the base name
		-- We use a wildcard search: baseName + "*" + extension
		searchPattern = dir + baseName + delimeter +"*" + extension
		all_files = getFiles searchPattern
		
		suffixes = #()
		suffixes	= Dictionary #STRING -- KEY:"Preset Name" VALUE:"Preset file path"
	
		-- 4. Loop through files and extract the "difference"
		for f in all_files do
		(
			currentFileName = getFilenameFile f
			
			suffix = substring currentFileName (baseName.count + 1 + delimeter.count ) -1

			suffixes[suffix] = f
		)
		
		return suffixes
	)
	
	/** Get callback
	 */
	function getCallback dialog_id ini_file method = "(UiStatePreset_v(@\""+ini_file +"\"))."+method+"( #"+dialog_id as string +") "
	
	presets_data = getFileNameSuffixes ini_file


	/* DEFINE MAIN MENU */
	Menu = RcMenu_v name:"Preset menu"
	
	
	--Menu.item ( "Presets Maneger" ) ( "(UiStatePreset_v(@\""+ini_file +"\"))."+method+"( #"+dialog_id as string +") " ) 
	
	/* CREATE SUBMENUS */ 
	for method in #( "Save", "Load" ) do
	(
		/* DEFINE MENU */
		submenu = Menu.menu (method + " Preset")
		
		/* DEFAULT PRESETS */
		if method == "Load" then
			submenu.item ( toUpper(method) + " Default") ( getCallback dialog_id ini_file method ) 
		
		
		/* SEPARATOR */ 
		if presets_data.keys.count > 0 then
			submenu.separator()
		
		/* PRESETS */ 
		for preset_name in presets_data.keys do
			submenu.item ( preset_name ) ( getCallback dialog_id presets_data[preset_name] method ) id:(method + "_"+preset_name)
	)
	
	Menu.create() --return
)