clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/Dialog.ms" )	--"./../../../../Dialog/Dialog.ms"





/** Load prest callback
 */
function loadPresetCallback preset_data =
(
	format "\n"; print ".loadPresetCallback()"
	format "PRESET_DATA: %\n" preset_data
)


/*------------------------------------------------------------------------------
	DIALOG
--------------------------------------------------------------------------------*/


ini_file = getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini"
--
--Dialog 	    = Dialog_v title:"Test" ini:ini_file
--
--_Controls   = Dialog.Controls()
--
----_Controls.control #CHECKBUTTON "checkbutton" highlightColor:red
--_Controls.control #CHECKBOX "Checkbox"
--



/*------------------------------------------------------------------------------
	UI STATE PRESET MANAGER
--------------------------------------------------------------------------------*/

UiStatePresetManager = UiStatePresetManager_v(ini_file) 
--UiStatePresetManager = UiStatePresetManager_v()

--UiStatePresetManager.callback #loadPreset "loadPresetCallback"

UiStatePresetManager.dialogCreate()


/** CREATE ROLLOUT 
 *	
 */
--CreateDialog rollout_test menu:(Menu.create())


--copyIniWithSuffix ini_file "Preset A"
--copyIniWithSuffix ini_file "Preset B"


/* DIALOG CREATE */
--Dialog.create()
--Dialog.create height:undefined
--Dialog.create menu:(getPresetMenu(#DIALOG_test)(ini_file))


