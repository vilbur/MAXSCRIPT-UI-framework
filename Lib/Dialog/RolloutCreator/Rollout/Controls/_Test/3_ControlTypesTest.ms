clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()

/* [Control types](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
*/ 
control_types = #(
	#Button,
	#Checkbutton,
	#Edittext,
	#Checkbox,
	#Spinner,
	#Dropdownlist,
	#Combobox,
	#Listbox,
	#multilistbox,
	#GroupBox,
	#Angle,
	#Bitmap,
	#Colorpicker,
	#hyperlink,
	#imgTag,
	#Mapbutton,
	#Materialbutton,
	#Pickbutton,
	#ProgressBar,
	#Slider,
	--#Curve,-- DOES NOT WORK YET
	--#Label,-- DOES NOT WORK YET
	--#popupMenu,-- DOES NOT WORK YET
	--#Radiobuttons,-- DOES NOT WORK YET
	#Timer
)


/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls()


for control_type in control_types do
	_Control = _Controls.control control_type ( "Test " + control_type as string ) 




/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)


