clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"


across = 4

_Controls.Default #across across type:#button 


for i = 1 to 10 do
(
	
	if( i > 4  ) then across = 3
	if( i > 7  ) then across = 2
	if( i > 9  ) then across = 1
	
	_Button1    = _Controls.control #button ( "Button"+ i as string ) params:#(#across, across)
)


_Controls.Default #across 1 type:#multilistbox 

_Controls.control #multilistbox "multilistbox"

/** Create dialog from _Rollout
  */
dialog_width = 320
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
