clearListener()



/*------------------------------------------------------------------------------
	1) IMPORTANT: RolloutCreator.ms in test file
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/../../RolloutCreator.ms" )



/*----------- 2) COPY CODE BELLOW TO TEST FILE ---------------------------------------------------------------------*/

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"





/*----------- THIS IS TEST CODE ----------------------------------------------------------------------------------*/

_Controls   = _Rollout.Controls()
_Button1    = _Controls.control #button "Rollout button"


Subrollouts = _Rollout.Subrollouts()
Subrollout1 = Subrollouts.new "Subrollout"
_Controls   = Subrollout1.Controls()
_Button2    = _Controls.control #button  "Subrollout button"

width  = 320
height = 512





/*----------- 3) COPY CODE BELLOW TO TEST FILE ---------------------------------------------------------------------*/


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = unsupplied
dialog_height = unsupplied
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"