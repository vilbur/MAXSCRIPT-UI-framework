/** Button test
 */
function CallbackNoParam =
(
	print "CallbackNoParam"

	format "EventFired.control 	= % \nEventFired.type 	= % \n\n" EventFired.control EventFired.type
)

/** on value changed
 */
function CallbackWithValue val =
(
	print "CallbackWithValue"
	
	format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type
	
	format "val 	= % \n" val
	
	format "EventFired 	= % \n\n" EventFired
)


/** on value changed
 */
function CallbackWith2Params arg_1 arg_2 =
(
	print "SpinnerEnteredTest"
	
	format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type

	format "arg_1 	= % \narg_2  	= % \n" arg_1 arg_2

	format "EventFired 	= % \n\n" EventFired
)