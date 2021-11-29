clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator/RolloutCreator.ms" )

try(cui.UnRegisterDialogBar ROLLOUT_test)catch() 
try( destroyDialog          ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"


Subrollouts_1 = _Rollout.Subrollouts()
--Subrollouts_2 = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts_1.new "Subrollout1"

/* DIALOG EVENTS */ 
_Rollout.Events.add #open   "print \"Open\""
_Rollout.Events.add #close  "print \"Close\""

/** ! KNOWING ISSUES
  * #docked event is bind to moved handler in RolloutEvents_v._getCallback()
  *
  * #docked does not work without moved event now
  *
 */
_Rollout.Events.add #moved  "print \"Moved\""
_Rollout.Events.add #docked "print \"Docked\""


/* ROLlOUT EVENTS */ 
Subrollout_1.Events.add #rolledUp   "print \"RolledUp\""
Subrollout_1.Events.add #rolledDown "print \"RolledDown\""


/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)

_RolloutCreator.addSubRollouts _Rollout

cui.RegisterDialogBar ROLLOUT_test style:#( #cui_dock_all, #cui_floatable )