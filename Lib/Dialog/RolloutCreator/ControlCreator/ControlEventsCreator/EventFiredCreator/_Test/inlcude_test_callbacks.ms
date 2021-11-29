/** Button test
 */
function CallbackNoParam =
(
	print "CallbackNoParam"

	--format "EventFired.control 	= % \nEventFired.type 	= % \n\n" EventFired.control EventFired.type
	
	format "EventFired 	= % \n\n" EventFired

)

/** on value changed
 */
function CallbackWithValue val =
(
	print "CallbackWithValue"
	
	--format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type
	
	--format "val 	= % \n" val
	
	format "EventFired 	= % \n\n" EventFired
)


/** on value changed
 */
function CallbackWith2Params param_1 param_2 =
(
	print "SpinnerEnteredTest"
	
	format "EventFired.control 	= % \nEventFired.type 	= % \n" EventFired.control EventFired.type

	format "param_1 	= % \nparam_2  	= % \n" param_1 param_2

	format "EventFired 	= % \n\n" EventFired
)