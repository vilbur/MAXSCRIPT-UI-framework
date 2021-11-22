clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../RolloutCreator.ms" )

/*  Import callback methods
  
	CallbackNoParam()
	CallbackWithValue(val)
	CallbackWith2Params(arg_1) (arg_2)
*/ 
--filein( getFilenamePath(getSourceFileName()) + "/../../../../Events/Test/inlcude_test_callbacks.ms" )



try(cui.UnRegisterDialogBar ROLLOUT_test)catch() 
try( destroyDialog          ROLLOUT_test )catch()



/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()
_RolloutCreator.Ini.setIni (getSourceFileName())

_Rollout = _RolloutCreator.new "Test"


Subrollouts_1 = _Rollout.Subrollouts()
--Subrollouts_2 = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts_1.new "Subrollout1"

/* DIALOG EVENTS */ 
_Rollout.Events.add #open   "print \"Open\""
_Rollout.Events.add #close  "print \"Close\""


--_Rollout.Events.add #moved  "print \"Moved\""
--_Rollout.Events.add #docked "print \"Docked\""
--
--
--/* ROLlOUT EVENTS */ 
--Subrollout_1.Events.add #rolledUp   "print \"RolledUp\""
--Subrollout_1.Events.add #rolledDown "print \"RolledDown\""


/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)

_RolloutCreator.addSubRollouts _Rollout

cui.RegisterDialogBar ROLLOUT_test style:#( #cui_dock_all, #cui_floatable )