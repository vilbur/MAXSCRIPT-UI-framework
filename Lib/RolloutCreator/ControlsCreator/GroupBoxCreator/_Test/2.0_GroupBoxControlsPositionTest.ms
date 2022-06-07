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
function createGroupBox count prefix:"" control_type:#button =
(

	groupbox_id = ("groupbox_" + prefix) as name 
	_Controls.control #GroupBox ("LEFT HALF " + prefix ) id:groupbox_id params:#(#across, 2)
	--_Controls.control #listbox ("RIGHT HALF " + prefix ) params:#(#across, 2)
	
	
	_Controls.Default #across 2 type:#dropdownlist
	
	for i = 1 to count do 
	(
	
	
		_Control    = _Controls.control #button ( prefix + i as string ) params:#(#groupbox, groupbox_id)
		--_Control    = _Controls.control control_type ( prefix + i as string ) params:#(#groupbox, groupbox_id)
	
	)
	--_Controls.control #dropdownlist ("FULL WIDTH " + prefix) params:#(#across, 3)
	
	-- 
	--_Controls.control #dropdownlist ("LEFT " + prefix  ) --params:#(#across, 1)
	--_Controls.control #dropdownlist ("RIGHT " + prefix  ) --params:#(#across, 1)
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

for i = 1 to 1 do
	createGroupBox i prefix:("DDTest" + i as string ) control_type:#dropdownlist
	--createGroupBox i prefix:("DDTest" + i as string ) control_type:#button
	

--createGroupBox prefix:"DDTest" control_type:#dropdownlist

/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_height = 1920
--dialog_height = 1024
dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
