clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	= Dialog_v title:"Test"


_Rollouts	= Dialog.Rollouts()


_Subrolllout = _Rollouts.new "Subrollout A"
--_SubrollloutB = _Rollouts.new "Subrollout B"


--_Subrolllout.createRollout()



Dialog.create()

AddSubRollout ROLLOUT_Test.slot_1 ROLLOUT_Subrollout_A
