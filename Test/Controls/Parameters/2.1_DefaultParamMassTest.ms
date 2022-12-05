clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"

/**  

	1) Global defaults for all controls
	2) Global default per control type
	3) User Defined param

*/



across = 5

_Controls.Default #across across;

_Controls.Default #border false type:#button 


for i = 1 to 10 do
(
	
	if( i > 4  ) then across = 4
	if( i > 7  ) then across = 3
	if( i > 9  ) then across = 2
	
	_Button1    = _Controls.control #button ( "Button"+ i as string ) params:#(#across, across)
)


_Controls.Default #across 1 type:#multilistbox 

_Controls.control #multilistbox "multilistbox"

/** Create dialog from _Rollout
  */
dialog_width = 320
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
