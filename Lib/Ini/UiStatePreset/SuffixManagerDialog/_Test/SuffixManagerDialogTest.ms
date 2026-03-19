clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/Dialog.ms" )	--"./../../../../Dialog/Dialog.ms"

global DIALOG_test

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
        
        new_path = dir_path + "Presets\\" + file_name + "-" + suffix + ext
        
        copyFile src_path new_path
        new_path -- return
    )
)



/** Load prest callback
 */
function testPresetCallback preset_data =
(
	format "\n"; print ".testPresetCallback()"
	
	format "CALLBACK METHOD: %\n" preset_data.keys[1]
	
	if preset_data[#SAVE] != undefined then 
	(
		UiStateSaver = UiStateSaver_v preset_data[#SAVE]
		
		UiStateSaver.saveDialogState DIALOG_test
	)
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

SuffixManagerDialog = SuffixManagerDialog_v(ini_file) 
--SuffixManagerDialog = SuffixManagerDialog_v()

/*------------------------------------------------------------------------------
	CALLBACKS
--------------------------------------------------------------------------------*/

/* DEFAULT CALLLBACK FOR ALL ACTIONS */ 
SuffixManagerDialog.callback "testPresetCallback"

/* SPECFIFIC PER ACTION */ 
--SuffixManagerDialog.callback "testPresetCallback" action:#SAVE -- type: #SAVE | #LOAD | #RENAME | #DELETE | #DEFAUT
--SuffixManagerDialog.callback "testPresetCallback" action:#LOAD -- type: #SAVE | #LOAD | #RENAME | #DELETE | #DEFAUT
--SuffixManagerDialog.callback "testPresetCallback" action:#RENAME -- type: #SAVE | #LOAD | #RENAME | #DELETE | #DEFAUT


/* CREATE DIALOG */ 
SuffixManagerDialog.dialogCreate()


/** CREATE ROLLOUT 
 *	
 */
--CreateDialog rollout_test menu:(Menu.create())




