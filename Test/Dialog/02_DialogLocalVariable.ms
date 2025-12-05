wclearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

struct Test_v
(
	test_prop = "DEFAULT VALUE"
)

/* DIALOG */
Dialog 	= Dialog_v title:"Test X"

Dialog.addLocal "TestStruct" "Test_v(\"CONSTRUCT VALUE\")"


/*------------------------------------------------------------------------------
	 CREATE DIALOG
--------------------------------------------------------------------------------*/
dialog = Dialog.create()

format "dialog.TestStruct: %\n" dialog.TestStruct.test_prop
