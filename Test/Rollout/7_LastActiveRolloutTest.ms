clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"



/* DIALOG */ 
Dialog	= Dialog_v title:"Test rollout" DEBUG:true
slot	= Dialog.Rollouts slot:#subrollouts
_rollout	= slot.Roll "Rollout A" height:256



/* DIALOG VARIABLE */ 
--Dialog.addlocal ( #DIALOG_VARIABLE ) ("DIALOG_TEST_VALUE")

/* ROLLOUT VARIABLE */ 
_rollout.addlocal ( #ROLLOUT_VARIABLE ) ("ROLLOUT_TEST_VALUE")


/* CREATE DIALOG */ 
Dialog.create()


format "\n-------------------- TEST RESULTS --------------------\n\n"

format "DIALOG_VARIABLE  = % \n" DIALOG_test_rollout.DIALOG_VARIABLE

format "ROLLOUT_VARIABLE = % \n" DIALOG_test_rollout.subrollouts.rollout_a.ROLLOUT_VARIABLE