clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* INIT DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:320


/* ROLLOUTS A */
_Rollouts_A = Dialog.Rollouts slot:#Rollouts_A
_Rollout_A1 = _Rollouts_A.Roll ("Rollout A1") height:256

/* Set properties of subrollouts */
_Rollouts_A_set_props	= Dialog.get (#rollouts_A)


/* ROLLOUTS A NESTED */
_Rollouts_A_nested = _Rollout_A1.Rollouts slot:#Rollouts_A_nested
_Rollout_A1_nested = _Rollouts_A_nested.Roll ("Rollout A1 nested") height:128

/* ROLLOUTS A SUB NESTED */
_Rollouts_A_subnested = _Rollout_A1_nested.Rollouts slot:#Rollouts_A_subnested
_Rollout_A1_subnested = _Rollouts_A_subnested.Roll ("Rollout A1 sub nested")


/* ROLLOUTS B */
_Rollouts_B = Dialog.Rollouts slot:#Rollouts_B	height:128
_Rollout_B1 = _Rollouts_B.Roll ("Rollout B1")	height:96



/* CREATE DIALOG */
--Dialog.create()
Dialog.create height:1024 