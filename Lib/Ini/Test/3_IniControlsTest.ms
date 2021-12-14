clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/../RolloutCreator/RolloutCreator.ms" )

--filein( getFilenamePath(getSourceFileName()) + "/../../RolloutCreator/ControlCreator/ControlEventBinder/ControlEventBinder.ms" )

ControlEvents = ControlEventBinder_v()

/* ONLY THIS TYPES OF CONTROLS WILL BE TESTED
  * 
  * CURRENTLY SUPPORTED CONTROLS are in control_types array in  "../ControlEvents.ms"
  * 
  *  [HELP Control types](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
  *
*/ 
control_types_for_test = #(
	
	--#Label,
	--#Button,
	--#Checkbox,
	--#Checkbutton,
	--#Spinner,
	--#Edittext,
	--#Listbox,
	--#multilistbox,
	--#Dropdownlist,
	--------#Combobox,
	--------#GroupBox,
	--------#Angle,
	--------#Bitmap,
	--------#Colorpicker,
	--------#hyperlink,
	--------#imgTag,
	--------#Mapbutton,
	--------#Materialbutton,
	--------#Pickbutton,
	--------#ProgressBar,
	--------#Slider,
	--------#Curve,-- DOES NOT WORK YET
	--------#popupMenu,-- DOES NOT WORK YET
	--------#Radiobuttons,-- DOES NOT WORK YET
	--#Timer
	--
	
	/* DEV */ 
	--#Checkbox
	--#Button
	--#Spinner
	--#Edittext

)


/* CUSTOM TYPES */ 
append ControlEvents.control_types	#browsePath
append control_types_for_test	#browsePath

controls_with_items = #(
	#Listbox,
	#multilistbox,
	#Dropdownlist,
	#Combobox
)
  

/** DEFINE UI 
 *	
 */
try( destroyDialog ROLLOUT_test )catch()

_RolloutCreator 	= RolloutCreator_v()
_RolloutCreator.Ini.setIni (getSourceFileName())

_Rollout  = _RolloutCreator.new "Test"
_Controls = _Rollout.Controls()



/** ADD CONTROLS WITH EVENTS
 */
for control_type in ControlEvents.control_types where findItem control_types_for_test control_type > 0 do
(
	params	= if( findItem controls_with_items control_type > 0 ) then #( #items, #("Item 1","Item 2","Item 3") ) else #()
	
	if( control_type == #spinner ) then
		params = #(#range,[1,2,3])
	
	_Control = _Controls.control control_type ( "Test " + control_type as string ) params:params
)





/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:512