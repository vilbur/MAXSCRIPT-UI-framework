clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator/RolloutCreator.ms" )


/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestRollout.ms"



_BrowsePath = _Controls.control #browsePath ( "Test" ) 

_BrowsePath.Events.add #changed "print (\"User Event #changed \" + val )"
_BrowsePath.Events.add #entered "print (\"User Event #entered \" + val )"


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = 512
--dialog_width  = unsupplied
dialog_height = unsupplied

include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestDialog.ms"