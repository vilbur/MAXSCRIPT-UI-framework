clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/Dialog.ms" )	--"./../../../../Dialog/Dialog.ms"

filein( getFilenamePath(getSourceFileName()) + "/../PresetManagerMenu.ms" )	--"./../PresetManagerMenu.ms"


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
	format "EventFired: %\n" EventFired
	--ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"
		
	--presetManagerMenu(#DIALOG_test)(ini_file)
)

/*------------------------------------------------------------------------------
	CONFIG
--------------------------------------------------------------------------------*/
--ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"


/*------------------------------------------------------------------------------
	DIALOG
--------------------------------------------------------------------------------*/

--Dialog = Dialog_v title:"Test" ini:(getSourceFileName())
Dialog = Dialog_v title:"Test" ini:( getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini" )
--Dialog = Dialog_v title:"Test"

--Dialog.addLocal #INI ini_file

_Controls   = Dialog.Controls()

_Button = _Controls.control #BUTTON "Preset" across:1 width:64

--_Button.Event #Pressed ( "showRcPresetMenu()")
_Button.Event #Pressed ( "(UiPresetMenu_v()).create()")

--_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red
_Controls.control #CHECKBOX "Checkbox"
			--format "_Button: %\n" _Button
			

--_Button.Event #Pressed ( "(UiPresetMenu_v()).create()")

--copyIniWithSuffix ini_file "Preset A"
--copyIniWithSuffix ini_file "Preset B"


/* DIALOG CREATE */
--Dialog.create()
--Dialog.create menu:(UiPresetMenu_v(Dialog))

/* TEST A: ISLATED TEST */ 
--presetManagerMenu dialog_id:#DIALOG_test

/* TEST B: Menu in dialog */ 
--Dialog.create menu:(presetManagerMenu dialog_id:#DIALOG_test)


--format "DIALOG_test.ini: %\n" DIALOG_test.ini




/* DEFINE MAIN MENU */
MenuWithSubmenu = RcMenu_v name:"TestMenu"

/* DEFINE MENU */
menu_1	= MenuWithSubmenu.menu "Menu 1"
--menu_2	= Menu.menu "Menu 2"
--
--
--/** MENU ITEMS 
---- */
--menu_1.item "Item 1" "messagebox \"Item 1\"" 
--menu_1.item "Exit" "try( execute(\"DestroyDialog rollout_test\") )catch()" 
--
--
--
--/* DEFINE SUBMENU */
submenu = menu_1.menu ((UiPresetMenu_v()).create show:false )
--submenu.item "Submenu Item 1"  "messagebox \"Submenu Item 1\""
--
--
--/** MENU ITEMS 2
-- */
--menu_2.item "Item 2" "messagebox \"Item 2\""
--menu_2.separator()
--menu_2.item "Item 3" "messagebox \"Item 3\""
--



/** CREATE ROLLOUT 
 *	
 */
Dialog.create menu:(MenuWithSubmenu.create())


