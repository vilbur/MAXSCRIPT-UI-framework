filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/DialogGlobal/DialogGlobal.ms" )	-- "./../../../Dialog/DialogGlobal/DialogGlobal.ms"


/*------------------------------------------------------------------------------

   Maxscript fires #resized event when dialog is resized and docked\undocked

	fitSubrolloutSlotToRolloutCallback() Waits while event is stoped to be fired
	then compare values of dialog states and found which event has been really fired


--------------------------------------------------------------------------------*/

/**
  *
  * Check dialog position, size and state
  * Find out type of event based on change of dialog states
  */
function fitSubrolloutSlotToRolloutCallback sender evt =
(
	--format "\n"; print "DefaultEvents_v.fitSubrolloutSlotToRolloutCallback()"
	dialog_id	= DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]

	DataSaved	= DIALOG_GLOBAL_DATA[dialog_id]
	DataCurrent	= DialogGlobalData_v(DataSaved.DialogClass)

	--format "DataCurrent.size:	% \n" DataCurrent.size
	--format "DataSaved.size:	% \n" DataSaved.size

	--if DataSaved.Dialog.Events.list.count > 0 then
	(
		event_type = case of
		(
			(DataSaved.dock_state	!= DataCurrent.dock_state):	if DataCurrent.dock_state == #CUI_FLOATABLE then #UNDOCKED else #DOCKED
			(DataSaved.size	== DataCurrent.size):	#RESIZED

			default: undefined
		)

		if event_type != undefined then
		(

			DataSaved.Dialog.RolloutResizer.fitSlotsToDialog(DataSaved.DialogClass)

			sender.enabled = false

			dotNet.removeEventHandler sender "Elapsed" PerformDelayedTasks

			CALLBACK_DELAY_TIMER = undefined

			print ( toUpper(event_type as string ) ) -- DEV

			/* FIRE CUSTOM EVENT */
			if ( Event = DataSaved.Dialog.Events.get(event_type) ) != undefined then
				execute(Event.callback)

		)
	)

	DataSaved.fill()
)
