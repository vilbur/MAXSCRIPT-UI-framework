clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../Rollout.ms" )

/*  Import callback methods
  
	CallbackNoParam()
	CallbackWithValue(val)
	CallbackWith2Params(arg_1) (arg_2)
*/ 
filein( getFilenamePath(getSourceFileName()) + "/../../../../Events/Test/inlcude_test_callbacks.ms" )



try(cui.UnRegisterDialogBar ROLLOUT_1_rollouteventtest)catch() --try to unregister if already registered
try(DestroyDialog  ROLLOUT_1_rollouteventtest)catch() --try to unregister if already registered

/** CREATE ROLLOUTS 
 *	
 */
_Rollout = Rollout_v title:(getFilenameFile(getSourceFileName()))

_Rollout.ini (getFilenamePath(getSourceFileName()) + "1_RolloutEventTest.ini")


SubRollouts = _Rollout.subrollouts()
Rollout_A    = SubRollouts.new "Subrollout A"



/*
	CHANGE DEFAULT EVENTS

	Rollout_A.Events.Events.setDefaultEvent ( Event_v type:"onOpen"	code:	"messagebox \"Default Event onOpen\"" )
	Rollout_A.Events.Events.setDefaultEvent ( Event_v type:"onClose"	code:	"messagebox \"Default Event onClose\"" )

*/

Rollout_A.Events.setEvent #rolledUp	"CallbackWithValue"
Rollout_A.Events.setEvent #rolledDown	"CallbackWithValue"



/* CREATE ROLLOUT */
_Rollout.createRollout()

/* CREATE DIALOG */
CreateDialog ( _Rollout.RolloutCreator.getDefinition() ) width:640 height:512

_Rollout.addSubRollouts() -- dialog must exist for adding subrollouts