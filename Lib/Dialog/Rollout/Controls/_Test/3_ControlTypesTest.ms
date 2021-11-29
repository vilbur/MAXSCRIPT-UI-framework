clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"


/* [Control types](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
*/ 
control_types = #(
	--#Label,
	--#Button,
	--#Checkbox,
	--#Checkbutton,
	--#Spinner,
	--#Edittext,
	#Listbox,
	#multilistbox,
	#Dropdownlist,
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
	--#Timer
	
	/* DEV */  
	--#Button
	--#browsePath
	#Checkbox
)


controls_with_items = #(
	#Listbox,
	#multilistbox,
	#Dropdownlist,
	#Combobox
)



for control_type in control_types do
(
	params	= if( findItem controls_with_items control_type > 0 ) then #( #items, #("Item 1","Item 2","Item 3") ) else #()

	_Control = _Controls.control control_type ( "Test " + control_type as string ) params:params
)


--for i = 1 to 10 do
--(
--	across = 4
--	
--	if( i > 4  ) then across = 3
--	if( i > 7  ) then across = 2
--	if( i > 9  ) then across = 1
--	
--	_Button1    = _Controls.control #button ( "Button"+ i as string ) params:#(#across, across)
--)


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = 512
--dialog_width  = unsupplied
dialog_height = unsupplied

include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"