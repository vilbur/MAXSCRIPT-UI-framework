filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/DialogGlobal/DialogGlobal.ms" )	--"./../../../../Dialog/DialogGlobal/DialogGlobal.ms"

/*------------------------------------------------------------------------------

   Maxscript fires #resized event when dialog is resized and docked\undocked

	fitSubrolloutSlotToRolloutCallback() Waits while event is stoped to be fired
	then compare values of dialog states and found which event has been really fired

--------------------------------------------------------------------------------*/

/** Check dialog POSITION, SIZE and STATE
  *
  * Find out type of event based on change of dialog states
  *
  */
function fitSubrolloutSlotToRolloutCallback sender evt =
(
	--format "\n"; print "DefaultEvents_v.fitSubrolloutSlotToRolloutCallback()"
	dialog_id	= DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]

	DataSaved	= DIALOG_GLOBAL_DATA[dialog_id]
	DataCurrent	= DialogGlobalData_v(DataSaved.DialogClass)

	/*------------------------------------------------------------------------------
		FIND EVENT TYPE
	--------------------------------------------------------------------------------*/
	
	event_type = case of
	(
		(DataSaved.dock_state	!= DataCurrent.dock_state):	if DataCurrent.dock_state == #CUI_FLOATABLE then #UNDOCKED else #DOCKED
		(DataSaved.size	== DataCurrent.size):	#RESIZED

		default: undefined
	)

	
	/*------------------------------------------------------------------------------
		PROCESS CALLBACK
	--------------------------------------------------------------------------------*/
	
	if event_type != undefined then
	(
		/* FIT SUBROLLOUTS IN DIALOG */ 
		DataSaved.Dialog.RolloutResizer.fitSlotsToDialog(DataSaved.DialogClass) --"./../../../../Dialog/Rollout/RolloutResizer/RolloutResizer.ms"

		/* STOP TIMER */ 
		sender.enabled = false

		dotNet.removeEventHandler sender "Elapsed" PerformDelayedTasks

		CALLBACK_DELAY_TIMER = undefined

		--print ( "DefaultEvents_v.fitSubrolloutSlotToRolloutCallback()\n" + toUpper(event_type as string ) ) -- DEV

		/* FIRE CUSTOM EVENT */
		if ( Event = DataSaved.Dialog.Events[event_type] ) != undefined then
			execute(Event.callback)
	)

	DataSaved.fill() --return
)
