filein( getFilenamePath(getSourceFileName()) + "/../../../../Dialog/DialogGlobal/DialogGlobal.ms" )	--"./../../../../Dialog/DialogGlobal/DialogGlobal.ms"

/*------------------------------------------------------------------------------

   Maxscript fires #RESIZED event when dialog is RESIZED and DOCKED\UNDOCKED

	waitForResizingEnds() waits while resizing event stops.
	
	
	then compare values of dialog states and found which event has been really fired



	DIAGRAM:
		
		  #DOCKED 	 🡶                                          🡵 #DOCKED
		  #RESIZED  🡲 #RESIZED 🡲 waitForResizingEnds()🡲 Fire: 🡲 #RESIZED
		  #UNDOCKED 🡵                                          🡵 #UNDOCKED
		  


--------------------------------------------------------------------------------*/

/** Check dialog POSITION, SIZE and STATE
  *
  * Find out type of event based on change of dialog states
  *
  */
function waitForResizingEnds sender evt =
(
	--format "\n"; print "DefaultEvents_v.waitForResizingEnds()"
	--format "CALLBACK_DELAY_TIMER: %\n" CALLBACK_DELAY_TIMER
	dialog_id	= DIALOG_GLOBAL_DATA[#ID_RESIZING_DIALOG]
	--format "dialog_id: %\n" dialog_id
	DataSaved	= DIALOG_GLOBAL_DATA[dialog_id]

	--format "DataSaved.dialog.title: %\n" DataSaved.dialog.title
	
	if DataSaved != undefined then 
	(
		format "\n"; print "DefaultEvents_v.waitForResizingEnds()"
		DataCurrent	= DialogGlobalData_v(DataSaved.DialogClass)
		--format "\n"
		--format "DataSaved.position:   %\n" DataSaved.position
		--format "DataCurrent.position: %\n" DataCurrent.position
		--format "\n"
		--format "DataSaved.size:   %\n" DataSaved.size
		--format "DataCurrent.size: %\n" DataCurrent.size
		--format "\n"
		--format "DataSaved.dock_state:   %\n" DataSaved.dock_state
		--format "DataCurrent.dock_state: %\n" DataCurrent.dock_state
		
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
		format "EVENT_TYPE: %\n" event_type
		format "DataSaved.Dialog.Events.keys: %\n" DataSaved.Dialog.Events.keys
		
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
		
					/* FIRE CALLBACK */ 
					execute(callback)
				)
			)
		)
	
		--DataSaved.fill() --return

		DIALOG_GLOBAL_DATA[dialog_id].fill() --return
	)
	

)
