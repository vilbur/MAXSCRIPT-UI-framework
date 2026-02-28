filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/DialogGlobal/DialogGlobal.ms" )	--"./../../../../Dialog/DialogGlobal/DialogGlobal.ms"

/*------------------------------------------------------------------------------

   Maxscript fires #RESIZED event when dialog is RESIZED and DOCKED\UNDOCKED

	waitForResizingEnds() waits while resizing event stops.
	
	
	then compare values of dialog states and found which event has been really fired

--------------------------------------------------------------------------------*/

/** Check dialog POSITION, SIZE and STATE
  *
  * Find out type of event based on change of dialog states
  *
  */
function waitForResizingEnds sender evt =
(
	format "\n"; print "DefaultEvents_v.waitForResizingEnds()"
	dialog_id	= DIALOG_GLOBAL_DATA[#ID_RESIZING_DIALOG]

	DataSaved	= DIALOG_GLOBAL_DATA[dialog_id]
	
	if DataSaved != undefined then 
	(
		
		DataCurrent	= DialogGlobalData_v(DataSaved.DialogClass)

		--format "DataCurrent: %\n" DataCurrent
	
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

		--print ( "DefaultEvents_v.waitForResizingEnds()\n" + toUpper(event_type as string ) ) -- DEV

		/* FIRE CUSTOM EVENT */
		if ( Events = DataSaved.Dialog.Events[event_type] ) != undefined then
		(
			for Event in Events do
			(
				/* REPLACE @ WITH \" */ 
				callback = substituteString Event.callback "@" "\""
	
				/* FIRE UP CALLBACK */ 
				execute(callback)
			)
		)
	)

	DataSaved.fill() --return
	)
)
