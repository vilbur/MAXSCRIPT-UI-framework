clearListener()


clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Ini/Ini.ms" ) -- "./../../Ini/Ini.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Rollout/Rollout.ms" ) -- "./../../Dialog/Rollout/Rollout.ms"
filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog DIALOG_rollout )catch()


/** DEFINE UI
 *
 */
_RolloutCreator 	= RolloutCreator_v Ini:(Ini_v())

_Rollout = Rollout_v "Dialog Rollout" id:#DIALOG_rollout


Subrollouts = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts.Roll "Subrollout1"
--Subrollout_2 = Subrollouts.Roll "Subrollout2" id:#subrollout_2

--format "_Rollout     = % \n" _Rollout
--format "Subrollouts  = % \n" Subrollouts
--format "Subrollout_1 = % \n" Subrollout_1



/** CREATE UI
 *
 */
CreateDialog ( _RolloutCreator.createRollout _Rollout) width:256 height:256
--CreateDialog ( _RolloutCreator.createRollout Subrollout_1) width:256 height:256



_RolloutCreator.SubolloutsCreator.addSubRollouts _Rollout