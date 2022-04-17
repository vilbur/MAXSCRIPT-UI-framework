clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls()

_Button_1 = _Controls.control #button "Button 1" id:#button_1 params:#( #tooltip, "Test Tooltip")


/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)