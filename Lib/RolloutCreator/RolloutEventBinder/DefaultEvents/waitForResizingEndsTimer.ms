global CALLBACK_DELAY_TIMER

/**  START timer and wait then user stop resizing in:
		
		--"./Callbacks/waitForResizingEnds.ms"
  *
  */
function waitForResizingEndsTimer dialog_id event_type =
(
	--format "\n"; print "DefaultEvents_v.waitForResizingEndsTimer()"
	
	/*------------------------------------------------------------------------------
		INTERVAL VALUE - for check rollout size 
	--------------------------------------------------------------------------------*/
	
	timer_interval = 500 -- miliseconds
	
	
	/* START TIMER IF NOT RUNNING ALREADY */ 
	if CALLBACK_DELAY_TIMER == undefined then
	(
		CALLBACK_DELAY_TIMER = dotNetObject "Windows.Forms.Timer"
		
		CALLBACK_DELAY_TIMER.Interval = timer_interval

		dotNet.addEventHandler CALLBACK_DELAY_TIMER "Tick" waitForResizingEnds --"./Callbacks/waitForResizingEnds.ms"

		CALLBACK_DELAY_TIMER.enabled = true

		DIALOG_GLOBAL_DATA[#ID_RESIZING_DIALOG]	= dialog_id
	)

)