clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()

control_types = #(
	#Angle,
	#Bitmap,
	#Checkbox,
	#Checkbutton,
	#Colorpicker,
	#Combobox,
	--#Curve,-- DOES NOT WORK YET
	#Dropdownlist,
	#Edittext,
	#GroupBox,
	#hyperlink,
	#imgTag,
	--#Label,-- DOES NOT WORK YET
	#Listbox,
	#Mapbutton,
	#Materialbutton,
	#multilistbox,
	#Pickbutton,
	--#popupMenu,-- DOES NOT WORK YET
	#ProgressBar,
	--#Radiobuttons,-- DOES NOT WORK YET
	#Slider,
	#Spinner,
	#Timer,
	
	#Button
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


