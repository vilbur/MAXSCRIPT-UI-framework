clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* INIT DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:320


/*------------------------------------------------------------------------------
	ROLLOUTS A
--------------------------------------------------------------------------------*/
Rollouts_A = Dialog.Rollouts slot:#Rollouts_A height:1024
Rollout_A1 = Rollouts_A.Roll "Rollout A1" height:512


/* Set properties of subrollouts */
Rollouts_A_set_props	= Dialog.get (#Rollouts_A)


/* SUB ROLLOUTS */
_Subrollouts = Rollout_A1.Rollouts  height:320
_Subrollout = _Subrollouts.Roll "Subrollout A" height:128


/* ROLLOUTS  NESTED */
NestedSubrollouts = _Subrollout.Rollouts slot:#NestedSubrollouts  height:128
_NestedSubrollout  = NestedSubrollouts.Roll ("Nested Rollout")  height:196

--_Controls =  _NestedSubrollout.Controls()
--_Controls.control #button "Button X"


/* ROLLOUTS SUB NESTED */
SubNestedSubrollouts = _NestedSubrollout.Rollouts slot:#SubNestedSubrollouts
_SubNestedSubrollout  = SubNestedSubrollouts.Roll ("SubNested Rollout")



/*------------------------------------------------------------------------------
	ROLLOUTS B
--------------------------------------------------------------------------------*/
Rollouts_B = Dialog.Rollouts slot:#Rollouts_B
Rollout_B1 = Rollouts_B.Roll "Rollout B1" height:256


/* SUB ROLLOUTS B */
_Subrollouts_B = Rollout_B1.Rollouts()
_Subrollout = _Subrollouts_B.Roll "Subrollout B1" height:128



/* CREATE DIALOG */
--Dialog.create()
Dialog.create height:256
