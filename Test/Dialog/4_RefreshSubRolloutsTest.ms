clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* PRINT LOG */
--DEBUG = false
DEBUG = true

/* DIALOG */
--Dialog 	= Dialog_v title:"Test"
Dialog 	= Dialog_v title:"Test" width:320 DEBUG:DEBUG
--Dialog 	= Dialog_v title:"Test" ini:(getSourceFileName())

 --_Controls_Dialog = Dialog.Controls group:"Dialog Controls"
 --_Button          = _Controls_Dialog.control #button "Dialog btn"
 --


/*------------------------------------------------------------------------------
	ROLLOUTS
--------------------------------------------------------------------------------*/

_Rollouts	 = Dialog.Rollouts()

/* ROLLOUT  */
_Rollout    = _Rollouts.Roll "Main Rollout" --rolledUp:true --height:256

_Controls   = _Rollout.Controls group:"Rollout Controls"

_Button      = _Controls.control #button "Rollout Btn" across:2
--_Button_added      = _Controls.control #button "Rollout Btn Added" across:2


/*------------------------------------------------------------------------------
	SUBROLLOUTS
------------------------------------------------------------------------------*/
--_SubRollouts	 = _Rollout.Rollouts()
--
--/* SUBROLLOUT  */
--_SubRollout    = _SubRollouts.Roll "Sub Rollout"
--
--_Controls   = _SubRollout.Controls group:"SubRollout Controls"
--
--_Button      = _Controls.control #button "Subrollout Btn"


--/*------------------------------------------------------------------------------
--	NESTED SUBROLLOUTS
--------------------------------------------------------------------------------*/
--_NestedSubRollouts	 = _SubRollout.Rollouts()
--
--/* NESTED SUBROLLOUT  */
--_NestedSubRollout    = _NestedSubRollouts.Roll "Nested Sub Rollout"
--
--_Controls   = _NestedSubRollout.Controls group:"Nested SubRollout Controls"
--
--_Button      = _Controls.control #button "Nested Btn"
--


/*------------------------------------------------------------------------------
	 CREATE DIALOG
--------------------------------------------------------------------------------*/
--Dialog.create()
Dialog.create height:512


_Button_added      = _Controls.control #button "Rollout Btn Added" across:2

RemoveSubRollout DIALOG_test.Subrollouts	ROLLOUT_main_rollout

clearListener(); print("Cleared in:\n"+getSourceFileName())

Dialog.createRollout(_Rollout)

AddSubRollout DIALOG_test.Subrollouts	ROLLOUT_main_rollout
