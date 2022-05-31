clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/RolloutCreator/RolloutCreator.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Ini/Ini.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/IniSaver/IniSaver.ms" )

try( destroyDialog test )catch()

/** DEFINE UI 
 *
 * [All control types available in maxscript UI ](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
 */


 _RolloutCreator 	= RolloutCreator_v Ini:(Ini_v _path:(getSourceFileName()))
-- _RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())

_Rollout = _RolloutCreator.new "Test"

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
	--#Edittext,
	--
	--#Listbox,
	--#MultiListBox,
	--#Dropdownlist,
	--#Combobox,
	--#ColorPicker,
	#RadioButtons,

	--#Angle,
	--#Bitmap,
	--#hyperlink,
	--#imgTag,
	--#Mapbutton,
	--#Materialbutton,
	--#ProgressBar,
	--#Slider,
	--#Curve,	-- DOES NOT WORK YET
	--#popupMenu,	-- DOES NOT WORK YET
	--#Timer,
	
	/* CUSTOM CONTROL TYPES */ 
	--#browsePath
	 #GroupBox

)

items_of_controls = for i = 1 to 3 collect ("item "+ i as string )
--items_of_controls = for i = 1 to 2 collect (""+ i as string )


/** Add item controls
 */
function addControls control_types =
(
	--format "\n"; print ".addControls()"'
	for control_type in control_types do
	(
		
		params = #(#items, items_of_controls)
		
		params = case control_type of (

			--#RadioButtons:	params + #(#labels, items_of_controls, #columns, 4)
			#RadioButtons:	params + #(#labels, items_of_controls)
			--#RadioButtons:	params + #(#labels, items_of_controls, #columns, 2)
			--#RadioButtons:	params + #(#labels, items_of_controls, #columns, 2, #offset, [48,0])
			default:	params
			)
		
		
		format "params	= % \n" params
		_Controls.control control_type (control_type as string +" 1") params:params
	)
			--_Controls.control control_type (control_type as string +" 1") params:#(#items, items_of_controls, #labels,#("Radio 1", "Radio 2", "Radio 3"), #columns, 4)
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


















