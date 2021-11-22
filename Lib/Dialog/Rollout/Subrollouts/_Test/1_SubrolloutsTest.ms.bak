clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Rollout.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_Rollout = Rollout_v title:"Test" id:"ROLLOUT_test"

Subrollouts = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts.new "Subrollout1" id:#subrollout_1
Subrollout_2 = Subrollouts.new "Subrollout2" id:#subrollout_2

format "_Rollout     = % \n" _Rollout
format "Subrollouts  = % \n" Subrollouts
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
	_RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:128")


_RolloutCreator.end()
CreateDialog (_RolloutCreator.def)



/** Create Subrollouts
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