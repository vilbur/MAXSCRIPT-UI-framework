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


_Nesteds  = _Subrollout_1.Subrollouts()
_Nested_1 = _Nesteds.new "Nested 1" id:#subrollout_nested_1
--_Nested_2 = _Nesteds.new "Nested 2" id:#subrollout_nested_2

--format "_Rollout      = % \n" _Rollout
--format "_Subrollout_1 = % \n" _Subrollout_1
--format "_Nested       = % \n" _Nested


/** CREATE ROLLOUT AND SUBROLLOUTS 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) height:256 width:256 

_RolloutCreator.addSubRollouts _Rollout

_RolloutCreator.addSubRollouts _Subrollout_1