clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))



/*------------------------------------------------------------------------------
	ROLLOUTS in 1st slot/
--------------------------------------------------------------------------------*/

_Rollout = Dialog.roll "Rollout in first slot"

-- _Rollout.roll "SubRollout in first slot"

-- _Rollout.roll "SubRollout in first slot"


/*------------------------------------------------------------------------------
	ROLLOUTS in 2nd slot
--------------------------------------------------------------------------------*/

_Rollouts_2 = Dialog.Rollouts slot:#optionable_id_of_slot -- Create second  slot

--format "_Rollouts_2:	% \n" _Rollouts_2
_Rollouts_2.Roll "Rollout in second slot"


/* CREATE DIALOG */
Dialog.create()
-- Dialog.create width:420 height:512