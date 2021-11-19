clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog.ms" )


/*  Import callback methods
  
	CallbackNoParam()
	CallbackWithValue(val)
	CallbackWith2Params(arg_1) (arg_2)
*/ 
filein( getFilenamePath(getSourceFileName()) + "/../../../../Events/Test/inlcude_test_callbacks.ms" )


/*------ CREATE FLOATER DIALOG ------*/
Dialog	= Dialog_v title:(getFilenameFile(getSourceFileName()))

Dialog.ini (getFilenamePath(getSourceFileName()) + "2_DialogEventTest.ini") load:true



/*
	SET CUSTOM EVENTS
*/
--Dialog.Events.setEvent #open	"CallbackNoParam()"
--Dialog.Events.setEvent #close	"CallbackNoParam()"
--Dialog.Events.setEvent #moved	"CallbackWithValue(val)"
--Dialog.Events.setEvent #resized	"CallbackWithValue(val)"
--Dialog.Events.setEvent #docked	"CallbackWithValue(val)"
--
--
--Dialog.Events.setEvent #oktoclose	"CallbackNoParam()"
--
--Dialog.Events.setEvent #lbuttondown	"CallbackWithValue(val)"


/* CREATE DIALOG */
Dialog.create()

Dialog.register()


--Dialog.dock #left

