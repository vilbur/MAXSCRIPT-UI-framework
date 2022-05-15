clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())

/* ROLLOUTS */ 
_Rollouts  = Dialog.Rollouts()

_Rollout_1 = _Rollouts.new "Rollout 1"
-- _Rollout_2 = _Rollouts.new "Rollout 2"
-- _Rollout_3 = _Rollouts.new "Rollout 3"

-- _Controls = _Rollout_1.Controls group:"Test"

-- /* SUBROLLOUTS */ 
 -- Subrolllouts = _Rollout_1.Rollouts()
 -- _Subrolllout_1 = Subrolllouts.new "Subrollout 1"
 -- _Subrolllout_2 = Subrolllouts.new "Subrollout 2"

-- /* NESTED SUBROLLOUTS */ 
 -- Subrolllouts = _Subrolllout_1.Rollouts()
 -- _NestedRollout = Subrolllouts.new "Nested"


/* CREATE DIALOG */ 
Dialog.create()