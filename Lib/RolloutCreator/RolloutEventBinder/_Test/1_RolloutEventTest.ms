clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../RolloutCreator.ms" )



/** Create variables:
  *		_RolloutCreator
  *		_Rollout
  *		_Controls
  */
include "Library/MAXSCRIPT-UI-framework/Lib/RolloutCreator/_Test/includes/CreateTestRollout.ms"

_RolloutCreator.Ini.setIni (getSourceFileName())

Subrollouts_1	= _Rollout.Subrollouts()
Subrollout_1	= Subrollouts_1.new "Subrollout1"

/* DIALOG EVENTS */ 
_Rollout.Events.add #open   "print \"#Open \""
_Rollout.Events.add #close  "print \"#Close\""


_Rollout.Events.add #moved 	"print \"#Moved\""
_Rollout.Events.add #resized	"print \"#Resized\""
_Rollout.Events.add #docked	"print \"#Docked\""


/* ROLlOUT EVENTS */ 
Subrollout_1.Events.add #rolledUp   "print \"#RolledUp\""
Subrollout_1.Events.add #rolledDown "print \"#RolledDown\""
	


/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)
--format "_Rollout	= % \n" _Rollout
_RolloutCreator.addSubRollouts _Rollout

print "--- REGISTER ---"
cui.RegisterDialogBar ROLLOUT_test style:#( #cui_dock_all, #cui_floatable, #style_resizing )
