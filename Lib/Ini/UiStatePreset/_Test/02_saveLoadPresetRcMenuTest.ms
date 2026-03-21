clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/Dialog.ms" )	--"./../../../Dialog/Dialog.ms"


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
		
	presetManagerMenu(#DIALOG_test)(ini_file)
)

/*------------------------------------------------------------------------------
	CONFIG
--------------------------------------------------------------------------------*/
ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"


/*------------------------------------------------------------------------------
	DIALOG
--------------------------------------------------------------------------------*/

Dialog = Dialog_v title:"Test" ini:(getSourceFileName())
--Dialog = Dialog_v title:"Test"

--Dialog.addLocal #INI ini_file

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


copyIniWithSuffix ini_file "Preset A"
copyIniWithSuffix ini_file "Preset B"


/* DIALOG CREATE */
--Dialog.create()
Dialog.create menu:(presetManagerMenu(#DIALOG_test)(ini_file))


format "DIALOG_test.ini: %\n" DIALOG_test.ini
