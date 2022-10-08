clearListener()

timer_A	= dotNetObject "System.Windows.Forms.Timer"
timer_B	= dotNetObject "System.Windows.Forms.Timer"


/*------------------------------------------------------------------------------
	TIMER A
--------------------------------------------------------------------------------*/
_time_A = 1

/** Timer callback
 */
function timerCallbackA =
(
	--format "\n"; print "timerCallbackA()"
	format "timerCallbackA	= % \n" _time_A
	
	_time_A += 1
	
	if _time_A == 10 then 
		timer_A.stop()
)


dotNet.addEventHandler timer_A "tick" timerCallbackA

timer_A.interval = 1000

timer_A.start()



/*------------------------------------------------------------------------------
	TIMER B
--------------------------------------------------------------------------------*/
_time_B = 1

/** Timer callback
 */
function timerCallbackB =
(
	--format "\n"; print "timerCallbackA()"
	format "timerCallbackA	= % \n" _time_B
	
	_time_B += 1
	
	if _time_B == 10 then 
		timer_B.stop()
)


dotNet.addEventHandler timer_B "tick" timerCallbackB

timer_B.interval = 1000

timer_B.start()