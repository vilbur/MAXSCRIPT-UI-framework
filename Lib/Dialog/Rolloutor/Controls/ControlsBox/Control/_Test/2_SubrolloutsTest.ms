clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../Rolloutor.ms" )

try( destroyDialog ROLLOUT_test )catch()


Rolloutor 	= Rolloutor_v title:"Test"

_Subrolllouts = Rolloutor.Controls.subrollouts()

_Subrolllout = _Subrolllouts.new "Subrollout A"
_SubrollloutB = _Subrolllouts.new "Subrollout B"



Rolloutor.createRollout()
_Subrolllout.createRollout()


CreateDialog (Rolloutor._RolloutCreator.def)


AddSubRollout ROLLOUT_Test.slot_1 ROLLOUT_Subrollout_A