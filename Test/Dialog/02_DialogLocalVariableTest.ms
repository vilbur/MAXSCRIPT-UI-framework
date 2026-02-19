clearListener(); print("Cleared in:\n"+getSourceFileName())

/** RolloutCreator_v
  *
  --* RolloutCreator: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

 */
filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* HELPERS */ 
struct TestSctruct
(
	test_prop = "DEFAULT VALUE"
)

/* DIALOG */
Dialog 	= Dialog_v title:"Test"


/*------------------------------------------------------------------------------
	ADD VARIABLES
--------------------------------------------------------------------------------*/
Dialog.addLocal #TestStruct (TestSctruct("CONSTRUCT VALUE"))

Dialog.addLocal  "prop_str"  "Line 1\n\"Line 2\"" -- String with newlines and quotes

Dialog.addLocal  "prop_array"  #("Item A", 2 ) -- Array with strings and quotes

Dialog.addLocal  "prop_color"  (color 255 128 0)
Dialog.addLocal  "prop_point"  [10, 20, 30]
Dialog.addLocal  #PROP_NUM 12
Dialog.addLocal  #PROP_STRUCT 12
Dialog.addLocal  #PROP_FLOAT 12.7


format "Dialog: %\n" Dialog
/*------------------------------------------------------------------------------
	 CREATE DIALOG
--------------------------------------------------------------------------------*/
dialog_rollout = Dialog.create()


/*------------------------------------------------------------------------------
	TEST OF RESULT
--------------------------------------------------------------------------------*/
format "classOf TestSctruct: %\n" ( classOf (TestSctruct()) )

format "DIALOG_test.TestSctruct: %\n\n"	(classof DIALOG_test.TestSctruct)
format "DIALOG_test.TestSctruct.test_prop: %\n\n"	(classof DIALOG_test.TestSctruct.test_prop)
--
--format "DIALOG_test.prop_str: %\n\n"	(classof DIALOG_test.prop_str)
--format "DIALOG_test.prop_num: %\n\n"	(classof DIALOG_test.prop_num)
--format "DIALOG_test.prop_float: %\n\n"	(classof DIALOG_test.prop_float)
--
--format "DIALOG_test.prop_array: %\n\n"	(classof DIALOG_test.prop_array)
--
--format "DIALOG_test.prop_color: %\n\n"	(classof DIALOG_test.prop_color)
--format "DIALOG_test.prop_point: %\n\n"	(classof DIALOG_test.prop_point)
--
--
