clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )
/** INCLUDE UI 
 */
filein( getFilenamePath(getSourceFileName()) + "/../../../_Test/includes/CreateTestRollout.ms" )


_Controls.group = "Controls A"
_Controls_B = _Rollout.controls group:"Controls B"


_Controls.control #button "Test A1" --params:#(#across, 2)
_Controls.control #button "Test A2" --params:#(#across, 2)


_Controls_B.control #button "Test B1" --params:#(#across, across)
_Controls_B.control #button "Test B2"params:#(#across, 4)


/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/
dialog_width = 420
dialog_height = 512
--dialog_height = 1024
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"