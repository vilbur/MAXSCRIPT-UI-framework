clearListener()

/** IMPORTANT: Import RolloutCreator.ms in test file
  *
  *	Beacause of fileIn relative path
  */
filein( getFilenamePath(getSourceFileName()) + "/../../RolloutCreator.ms" )



/*----------- COPY CODE BELLOW TO TEST FILE ---------------------------------------------------------------------*/

/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestRollout.ms"





/*----------- THIS IS TEST CODE ----------------------------------------------------------------------------------*/

_Controls   = _Rollout.Controls()
_Button1    = _Controls.control #button "Rollout button"


Subrollouts = _Rollout.Subrollouts()
Subrollout1 = Subrollouts.roll "Subrollout"
_Controls   = Subrollout1.Controls()
_Button2    = _Controls.control #button  "Subrollout button"

width  = 320
height = 512





/*----------- COPY CODE BELLOW TO TEST FILE ---------------------------------------------------------------------*/


/** Create dialog ROLLOUT_test from _Rollout
  *
  */
dialog_width  = unsupplied
dialog_height = unsupplied

include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/RolloutCreator/_Test/includes/CreateTestDialog.ms"