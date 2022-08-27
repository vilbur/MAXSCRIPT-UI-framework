clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* INIT DIALOG */ 
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))


/* ROLLOUTS A */ 	
_Rollouts_A = Dialog.Rollouts slot:#Rollouts_A
_Rollout_A1 = _Rollouts_A.Roll ("Rollout A1")

/* Set properties of subrollouts */ 
_Rollouts_A_set_props	= Dialog.get (#rollouts_A)
_Rollouts_A_set_props.height	= 64



/* ROLLOUTS B */ 	
_Rollouts_B = Dialog.Rollouts slot:#Rollouts_B
_Rollout_B1 = _Rollouts_B.Roll ("Rollout B1")


/* ROLLOUTS B NESTED */ 	
_Rollouts_B_nested = _Rollout_B1.Rollouts slot:#Rollouts_B_nested
_Rollout_B1_nested = _Rollouts_B_nested.Roll ("Rollout B1 nested")



/* CREATE DIALOG */ 
Dialog.create()