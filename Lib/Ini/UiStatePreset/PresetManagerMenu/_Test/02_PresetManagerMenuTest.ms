clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/Dialog.ms" )	--"./../../../../Dialog/Dialog.ms"

filein( getFilenamePath(getSourceFileName()) + "/../PresetManagerMenu.ms" )	--"./../PresetManagerMenu.ms"

/*------------------------------------------------------------------------------
	HELPERS
--------------------------------------------------------------------------------*/
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
	CONFIG
--------------------------------------------------------------------------------*/
--ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"

--copyIniWithSuffix ini_file "Preset A"
--copyIniWithSuffix ini_file "Preset B"



/*------------------------------------------------------------------------------
	
	DEFINE DIALOG
	
--------------------------------------------------------------------------------*/

--Dialog = Dialog_v title:"Test" ini:(getSourceFileName())
Dialog = Dialog_v title:"Test" ini:( getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini" )
--Dialog = Dialog_v title:"Test"

--Dialog.addLocal #INI ini_file

_Controls   = Dialog.Controls()

_Button = _Controls.control #BUTTON "Preset" across:1 width:64

/*==============================================================================
  
	OPEN AS POPUP ON CALLBACK OF ANY CONTROL WHICH FIRES EventFired
	
================================================================================*/
_Button.Event #Pressed ( "(UiPresetMenu_v()).create()")


--_Controls.control #CHECKBOX "Checkbox"


/*==============================================================================

	OPEN AS ROLLOUT MENU

================================================================================*/
----Dialog.create()
Dialog.create menu:(UiPresetMenu_v(Dialog))

/* TEST A: ISLATED TEST */ 
--presetManagerMenu dialog_id:#DIALOG_test

/* TEST B: Menu in dialog */ 
--Dialog.create menu:(presetManagerMenu dialog_id:#DIALOG_test)


--format "DIALOG_test.ini: %\n" DIALOG_test.ini


/*==============================================================================
	
	ADD AS SUBMENU
	
================================================================================*/

/* DEFINE RC MAIN MENU */
SubMenuTest = RcMenu_v name:"TestMenu"

/* DEFINE MENU */
menu_1	= SubMenuTest.menu "Custom Menu 1"

submenu = (UiPresetMenu_v()).create Menu:false 



/** CREATE ROLLOUT 
 *	
 */
Dialog.create menu:(SubMenuTest.create())


