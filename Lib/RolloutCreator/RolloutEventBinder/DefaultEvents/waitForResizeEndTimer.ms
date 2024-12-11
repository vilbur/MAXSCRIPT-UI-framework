

global CALLBACK_DELAY_TIMER



/**
  *
  */
function waitForResizeEndTimer dialog_id event_type =
(
	--format "\n"; print "DefaultEvents_v.waitForResizeEndTimer()"

	if CALLBACK_DELAY_TIMER == undefined then
	(
		CALLBACK_DELAY_TIMER = dotNetObject "Windows.Forms.Timer"

		--CALLBACK_DELAY_TIMER.Interval = 250
		CALLBACK_DELAY_TIMER.Interval = 500

		dotNet.addEventHandler CALLBACK_DELAY_TIMER "Tick" fitSubrolloutSlotToRolloutCallback

		CALLBACK_DELAY_TIMER.enabled = true

		DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]	= dialog_id
	)

)