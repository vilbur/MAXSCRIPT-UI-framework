clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Ini/Ini.ms" ) -- "./../../Ini/Ini.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Rollout/Rollout.ms" ) -- "./../../Dialog/Rollout/Rollout.ms"
filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI
 *
 */
_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())

 _Rollout = Rollout_v "Test"


/** CREATE UI
 *
 */
CreateDialog ( _RolloutCreator.createRollout _Rollout) width:256 height:256