clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */

_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.Roll "Test"

Subrollouts = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts.Roll "Subrollout1"
Subrollout_2 = Subrollouts.Roll "Subrollout2" id:#subrollout_2

--format "_Rollout     = % \n" _Rollout
--format "Subrollouts  = % \n" Subrollouts
--format "Subrollout_1 = % \n" Subrollout_1

/** CREATE UI 
 *	
 */

_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)

_RolloutCreator.addSubRollouts _Rollout