clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/RolloutCreator/RolloutCreator.ms" )

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"

/**  

	1) Global defaults for all controls
	2) Global default per control type
	3) User Defined param

*/



/* DEFAULT PARAMS */ 
across = 5

_Controls.Default #across across; -- set global parameter, type:#global

_Controls.Default #border false type:#button 

_Controls.Default #border false type:#list 

/* CONTROL PARAMS */ 
--_Button1    = _Controls.control #button ( "Button" )
_Button1	= _Controls.control #button ( "Button" ) params:#(#across, across)
_MultiListBox	= _Controls.control #MultiListBox ( "MultiListBox" ) params:#(#across, across)


/** Create dialog from _Rollout
  */
dialog_width = 320
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"
