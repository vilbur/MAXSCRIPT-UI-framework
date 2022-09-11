clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"

/*

*/ 
function createControls control_type:#button groupbox_name:"" count:1 =
(
	for i = 1 to count do 
		_Controls.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name, #across, 2)
)

/** Create groupbox with default params
 */
function createGroupbox controls_count =
(
	--format "\n"; print ".createGroupbox()"
	groupbox_name = "Groupbox defined"

	_GroupBox = _Controls.control #GroupBox groupbox_name params:#( #height, 128 )

	createControls groupbox_name:groupbox_name count:controls_count
)

/** Create groupbox defined by control
 */
function createGroupboxDefinedByControl controls_count =
(
	--format "\n"; print ".createGroupboxDefinedByControl()"
	groupbox_name = "By control"

	createControls groupbox_name:groupbox_name count:controls_count
)

/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/

/* SET DEFAULT PARAMS FOR GROUPBOX */ 
_Controls.Default #across 2 type:#groupbox

/* CREATE CONTROL BEFORE GROUPBOX */ 
_Controls.control #button "Before groupbox" across:1

createGroupbox(1)
--createGroupbox(5)

createGroupboxDefinedByControl(1)
--createGroupboxDefinedByControl(3)



/*------------------------------------------------------------------------------
	CREATE ROLLOUT
--------------------------------------------------------------------------------*/

/** Create dialog from _Rollout
  */
dialog_width = 420
--dialog_width = undefined

--dialog_height = 256
dialog_height = 720
--dialog_height = undefined
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
