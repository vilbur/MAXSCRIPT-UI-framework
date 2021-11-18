clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Rollout.ms" )

try( destroyDialog ROLLOUT_test )catch()

_Rollout 	= Rollout_v title:"Test"

_Rollout.createRollout()

CreateDialog (_Rollout._RolloutCreator.def)
