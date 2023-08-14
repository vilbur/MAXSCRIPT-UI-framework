global CALLBACK_DELAY_TIMER


/** Check dialog position, size and state
  * Find out type of event based on change of dialog states
  */
function findResizeEventType sender evt =
(
	--format "\n"; print "DefaultEvents_v.findResizeEventType()"

	dialog_id	= DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]
	event_type	= DIALOG_GLOBAL_DATA[#RUNNING_EVENT_TYPE]

	DataSaved	= DIALOG_GLOBAL_DATA[dialog_id]
	DataCurrent	= DialogGlobalData_v(DataSaved.Dialog)

	--format "DataSaved:	% \n" DataSaved.size
	--format "DataCurrent:	% \n" DataCurrent.size
	--
	--format "\n"
	--format "\n"
	--format "DataSaved:   % \n" DataSaved.dock_state
	--format "DataCurrent: % \n" DataCurrent.dock_state
	--format "\n"
	--format "TEST:        % \n" (DataSaved.dock_state	!= DataCurrent.dock_state)

	--format "event_type:	% \n" event_type
	--format "Dialog:	% \n" Dialog
	--dock_state = (try(cui.getDockState _Rollout )catch())


	result = case of
	(
		(DataSaved.dock_state	!= DataCurrent.dock_state):	if DataCurrent.dock_state == #CUI_FLOATABLE then #UNDOCKED else #DOCKED
		(DataSaved.size	== DataCurrent.size):	#RESIZED

		default: false
	)

	if result != false then
	(
		DataSaved.fillDockState()

		sender.enabled = false

		dotNet.removeEventHandler sender "Elapsed" PerformDelayedTasks

		CALLBACK_DELAY_TIMER = undefined

		print ( result as string )
	)


	--DataSaved.fill()
	DataSaved.fillPosition()
	DataSaved.fillSize()

)


/** start dotnet timer
  */
function startResizeEventTimer dialog_id event_type =
(
	--format "\n"; print "DefaultEvents_v.startResizeEventTimer()"

	if CALLBACK_DELAY_TIMER == undefined then
	(
		CALLBACK_DELAY_TIMER = dotNetObject "Windows.Forms.Timer"

		CALLBACK_DELAY_TIMER.Interval = 500

		dotNet.addEventHandler CALLBACK_DELAY_TIMER "Tick" findResizeEventType

		CALLBACK_DELAY_TIMER.enabled = true

		DIALOG_GLOBAL_DATA[#RUNNING_EVENT_TYPE]	= event_type
		DIALOG_GLOBAL_DATA[#RUNNING_EVENT_DIALOG_ID]	= dialog_id

	)

)
