clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	    = Dialog_v title:"Test"


_Rollouts	  = Dialog.Rollouts()
_Subrolllout = _Rollouts.new "Subrollout"


NesteRollouts = _Subrolllout.Rollouts()
NesteRollout  = NesteRollouts.new "Nested"

Dialog.create()