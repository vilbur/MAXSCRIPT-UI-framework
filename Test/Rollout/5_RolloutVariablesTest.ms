clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"



/* DIALOG */ 
Dialog 	= Dialog_v title:"Test rollout"

/* ASSIGN VARIABLE  */ 
Dialog.RolloutMain.addlocal ( #TEST_VAR ) ("TEST_VALUE")


/* CREATE DIALOG */ 
 Dialog.create()


format "test_rollout.TEST_VAR	= % \n" test_rollout.TEST_VAR