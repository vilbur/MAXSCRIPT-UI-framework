clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../ControlEventsCreator.ms" )

filein( getFilenamePath(getSourceFileName()) + "/inlcude_test_callbacks.ms" )

ControlEvents = ControlEventsCreator_v()


/* ONLY THIS TYPES OF CONTROLS WILL BE TESTED
  * 
  * CURRENTLY SUPPORTED CONTROLS are in control_types array in  "../../ControlEventsCreator/ControlEventsCreator.ms"
  * 
  *  [HELP Control types](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
  *
*/ 
these_controls_will_be_tested = #(
	#Label,
	#Button,
	#Checkbox,
	#Checkbutton,
	#Spinner,
	#Edittext,
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
	
	/* TEMP FOR DEV */ 
	#Checkbox
	--#browsePath

)

controls_with_items = #(
	#Listbox,
	#multilistbox,
	#Dropdownlist,
	#Combobox
)



/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"




/** ADD CONTROLS WITH EVENTS
 */
for control_type in ControlEvents.control_types where findItem these_controls_will_be_tested control_type > 0 do
(
	event_types  = ControlEvents._getEventsOfControl(control_type)
	event_params = ControlEvents._getParamsOfEvents(control_type)
	
	if( event_types.count > 0 ) then
	(
		params	= if( findItem controls_with_items control_type > 0 ) then #( #items, #("Item 1","Item 2","Item 3") ) else #()
		--format "control_type	= % \n" control_type
		--format "params	= % \n" params
		_Control = _Controls.control control_type ( "Test " + control_type as string ) params:params

		/** ADD EVENTS
		 */
		for i = 1 to event_types.count do
			_Control.Event event_types[i]  (
				case try((filterString event_params[i] " ").count)catch() of
				(
					1:"CallbackWithValue"
					2:"CallbackWith2Params"
					default:"CallbackNoParam()"
				)
			)	
			
		
	)
)


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = unsupplied
dialog_height = unsupplied

include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"