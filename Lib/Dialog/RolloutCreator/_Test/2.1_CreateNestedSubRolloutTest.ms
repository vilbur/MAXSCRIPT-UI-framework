clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */

_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test" id:#ROLLOUT_test

Subrollouts = _Rollout.Subrollouts()

_Subrollout_1 = Subrollouts.new "Subrollout1" id:#subrollout_1
--_Subrollout_2 = Subrollouts.new "Subrollout2" id:#subrollout_2


_Nesteds = _Subrollout_1.Subrollouts()
_Nested  = _Nesteds.new "Nested" id:#subrollout_nested

format "_Rollout      = % \n" _Rollout
format "_Subrollout_1 = % \n" _Subrollout_1
format "_Nested       = % \n" _Nested

/** CREATE UI 
 *	
 */

_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) height:256 width:256 

--_RolloutCreator.addSubRollouts()
_RolloutCreator.addSubRollouts _Rollout


_RolloutCreator.addSubRollouts _Subrollout_1