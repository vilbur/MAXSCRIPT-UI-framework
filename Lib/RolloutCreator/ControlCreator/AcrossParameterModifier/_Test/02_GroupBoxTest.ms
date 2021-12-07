clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"

/** Multilistbox
 */
function createGroupBox prefix:"" control_type:#button =
(


	_Controls.control #GroupBox ("LEFT HALF " + prefix ) id:#groupbox_left params:#(#across, 2)
	_Controls.control #listbox ("RIGHT HALF " + prefix ) params:#(#across, 2)

	
	_Controls.Default #across 2 type:#dropdownlist
	
	for i = 1 to 4 do 
	(

		--_Controls.Default #width 96 type:#button
		--_Controls.Default #width 96 type:#label
		
		--_Control    = _Controls.control #button ( prefix + i as string ) params:#(#groupbox, #groupbox_left)
		_Control    = _Controls.control #dropdownlist ( "DD"+prefix + i as string ) params:#(#groupbox, #groupbox_left)
		--_Control    = _Controls.control #dropdownlist "" id:( "DD"+prefix + i as string ) params:#(#groupbox, #groupbox_left)
		----_Control    = _Controls.control #listbox ( "LB"+prefix + i as string ) params:#(#groupbox, #groupbox_left)
		
		--_Button1    = _Controls.control control_type ( prefix + i as string ) params:#(#groupbox, #groupbox_left, #across, 2)
		--_Button1    = _Controls.control control_type ( prefix + i as string ) params:#(#across, 2)
	)
	_Controls.control #dropdownlist ("FULL WIDTH " + prefix) params:#(#across, 3)

  
	_Controls.control #dropdownlist ("LEFT " + prefix  ) --params:#(#across, 1)
	_Controls.control #dropdownlist ("RIGHT " + prefix  ) --params:#(#across, 1)
)

/*------------------------------------------------------------------------------
	TESTS DEFINITION
--------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/

--createOnlyButtons(1) prefix:"x"
--createGroupBox()
--createGroupBox prefix:"Groupbox A"
createGroupBox prefix:"DDTest" control_type:#dropdownlist

/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_height = 1920
--dialog_height = 1024
dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
