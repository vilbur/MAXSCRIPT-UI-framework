clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	    = Dialog_v title:"Test"

_Rollouts_1	  = Dialog.Rollouts()
_Rollouts_2	  = Dialog.Rollouts()

_Subrolllout = _Rollouts_1.Roll "Subrollout A"
_Subrolllout = _Rollouts_2.Roll "Subrollout B"

Dialog.create()