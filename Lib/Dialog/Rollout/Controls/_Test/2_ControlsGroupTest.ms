clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator/RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_RolloutCreator = RolloutCreator_v()
_Rollout        = _RolloutCreator.new "Test"


/* CONTROLS IN GROUP */ 
_Controls = _Rollout.Controls group:"Controls 1"
_Button_1 = _Controls.control #button "Button 1" id:#button_1


/* CONTROLS WITHOUT GROUP */ 
_Controls = _Rollout.Controls()
_Button_2 = _Controls.control #button "Button 2" id:#button_2

/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)