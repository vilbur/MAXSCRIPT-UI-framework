clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"



/** Controls without fakes
 */
function controlsWithoutFakes =
(
	across = 4

	for i = 1 to 10 do
	(
		if( i > 4  ) then across = 3
		if( i > 7  ) then across = 2
		if( i > 9  ) then across = 1
		
		_Button1    = _Controls.control #button ( "Button A"+ i as string ) params:#(#across, across)
	)
)


/** Controls without fakes
 */
function controlsWithFakes =
(
	across = 4
		
	for i = 1 to 2 do
		_Button1    = _Controls.control #button ( "Button B"+ i as string ) params:#(#across, across)
	
	
	_Controls.Default #across 1 type:#multilistbox 
	
	_Controls.control #multilistbox "multilistbox"
)


/** RUN TEST 
  *	
  */	
controlsWithoutFakes()
controlsWithFakes()


/** Create dialog from _Rollout
  */
dialog_width = 384
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"