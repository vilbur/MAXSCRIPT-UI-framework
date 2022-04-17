clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )


/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"


_Button2    = _Controls.control #button  "Params on creation" params:#(#width, 128, #height, 64, #tooltip, "Test tooltip" )
_Button2.param #enabled false


_Button3    = _Controls.control #button  "Params after creation"
_Button3.param #border  false
_Button3.param #height  48


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = 512
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
