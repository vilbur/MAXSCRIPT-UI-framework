clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestRollout.ms"



--_Controls   = _Rollout.Controls()
--_Button1    = _Controls.control #button "Params in string" params:"width:256"


--Subrollouts = _Rollout.Subrollouts()
--Subrollout1 = Subrollouts.roll "Subrollout"
--_Controls   = Subrollout1.Controls()
_Button2    = _Controls.control #button  "Params on creation" params:#(#width, 128, #height, 64 )
_Button2.param #enabled false


_Button3    = _Controls.control #button  "Params after creation"
_Button3.param #border  false
_Button3.param #height  48


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = 512
--dialog_width  = unsupplied
dialog_height = unsupplied

include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestDialog.ms"
