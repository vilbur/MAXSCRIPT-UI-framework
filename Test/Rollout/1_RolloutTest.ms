clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))

/*
	ROLLOUTS A 
 */ 
_Rollouts_A  = Dialog.Rollouts()
_Rollouts_A.height = 512

_Rollout_A1 = _Rollouts_A.new "Rollout A1"
-- _Rollout_A2 = _Rollouts_A.new "Rollout A2"



/*
	ROLLOUTS B 
 */ 
_Rollouts_B  = Dialog.Rollouts()

_Rollout_B1 = _Rollouts_B.new "Rollout B1"
-- _Rollout_B2 = _Rollouts_B.new "Rollout B2"

/* SUBROLLOUTS */ 
-- Subrolllouts = _Rollout_B1.Rollouts()
-- _Subrolllout_B1 = Subrolllouts.new "Subrollosut B1"
-- _Subrolllout_B1 = Subrolllouts.new "Subrollout B2"

/* NESTED SUBROLLOUTS */ 
-- NestedSubrolllouts = _Subrolllout_B1.Rollouts()
-- _NestedRollout = NestedSubrolllouts.new "Nested A1"


/*
	ROLLOUTS C 
 */ 
_Rollouts_C  = Dialog.Rollouts()
_Rollout_C1 = _Rollouts_C.new "Rollout C1"








/* CREATE DIALOG */ 
Dialog.create()