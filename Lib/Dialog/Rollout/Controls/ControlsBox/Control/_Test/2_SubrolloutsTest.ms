clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../Rollout.ms" )

try( destroyDialog ROLLOUT_test )catch()


Rollout 	= Rollout_v title:"Test"

_Subrolllouts = Rollout.Controls.subrollouts()

_Subrolllout = _Subrolllouts.new "Subrollout A"
_SubrollloutB = _Subrolllouts.new "Subrollout B"



Rollout.createRollout()
_Subrolllout.createRollout()


CreateDialog (Rollout._RolloutCreator.def)


AddSubRollout ROLLOUT_Test.slot_1 ROLLOUT_Subrollout_A