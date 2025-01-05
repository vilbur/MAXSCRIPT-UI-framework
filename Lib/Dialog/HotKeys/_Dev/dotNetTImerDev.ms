clearListener()

_timer	= dotNetObject "System.Windows.Forms.Timer"
timer_B	= dotNetObject "System.Windows.Forms.Timer"


/*------------------------------------------------------------------------------
	TIMER A
--------------------------------------------------------------------------------*/
counter = 1

/** Timer callback
 */
function timerCallbackA event =
(
	--format "\n"; print "timerCallbackA()"
	format "timerCallbackA	= % \n" counter
	format "event: %\n" event
	
	counter += 1
	
	if counter == 10 then 
		_timer.stop()
)


dotNet.addEventHandler _timer "tick" timerCallbackA

_timer.interval = 1000

_timer.start()