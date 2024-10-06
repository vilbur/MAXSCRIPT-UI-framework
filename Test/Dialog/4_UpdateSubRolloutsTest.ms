clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* PRINT LOG */
DEBUG = false
--DEBUG = true

/* DIALOG */
Dialog 	= Dialog_v title:"Test" width:320 DEBUG:DEBUG

/*------------------------------------------------------------------------------
	ROLLOUTS
--------------------------------------------------------------------------------*/

_Rollouts = #()

_SubRollouts	 = Dialog.Rollouts()

for i = 1 to 3 do
(
	/* ROLLOUT  */
	_SubRollout    =_SubRollouts.Roll ( "Rollout "+ i as string ) --rolledUp:true --height:256

	append _Rollouts _SubRollout
)


/*------------------------------------------------------------------------------
	 CREATE DIALOG
--------------------------------------------------------------------------------*/
--Dialog.create()
Dialog.create height:512


/*------------------------------------------------------------------------------
	MODIFY ROLLOUT
--------------------------------------------------------------------------------*/
_Rollouts[2].title += " - REFRESHED"

_Controls   = _Rollouts[2].Controls group:"Rollout Controls"

for i = 1 to count = 3 do
	_Button = _Controls.control #BUTTON ("Rollout Btn" + i as string) across:count


/*------------------------------------------------------------------------------
	REFRESH ROLLOUT
--------------------------------------------------------------------------------*/
Dialog.updateRollout(_Rollouts[2])