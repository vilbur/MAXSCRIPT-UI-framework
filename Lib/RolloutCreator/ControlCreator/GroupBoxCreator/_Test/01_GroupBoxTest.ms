clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"

/*------------------------------------------------------------------------------
	TESTS DEFINITION
--------------------------------------------------------------------------------*/
function createControls control_type:#button groupbox_name:"" =
(
	for i = 1 to 5 do 
		_Button1    = _Controls.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name, #across, 2)
)


/** Create group box
 */
function createGroupBox groupbox_name =
(
	--_GroupBox_1 = _Controls.control #GroupBox "GroupBox1" params:#(#across, 2, #height, 256) 
	_GroupBox_1 = _Controls.control #GroupBox groupbox_name params:#(#across, 2) 
	--_GroupBox_1 = _Controls.control #GroupBox groupbox_name params:#(#across, 2, #height, 256, #width, 128) 
	
	--createControls control_type:#button groupbox_name:groupbox_name	
)


for i = 1 to 3 do 
	createGroupBox ("GroupBoxA"+ i as string )

_Controls.control #GroupBox "Manual position" params:#(#across, 2, #pos, [16,128], #height, 128) 
_Controls.control #GroupBox "Auto position" params:#(#across, 2) 


--_Controls.control #dropdownlist "Test" --params:#(#across, 2)
_Controls.control #multilistbox "Test" --params:#(#across, 2)
--_Controls.control #button "Test" params:#(#across, 2, #height, 128)

/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/



--createControls prefix:"Buttons"	control_type:#dropdownlist
--createControls prefix:"Dropdowns"	control_type:#dropdownlist


/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_width = undefined

dialog_height = 256
dialog_height = 512
--dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
