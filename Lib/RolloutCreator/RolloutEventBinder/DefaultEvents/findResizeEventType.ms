filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/DialogGlobal/DialogGlobal.ms" )	-- "./../../../Dialog/DialogGlobal/DialogGlobal.ms"


/*------------------------------------------------------------------------------

   Maxscript fires #resized event when dialog is resized and docked\undocked

	findResizeEventType() Waits while event is stoped to be fired
	then compare values of dialog states and found which event has been really fired


--------------------------------------------------------------------------------*/


global CALLBACK_DELAY_TIMER

if DIALOG_GLOBAL_DATA == undefined then
	global DIALOG_GLOBAL_DATA = Dictionary()

/**
  *
  * Check dialog position, size and state
  * Find out type of event based on change of dialog states
  */
function findResizeEventType sender evt =
(
	--format "\n"; print "DefaultEvents_v.findResizeEventType()"
	dialog_id	= DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]

	DataSaved	= DIALOG_GLOBAL_DATA[dialog_id]
	DataCurrent	= DialogGlobalData_v(DataSaved.DialogClass)


	if DataSaved.Dialog.Events.list.count == 0 then
		return false

	event_type = case of
	(
		(DataSaved.dock_state	!= DataCurrent.dock_state):	if DataCurrent.dock_state == #CUI_FLOATABLE then #UNDOCKED else #DOCKED
		(DataSaved.size	== DataCurrent.size):	#RESIZED

		default: undefined
	)

	if event_type != undefined then
	(
		sender.enabled = false

		dotNet.removeEventHandler sender "Elapsed" PerformDelayedTasks

		CALLBACK_DELAY_TIMER = undefined

		print ( toUpper(event_type as string ) ) -- DEV

		/* FIRE CUSTOM EVENT */
		if ( Event = DataSaved.Dialog.Events.get(event_type) ) != undefined then
			execute(Event.code)


	)


	DataSaved.fill()
)


/**
  *
  */
function startResizeEventTimer dialog_id event_type =
(
	--format "\n"; print "DefaultEvents_v.startResizeEventTimer()"

	if CALLBACK_DELAY_TIMER == undefined then
	(
		CALLBACK_DELAY_TIMER = dotNetObject "Windows.Forms.Timer"

		CALLBACK_DELAY_TIMER.Interval = 250

		dotNet.addEventHandler CALLBACK_DELAY_TIMER "Tick" findResizeEventType

		CALLBACK_DELAY_TIMER.enabled = true

		DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]	= dialog_id

	)

)
