clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms" -- "../../../_Test/includes/CreateTestRollout.ms"

/** Create groupbox with default params
 */
function createGroupbox controls_count: groupbox_across: control_aross: =
(
	--format "\n"; print ".createGroupbox()"
	groupbox_name = "Test gb"

	--_GroupBox = _Controls.control #GroupBox groupbox_name params:#( #height, 128, #across, groupbox_across )
	_GroupBox = _Controls.control #GroupBox groupbox_name params:#( #across, groupbox_across )

	createControls groupbox_name:groupbox_name count:controls_count control_aross:control_aross
)


/*

*/ 
function createControls control_type:#button groupbox_name:"" count:1 control_aross: =
(
	for i = 1 to count do 
		--_Controls.control control_type ( groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name, #across, control_aross)
		_Controls.control control_type ( "ctrl "+groupbox_name + " "+i as string ) params:#(#groupbox, groupbox_name, #across, control_aross)
)

/*------------------------------------------------------------------------------
	RUN TESTS 
--------------------------------------------------------------------------------*/


createGroupbox controls_count:4 groupbox_across:2 control_aross:4

/* CREATE CONTROL AFTER GROUPBOX */ 
_Controls.control #listbox "After groupbox" across:2 params:#(#height, 15)


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
