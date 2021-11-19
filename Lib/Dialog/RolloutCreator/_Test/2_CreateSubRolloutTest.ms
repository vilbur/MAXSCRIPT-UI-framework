clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */

_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test" id:#ROLLOUT_test

Subrollouts = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts.new "Subrollout1" id:#subrollout_1
--Subrollout_2 = Subrollouts.new "Subrollout2" id:#subrollout_2
--
format "_Rollout     = % \n" _Rollout
--format "Subrollouts  = % \n" Subrollouts
--format "Subrollout_1 = % \n" Subrollout_1

/** CREATE UI 
 *	
 */

_RolloutCreator.createRollouts()

CreateDialog (_RolloutCreator.getDefinition())

--Controls = _Rollout.Controls.new "Controls1"

--CreateDialog (_RolloutCreator.getDefinition())


_RolloutCreator.addSubRollouts()


--/** Create Subrollouts
-- *	
-- */
--for _Subrollouts in _Rollout._Controls do
--(	
--	for _Subrollout in _Subrollouts.Rollouts do
--	(
--		--format "_Subrollout	= % \n" _Subrollout
--		_SubRolloutCreator = rolloutCreator (_Subrollout.id) (_Subrollout.title)
--		_SubRolloutCreator.begin()
--		_SubRolloutCreator.end()
--		
--		execute ( "\n AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot as string + " "+ _Subrollout.id )
--	)	
--)