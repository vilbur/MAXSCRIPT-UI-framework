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

function createGroupBox prefix:"" control_type:#button =
(
	_Controls.control #GroupBox ("LEFT HALF " + prefix ) id:#groupbox_left params:#(#across, 2)
	_Controls.control #listbox ("RIGHT HALF " + prefix ) params:#(#across, 2)

	_Controls.Default #across 2 type:#dropdownlist

	for i = 1 to 4 do 
	(
		_Button1    = _Controls.control control_type ( prefix + i as string ) params:#(#groupbox, #groupbox_left, #across, 2)
	)
	_Controls.control #dropdownlist ("FULL WIDTH " + prefix) params:#(#across, 3)

	_Controls.control #dropdownlist ("LEFT " + prefix  ) --params:#(#across, 1)
	_Controls.control #dropdownlist ("RIGHT " + prefix  ) --params:#(#across, 1)
)

/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/

createGroupBox prefix:"DDTest" control_type:#dropdownlist

/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_height = 1920
--dialog_height = 1024
dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
