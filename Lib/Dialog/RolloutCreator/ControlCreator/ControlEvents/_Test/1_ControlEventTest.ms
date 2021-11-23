clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator/RolloutCreator.ms" )

/*  Import callback methods
  
	CallbackNoParam()
	CallbackWithValue(val)
	CallbackWith2Params(arg_1) (arg_2)
*/ 
filein( getFilenamePath(getSourceFileName()) + "/inlcude_test_callbacks.ms" )

ControlEvents = ControlEvents_v()

/* [Control types](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
*/ 
control_types_for_test = #(
	
	#Label,
	#Button,
	#Checkbox,
	#Checkbutton,
	#Spinner,
	#Edittext,
	#Listbox,
	#multilistbox,
	#Dropdownlist
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
)


/** DEFINE UI 
 *	
 */
try( destroyDialog ROLLOUT_test )catch()

_RolloutCreator 	= RolloutCreator_v()
_RolloutCreator.Ini.setIni (getSourceFileName())

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls()


/** ADD CONTROLS WITH EVENTS
 */


for control_type in ControlEvents.control_types where findItem control_types_for_test control_type > 0 do
(
	event_types = ControlEvents._getEventsOfControl(control_type)
	
	if( event_types.count > 0 ) then
	(
		_Control = _Controls.control control_type ( "Test " + control_type as string ) 
		format "\ncontrol_type = % \nevent_types  = % \n\n" control_type event_types
		
		/** ADD EVENTS
		 */
		for event_type in event_types do
			_Control.Events.add event_type "print \"Pressed\""

	)
)





/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)