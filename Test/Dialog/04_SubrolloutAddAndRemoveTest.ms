clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"



/**
	Create each rollout on its own

*/


try( destroyDialog DIALOG_test )catch()

/* DIALOG */
--Dialog 	= Dialog_v title:"Test"
Dialog 	= Dialog_v title:"Test" width:256 height:256

_Rollouts	 = Dialog.Rollouts()

Dialog.create()


/*------------------------------------------------------------------------------
	ROLLOUTS
--------------------------------------------------------------------------------*/


/* ROLLOUT  */
DialogSub 	= Dialog_v title:"subrollout test" width:256

_Controls   = DialogSub.Controls group:"Rollout Controls"

_Button      = _Controls.control #button "Rollout Btn" id:#button_3


/*------------------------------------------------------------------------------
	 CREATE DIALOG
--------------------------------------------------------------------------------*/

DialogSub.create create_dialog:false


--try( destroyDialog DIALOG_subrollout_test )catch()

AddSubRollout DIALOG_test.Subrollouts	DIALOG_subrollout_test