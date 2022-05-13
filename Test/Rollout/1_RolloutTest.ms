clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))

/* ROLLOUTS */ 
_Rollouts_A  = Dialog.Rollouts()
_Rollouts_B  = Dialog.Rollouts()

_Rollout_A1 = _Rollouts_A.new "Rollout A1"
_Rollout_A2 = _Rollouts_A.new "Rollout A2"

_Rollout_B1 = _Rollouts_B.new "Rollout B1"
_Rollout_B2 = _Rollouts_B.new "Rollout B2"



/* SUBROLLOUTS */ 
Subrolllouts = _Rollout_A1.Rollouts()
_Subrolllout_1 = Subrolllouts.new "Subrollout 1"
 -- _Subrolllout_2 = Subrolllouts.new "Subrollout 2"

/* NESTED SUBROLLOUTS */ 
 -- Subrolllouts = _Subrolllout_1.Rollouts()
 -- _NestedRollout = Subrolllouts.new "Nested"


/* CREATE DIALOG */ 
Dialog.create()