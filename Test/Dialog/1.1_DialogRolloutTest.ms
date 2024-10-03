clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"


/* DIALOG */
--Dialog 	= Dialog_v title:"Test"
Dialog 	= Dialog_v title:"Test" width:512
--Dialog 	= Dialog_v title:"Test" ini:(getSourceFileName())

-- _Controls_Dialog = Dialog.Controls group:"Dialog Controls"
-- _Button          = _Controls_Dialog.control #button "Dialog btn" id:#button_3


/*------------------------------------------------------------------------------
	ROLLOUTS
--------------------------------------------------------------------------------*/

_Rollouts	 = Dialog.Rollouts()

/* ROLLOUT  */
_Rollout    = _Rollouts.Roll "Main Rollout" --rolledUp:true --height:256

_Controls   = _Rollout.Controls group:"Rollout Controls"

_Button      = _Controls.control #button "Rollout Btn" id:#button_3


/*------------------------------------------------------------------------------
	SUBROLLOUTS
------------------------------------------------------------------------------*/
_SubRollouts	 = _Rollout.Rollouts()

/* SUBROLLOUT  */
_SubRollout    = _SubRollouts.Roll "Sub Rollout"

_Controls   = _SubRollout.Controls group:"SubRollout Controls"

_Button      = _Controls.control #button "Subrollout Btn" id:#button_3


/*------------------------------------------------------------------------------
	NESTED SUBROLLOUTS
------------------------------------------------------------------------------*/
_NestedSubRollouts	 = _SubRollout.Rollouts()

/* NESTED SUBROLLOUT  */
_NestedSubRollout    = _NestedSubRollouts.Roll "Nested Sub Rollout"

_Controls   = _NestedSubRollout.Controls group:"Nested SubRollout Controls"

_Button      = _Controls.control #button "Nested Btn" id:#button_3



/*------------------------------------------------------------------------------
	 CREATE DIALOG
--------------------------------------------------------------------------------*/
Dialog.create()
--Dialog.create width:512 height:512