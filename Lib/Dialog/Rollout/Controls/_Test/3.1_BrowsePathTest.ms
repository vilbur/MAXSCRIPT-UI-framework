clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator/RolloutCreator.ms" )


/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestRollout.ms"

--_RolloutCreator.Ini.setIni (getSourceFileName())



_BrowsePath = _Controls.control #browsePath ( "Test" ) 

--_BrowsePath.Events.add #changed "CallbackNoParam()" params:"val"
--_BrowsePath.Events.add #changed "print \"Yes\"" params:"val"
_BrowsePath.Events.add #changed "print \"User Event\""
--_BrowsePath.Events.add #changed "print val"


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = 512
--dialog_width  = unsupplied
dialog_height = unsupplied

include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestDialog.ms"
