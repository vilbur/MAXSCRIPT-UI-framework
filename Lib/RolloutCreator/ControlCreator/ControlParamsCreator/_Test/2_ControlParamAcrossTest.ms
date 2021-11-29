clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../../../RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"



for i = 1 to 10 do
(
	across = 4
	
	if( i > 4  ) then across = 3
	if( i > 7  ) then across = 2
	if( i > 9  ) then across = 1
	
	_Button1    = _Controls.control #button ( "Button"+ i as string ) params:#(#across, across)
)


/** Create dialog from _Rollout
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
