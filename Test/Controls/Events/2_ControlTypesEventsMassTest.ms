clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/RolloutCreator.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/ControlsCreator/ControlEventBinder/ControlEventBinder.ms" )

filein( getFilenamePath(getSourceFileName()) + "/inlcude_test_callbacks.ms" )

/*------------------------------------------------------------------------------

			TEST ALL EVENT TYPES ON ALL CONTROL TYPES

--------------------------------------------------------------------------------*/

/* ONLY THIS TYPES OF CONTROLS WILL BE TESTED
  * 
  * CURRENTLY SUPPORTED CONTROLS are in control_types array in  "../../../../Dialog/Rollout/Controls/ControlTypes/ControlTypes.ms"
  * 
  *  [HELP Control types](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
  *
*/ 
these_controls_will_be_tested = #(

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
	#Button
	--#Checkbox
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
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"

--ControlEventBinder = ControlEventBinder_v _Rollout:_Rollout
EventTypes = EventTypes_v()

/** ADD CONTROLS WITH EVENTS
 */
for control_type in (ControlTypes_v()).list where findItem these_controls_will_be_tested control_type > 0 do
(
	event_types  = EventTypes.getEventTypesOfControl(control_type)
	event_params = EventTypes.getParamsOfEvents(control_type)

	--format "\n"
	--format "control_type	= % \n" control_type
	--format "event_types	= % \n" event_types
	--format "event_params	= % \n" event_params

	if( event_types.count > 0 ) then
	(
		params	= if( findItem controls_with_items control_type > 0 ) then #( #items, #("Item 1","Item 2","Item 3") ) else #()
		--format "params	= % \n" params
		_Control = _Controls.control control_type ( "Test " + control_type as string ) params:params

		/** ADD EVENTS
		 */
		for i = 1 to event_types.count do
		(
			format "filterString event_params[i]	= % \n" (try((filterString event_params[i] " " ).count)catch(0))
			_Control.Event event_types[i]  (
				case try((filterString event_params[i] " " ).count)catch(0) of
				(
					0:"CallbackNoParam()"
					1:"CallbackWithValue"
					2:"CallbackWith2Params"
				)
			)	
		)

	)
)

/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = unsupplied
dialog_height = unsupplied

include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"