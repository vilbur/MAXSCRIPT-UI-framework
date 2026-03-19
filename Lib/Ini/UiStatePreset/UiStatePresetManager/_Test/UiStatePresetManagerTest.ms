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
        
        new_path = dir_path + "INI-Presets\\" + file_name + "-" + suffix + ext
        
        copyFile src_path new_path
        new_path -- return
    )
)

/** Default dialog callback
 */
function defaultDialogCallback =
(
	--format "\n"; print ".defaultDialogCallback()"
)

/** Load prest callback
 */
function testPresetCallback preset_data =
(
	format "\n"; print ".testPresetCallback()"
	format "PRESET_DATA: %\n" preset_data
)


/*------------------------------------------------------------------------------
	DIALOG
--------------------------------------------------------------------------------*/


--ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"
ini_file = getFilenamePath(getSourceFileName()) + "test.ini"

Dialog 	    = Dialog_v title:"Test" ini:ini_file

_Controls   = Dialog.Controls()

----_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red
_Controls.control #CHECKBOX "Checkbox"

format "INI_FILE: %\n" ini_file

/* DIALOG CREATE */
Dialog.create()
--Dialog.create height:undefined
--Dialog.create menu:(getPresetMenu(#DIALOG_test)(ini_file))



/*------------------------------------------------------------------------------
	DEV -- create mockup preset files
------------------------------------------------------------------------------*/
copyIniWithSuffix ini_file "Preset A"
copyIniWithSuffix ini_file "Preset B"

/*------------------------------------------------------------------------------
	UI STATE PRESET MANAGER
--------------------------------------------------------------------------------*/

UiStatePresetManager = UiStatePresetManager_v(ini_file) 
--UiStatePresetManager = UiStatePresetManager_v()

/*------------------------------------------------------------------------------
	CALLBACKS
--------------------------------------------------------------------------------*/

/* DEFAULT CALLLBACK FOR ALL ACTIONS */ 
UiStatePresetManager.callback "defaultDialogCallback"

/* SPECFIFIC PER ACTION */ 
UiStatePresetManager.callback "testPresetCallback" action:#LOAD -- type: #SAVE | #LOAD | #RENAME | #DELETE | #DEFAUT
UiStatePresetManager.callback "testPresetCallback" action:#RENAME -- type: #SAVE | #LOAD | #RENAME | #DELETE | #DEFAUT

/* CREATE DIALOG */ 
UiStatePresetManager.dialogCreate()


/** CREATE ROLLOUT 
 *	
 */
--CreateDialog rollout_test menu:(Menu.create())




