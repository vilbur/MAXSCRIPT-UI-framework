clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"

/**  

	1) Global defaults for all controls
	2) Global default per control type
	3) User Defined param

*/
control_types = #(
	--#Label,
	#Button,
	#Checkbox,
	#Checkbutton,
	--#Spinner,
	--#Edittext,
	--#Listbox,
	--#multilistbox,
	--#Dropdownlist,
	----#Combobox,
	----#GroupBox,
	----#Angle,
	----#Bitmap,
	----#Colorpicker,
	----#hyperlink,
	----#imgTag,
	----#Mapbutton,
	----#Materialbutton,
	----#Pickbutton,
	----#ProgressBar,
	----#Slider,
	----#Curve,-- DOES NOT WORK YET
	----#popupMenu,-- DOES NOT WORK YET
	----#Radiobuttons,-- DOES NOT WORK YET
	#Timer
	
	/* DEV */  
	--#Button
	--#browsePath
	--#Checkbox
)

--_Controls.Default #across 4 type:#button 
--_Controls.Default #across 2 type:#checkbox 



for control_type in control_types do
(
	
	for i = 1 to 4 do
		_Control = _Controls.control control_type ( "Test " + i as string )
	
	
)




/** Create dialog from _Rollout
  */
dialog_width = 320
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
