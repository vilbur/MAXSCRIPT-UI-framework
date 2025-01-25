clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* INIT DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:320


/* ROLLOUTS */
_Rollouts = Dialog.Rollouts slot:#Rollouts_A
_Rollout = _Rollouts.Roll ("Rollout") height:256


/* Set properties of subrollouts */
--_Rollouts_A_set_props	= Dialog.get (#Rollouts_A)



/* SUB ROLLOUTS */
_Subrollouts = _Rollout.Rollouts slot:#_Subrollouts
_Subrollout = _Subrollouts.Roll ("Subrollout") height:128



/* ROLLOUTS  NESTED */
_NestedSubrollouts = _Subrollout.Rollouts slot:#_NestedSubrollouts
_NestedSubrollout  = _NestedSubrollouts.Roll ("Nested Rollout")



/* ROLLOUTS SUB NESTED */
_SubNestedSubrollouts = _NestedSubrollout.Rollouts slot:#_SubNestedSubrollouts
_SubNestedSubrollout  = _SubNestedSubrollouts.Roll ("SubNested Rollout")



/* ROLLOUTS B */
_Subrollouts_B = _Rollout_B1.Rollouts slot:#_Subrollouts_B
_Subrollout_B = _Subrollouts_B.Roll ("Subrollout") height:128



/* CREATE DIALOG */
--Dialog.create()
Dialog.create height:256