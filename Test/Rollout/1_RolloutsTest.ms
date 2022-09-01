clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* DIALOG */ 
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:512 height:512



/*------------------------------------------------------------------------------
	ROLLOUTS in 1st slot/
--------------------------------------------------------------------------------*/


_Rollout = Dialog.roll "Rollout in first slot"

-- _Rollout.roll "SubRollout in first slot"

-- _Rollout.roll "SubRollout in first slot"


/*------------------------------------------------------------------------------
	ROLLOUTS in 2nd slot
--------------------------------------------------------------------------------*/

_Rollouts_2 = Dialog.Rollouts slot:#optionable_id_of_slot

_Rollouts_2.roll "Rollout in second slot" width:256


/* CREATE DIALOG */ 
Dialog.create()