clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"



_Controls.Default #across 2  type:#button


button_wide = _Controls.control #button "Button wide" params:#(#width, 256)

for i = 1 to 3 do
	_Control = _Controls.control #button ( "Test " + i as string ) params:#(#width, 64)



/** Create dialog from _Rollout
  */
dialog_width = 512
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"