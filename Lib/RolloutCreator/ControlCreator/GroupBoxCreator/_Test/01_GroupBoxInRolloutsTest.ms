clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	DEFAULT HEIGHT OF GROUPBOX IS USED
	
	IF
		GROUPBOX HAS NOT NEXT CONTROL TO FIT SIZE
	AND
		HEIGHT IS NOT DEFINED
	
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


/*
	
*/ 
function createControls _ControlsTarget control_type:#button groupbox_name:"" =
(
	for i = 1 to 3 do 
		_Button1    = _ControlsTarget.control control_type ( groupbox_name + " "+i as string ) --params:#(#across, 4)
)

/** Create group box
 */
function createGroupBox groupbox_name =
(
	_GroupBox = _Controls.control #GroupBox groupbox_name params:#( #height, 128)
	
	createControlsinGroupbox _Controls groupbox_name:groupbox_name
)
/*
*/ 
function createControlsinGroupbox _ControlsTarget control_type:#button groupbox_name:"" =
(
	for i = 1 to 3 do 
		_Button1    = _ControlsTarget.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name)
)

/** Groupboxes with height
 */
function groupboxInSubrollout count:1 =
(
	
	Subrollouts_1 = _Rollout.Subrollouts()
	
	Subrollout_1 = Subrollouts_1.new "Subrollout1"

	_Controls_sub = Subrollout_1.controls()
	
	for i = 1 to count do
	(
		groupbox_name = "Subrollout groupbox "+ i as string 
		
		_Controls_sub.control #GroupBox (groupbox_name) params:#(#height, 128)
		
		--createControlsinGroupbox _Controls_sub groupbox_name:groupbox_name
	)

)




/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/


createGroupBox("Dialog groupbox")

groupboxInSubrollout count:1

--heightbyNextControl()

--selfdefinedGroupboxes count:1 

--lastGroupboxSizeByRollout()






/*------------------------------------------------------------------------------
	CREATE ROLLOUT
--------------------------------------------------------------------------------*/

/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_width = undefined

dialog_height = 256
dialog_height = 720
--dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
