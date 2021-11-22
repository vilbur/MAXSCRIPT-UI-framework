clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Rollout.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_Rollout = Rollout_v title:"Test"

Subrollouts_1 = _Rollout.Subrollouts()
Subrollouts_2 = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts_1.new "Subrollout1" id:#subrollout_1
Subrollout_2 = Subrollouts_2.new "Subrollout2" id:#subrollout_2

format "_Rollout     = % \n" _Rollout
format "Subrollouts_1  = % \n" Subrollouts_1
format "Subrollout_1 = % \n" Subrollout_1


/** CREATE MAIN ROLLOUT 
 *	
 */
_RolloutCreator = rolloutCreator (_Rollout.id) (_Rollout.title)
_RolloutCreator.begin()

/** Add slots 
 *	
 */
for _Subrollouts in _Rollout._Controls do
	_RolloutCreator.addText ("subRollout "+_Subrollouts.slot as string +" \"slot_name\" height:128")


_RolloutCreator.end()
CreateDialog (_RolloutCreator.def)



/** Create Subrollouts_1
 *	
 */
for _Subrollouts in _Rollout._Controls do
(	
	for _Subrollout in _Subrollouts.Rollouts do
	(
		_SubRolloutCreator = rolloutCreator (_Subrollout.id) (_Subrollout.title)
		_SubRolloutCreator.begin()
		_SubRolloutCreator.end()

		execute ( "\n AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot as string + " "+ _Subrollout.id )
	)	
)