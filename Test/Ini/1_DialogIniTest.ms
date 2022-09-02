clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())

/* ROLLOUTS */ 
_Rollouts  = Dialog.Rollouts()

_Rollout_1 = _Rollouts.roll "Rollout 1"
-- _Rollout_2 = _Rollouts.roll "Rollout 2"
-- _Rollout_3 = _Rollouts.roll "Rollout 3"

-- _Controls = _Rollout_1.Controls group:"Test"

-- /* SUBROLLOUTS */ 
 -- Subrolllouts = _Rollout_1.Rollouts()
 -- _Subrolllout_1 = Subrolllouts.roll "Subrollout 1"
 -- _Subrolllout_2 = Subrolllouts.roll "Subrollout 2"

-- /* NESTED SUBROLLOUTS */ 
 -- Subrolllouts = _Subrolllout_1.Rollouts()
 -- _NestedRollout = Subrolllouts.roll "Nested"


/* CREATE DIALOG */ 
Dialog.create()
Dialog.register()