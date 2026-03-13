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

ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"

Dialog 	    = Dialog_v title:"Test" ini:ini_file

_Controls   = Dialog.Controls()

--_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red
_Controls.control #CHECKBOX "Checkbox"




/*------------------------------------------------------------------------------
	UI STATE PRESET MANAGER
--------------------------------------------------------------------------------*/

UiStatePresetManager = UiStatePresetManager_v(ini_file)


UiStatePresetManager.dialogCreate()


/** CREATE ROLLOUT 
 *	
 */
--CreateDialog rollout_test menu:(Menu.create())


--copyIniWithSuffix ini_file "Preset A"
--copyIniWithSuffix ini_file "Preset B"


/* DIALOG CREATE */
--Dialog.create()
Dialog.create height:undefined
--Dialog.create menu:(getPresetMenu(#DIALOG_test)(ini_file))


