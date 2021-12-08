clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/Dialog.ms" ) 

/*  Import callback methods
  
	CallbackNoParam()
	CallbackWithValue(val)
	CallbackWith2Params(arg_1) (arg_2)
*/ 

--include "Library/MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/EventsList/_Test/inlcude_test_callbacks.ms"

/*------ CREATE FLOAT    ER DIALOG ------*/
Dialog	= Dialog_v title:"Test" ini:(getFilenamePath(getSourceFileName()) + "2_DialogEventTest.ini") --load:true

/** Button test
 */
function CallbackNoParam =
(
	print "CallbackNoParam"

	--format "EventFired.control 	= % \nEventFired.type 	= % \n\n" EventFired.control EventFired.type
)

/** on value changed
 */
function CallbackWithValue val =
(
	print "CallbackWithValue"
	
	--format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type
	dialog_current_state = try(cui.getDockState ROLLOUT_Test)catch(false)
	--format "val 	= % \n" val
	--format "dialog_current_state	= % \n" dialog_current_state
	
	--format "EventFired 	= % \n\n" EventFired
)


/** on value changed
 */
function CallbackWith2Params arg_1 arg_2 =
(
	print "SpinnerEnteredTest"
	
	--format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type

	format "arg_1 	= % \narg_2  	= % \n" arg_1 arg_2

	format "EventFired 	= % \n\n" EventFired
)

/*  
	SET CUSTOM EVENTS
*/
--Dialog.Events.add #open	"CallbackNoParam()"
--Dialog.Events.add #close	"CallbackNoParam()"
Dialog.Events.add #moved	"CallbackWithValue(\"#moved\")"
Dialog.Events.add #resized	"CallbackWithValue(\"#resized\")"
Dialog.Events.add #docked	"CallbackWithValue(\"#docked\")"
--Dialog.Events.add #docked	"CallbackWithValue(val)"


--Dialog.Events.add #oktoclose	"CallbackNoParam()"
--
--Dialog.Events.add #lbuttondown	"CallbackWithValue(val)"


/* CREATE DIALOG */
Dialog.create()

Dialog.register()


--Dialog.dock #left

