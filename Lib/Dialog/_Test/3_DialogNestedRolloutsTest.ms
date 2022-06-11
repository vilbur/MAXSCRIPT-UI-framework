clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	    = Dialog_v title:"Test"


_Rollouts_1	  = Dialog.Rollouts()
_Rollouts_2	  = Dialog.Rollouts()

_Subrolllout_1 = _Rollouts_1.Roll "Subrollout A"
_Subrolllout_2 = _Rollouts_2.Roll "Subrollout B"


NesteRollouts = _Subrolllout_1.Rollouts()
NesteRollout  = NesteRollouts.Roll "Nested"


NestedNesteRollouts = NesteRollout.Rollouts()
NestedNesteRollout  = NestedNesteRollouts.Roll "Nested Nested"


Dialog.create()