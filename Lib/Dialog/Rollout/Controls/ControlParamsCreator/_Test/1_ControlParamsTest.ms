clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestRollout.ms"



--_Controls   = _Rollout.Controls()
_Button1    = _Controls.control #button "Params in string" params:"width:256"


Subrollouts = _Rollout.Subrollouts()
Subrollout1 = Subrollouts.roll "Subrollout"
_Controls   = Subrollout1.Controls()
_Button2    = _Controls.control #button  "Params in array" params:#(#width, 128, #height, 32 )



/** Create dialog from _Rollout
  */
include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestDialog.ms"