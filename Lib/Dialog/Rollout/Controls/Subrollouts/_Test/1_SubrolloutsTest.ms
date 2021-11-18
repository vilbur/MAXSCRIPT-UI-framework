clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Rollout.ms" )

try( destroyDialog ROLLOUT_test )catch()


_Rollout 	= Rollout_v title:"Test"

_Subrolllouts = _Rollout.Controls.subrollouts()

_Subrolllout = _Subrolllouts.new "Subrollout A"
_SubrollloutB = _Subrolllouts.new "Subrollout B"


_Rollout.createRollout()
_Subrolllout.createRollout()


CreateDialog (_Rollout._RolloutCreator.def)


AddSubRollout ROLLOUT_Test.slot_1 ROLLOUT_Subrollout_A