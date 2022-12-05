clearListener()


/* HOW TO INCLUDE:
   
	1) Filein RolloutCreator.ms in test file
	
	2) Define width & height of rollout -- optionable
	
	3) Include CreateTestRollout.ms
	
	4) Write code, variables _Rollout & _Controls are created already
	
	5) Include CreateTestDialog.ms
	
*/ 


/*------------------------------------------------------------------------------
	1) IMPORTANT: RolloutCreator.ms in test file
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/../../RolloutCreator.ms" )



/*----------- COPY CODE BELLOW TO TEST FILE ---------------------------------------------------------------------*/


/* POSSIBLE TO DEFINE SIZE OF ROLLOUT before include of CreateTestRollout.ms */ 
width  = 256
height = 256


/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"



/*----------- THIS IS TEST CODE TO CREATE CONTROLS ----------------------------------------------------------------------------------*/

_Controls   = _Rollout.Controls()
_Button1    = _Controls.control #button "Rollout button"


Subrollouts = _Rollout.Subrollouts()
Subrollout1 = Subrollouts.Roll "Subrollout"
_Controls   = Subrollout1.Controls()
_Button2    = _Controls.control #button  "Subrollout button"



/*----------- COPY CODE BELLOW TO TEST FILE ---------------------------------------------------------------------*/



/** Create dialog ROLLOUT_test from _Rollout
  *
  */
include "MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestDialog.ms"