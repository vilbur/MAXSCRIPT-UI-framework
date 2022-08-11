clearListener()	

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/RolloutCreator/RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Ini/Ini.ms" )

try( destroyDialog Controls_test )catch()

/** DEFINE UI 
 *
 * [All control types available in maxscript UI ](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
 */
 -- _RolloutCreator 	= RolloutCreator_v Ini:(Ini_v _path:(getSourceFileName()))
_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())

_Rollout = _RolloutCreator.new "Controls Test"

_Controls = _Rollout.Controls group:"Test"

--_Button_1 = _Controls.control #button "Button 1" id:#button_1 params:#( #tooltip, "Test Tooltip", #across, 1)
--
--_EditText = _Controls.control #EditText "EditText 1"
--
--_BrowsePath = _Controls.control #BrowsePath "BrowsePath 1"

--_ListBox = _Controls.control #ListBox "ListBox 1" params:#(#items, items_of_controls)

/**  COMMENTED TYPES ARE NOT SUPPORTED
  */
control_types = #(
	--#Label,
	--#Button,
	--#Checkbox,
	--#CheckButton,
	--#Pickbutton,
	--#Spinner,
	--#EditText,
	--#BrowsePath,
	--
	--#Listbox,
	--#MultiListBox,
	--#Dropdownlist,
	--#Combobox,
	--#ColorPicker,
	#RadioButtons,
	--#Slider,
	--#Angle,
	--#hyperlink,
	--#Materialbutton,
	
	
	/* NOT SUPPORTED YET
	   
		EDIT STEPS BELLOW WHEN ADDING NEW TYPE:
			1) METHOD: EventTypes_v._setEventTypes()
			2) PROPERTY: ControlValue_v.names_of_value_param
	
	*/ 
	--#imgTag,
	--#Bitmap,
	--#Mapbutton,
	--#ProgressBar,
	--#Curve,
	--#popupMenu,
	--#Timer,
	
	/* END OF ARRAY */ 
	#GroupBox

	/* DEVELOPENT */ 
	--#Listbox
	-- #Button
)

items_of_controls = for i = 1 to 3 collect ("item "+ i as string )
--items_of_controls = for i = 1 to 2 collect (""+ i as string )


/** Add item controls
 */
function addControls control_types =
(
	for control_type in control_types do
		_Controls.control control_type (control_type as string +" 1") items:items_of_controls 
)


/** CREATE CONTROLS 
  *	
  */
addControls (control_types)



/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:480