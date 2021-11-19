clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()

/** DEFINE UI 
 *	
 */

_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test" id:#ROLLOUT_test


/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout()

CreateDialog (_RolloutCreator.getDefinition())