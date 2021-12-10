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
	
	
	
	for i = 1 to 1 do 
		_Button1    = _Controls.control control_type ( groupbox_name + "."+i as string ) params:#(#groupbox, groupbox_name, #across, 2)
)



_GroupBox_1 = _Controls.control #GroupBox "GroupBox1" params:#(#across, 2, #height, 256) 
createControls control_type:#button groupbox_name:"GroupBox1"	


--_GroupBox_2 = _Controls.control #GroupBox "GroupBox2" params:#(#across, 2) 
--_GroupBox_2 = _Controls.control #GroupBox "GroupBox2" params:#(#across, 2, #height, 256) 
--createControls control_type:#button groupbox_name:"GroupBox2"	

--createControls control_type:#dropdownlist groupbox_name:"Buttons"	



--_GroupBox_2 = _Controls.control #GroupBox "GroupBox 2" params:#(#across, 2)
--_GroupBox_3 = _Controls.control #GroupBox "GroupBox 3" params:#(#across, 2)
--_GroupBox_4 = _Controls.control #GroupBox "GroupBox 4" params:#(#across, 2)




/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/



--createControls prefix:"Buttons"	control_type:#dropdownlist
--createControls prefix:"Dropdowns"	control_type:#dropdownlist


/** Create dialog from _Rollout
  */
--dialog_width = 420
dialog_width = undefined
--dialog_height = 1920
dialog_height = 256
--dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
