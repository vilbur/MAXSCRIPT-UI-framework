clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../RolloutCreator.ms" )


try(cui.UnRegisterDialogBar ROLLOUT_test)catch() 
try( destroyDialog          ROLLOUT_test )catch()



/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()
_RolloutCreator.Ini.setIni (getSourceFileName())

_Rollout = _RolloutCreator.new "Test"


Subrollouts_1 = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts_1.new "Subrollout1"

/* DIALOG EVENTS */ 
_Rollout.Events.add #open   "print \"Open \""
_Rollout.Events.add #close  "print \"Close\""


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
--format "_Rollout	= % \n" _Rollout
_RolloutCreator.addSubRollouts _Rollout

cui.RegisterDialogBar ROLLOUT_test style:#( #cui_dock_all, #cui_floatable, #style_resizing )
--cui.RegisterDialogBar ROLLOUT_test style:#( #cui_floatable, #style_resizing )