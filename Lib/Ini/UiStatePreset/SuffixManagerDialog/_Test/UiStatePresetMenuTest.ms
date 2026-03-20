clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/Dialog.ms" )	--"./../../../../Dialog/Dialog.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../UiStatePresetMenu/UiStatePresetMenu.ms" )	--"./../../UiStatePresetMenu/UiStatePresetMenu.ms"

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

/** Show rc preset menu
 */
function showRcPresetMenu =
(
	format "\n"; print ".showRcPresetMenu()"
	ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"
		
	uiStatePresetMenu(#DIALOG_test)(ini_file)
)

/*------------------------------------------------------------------------------
	DIALOG
--------------------------------------------------------------------------------*/

Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())

_Controls   = Dialog.Controls()

_Button = _Controls.control #BUTTON "Preset" across:1 width:64

_Button.Event #Pressed ( "showRcPresetMenu()")

--_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red
_Controls.control #CHECKBOX "Checkbox"
			--format "_Button: %\n" _Button
			

/** CREATE ROLLOUT 
 *	
 */
--CreateDialog rollout_test menu:(Menu.create())

ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"

copyIniWithSuffix ini_file "Preset A"
copyIniWithSuffix ini_file "Preset B"


/* DIALOG CREATE */
--Dialog.create()
Dialog.create menu:(uiStatePresetMenu(#DIALOG_test)(ini_file))


