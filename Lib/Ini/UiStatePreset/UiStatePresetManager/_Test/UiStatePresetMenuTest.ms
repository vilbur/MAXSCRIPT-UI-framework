clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/Dialog.ms" )	--"./../../../../Dialog/Dialog.ms"


/*
Copy file and add suffix before extension.

Example:
"C:\cfg\settings.ini" -> "C:\cfg\settings_backup.ini"
*/
function copyIniWithSuffix src_path suffix =
(
    if doesFileExist src_path then
    (
        dir_path = getFilenamePath src_path
        file_name = getFilenameFile src_path
        ext = getFilenameType src_path
        
        new_path = dir_path + file_name + "-" + suffix + ext
        
        copyFile src_path new_path
        new_path -- return
    )
    else
    (
        undefined -- return
    )
)


/*------------------------------------------------------------------------------
	DIALOG
--------------------------------------------------------------------------------*/

Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())

_Controls   = Dialog.Controls()

--_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red
_Controls.control #CHECKBOX "Checkbox"




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
function getPresetMenu dialog_id ini_file =
(
	--format "\n"; print ".getPresetMenu()"
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
	
	
	Menu.item ( "Presets Maneger" ) ( "(UiStatePreset_v(@\""+ini_file +"\"))."+method+"( #"+dialog_id as string +") " ) 
	
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


/** CREATE ROLLOUT 
 *	
 */
--CreateDialog rollout_test menu:(Menu.create())

ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"

copyIniWithSuffix ini_file "Preset A"
copyIniWithSuffix ini_file "Preset B"


/* DIALOG CREATE */
--Dialog.create()
Dialog.create menu:(getPresetMenu(#DIALOG_test)(ini_file))


