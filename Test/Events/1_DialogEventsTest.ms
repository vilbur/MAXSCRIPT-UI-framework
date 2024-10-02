clearListener(); print("Cleared in:"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

--try( destroyDialog ROLLOUT_test )catch()
/* SET DIALOG */
--global DialogTest 	= Dialog_v title:"Test"
global DialogTest 	= Dialog_v title:"Test" ini:(getSourceFileName())


/** Dialog rollout callback
 */
function dialogRolloutCallback =
(
	format "\n"; print ".dialogRolloutCallback()"
	--format "EventFired: %\n" EventFired
)

/** Dialog rollout callback
 */
function dialogRolloutCallbackParam val =
(
	format "\n"; print ".dialogRolloutCallbackParam()"
	format "val: %\n" val
)

/** Test each event
  *
  */
function dialogEventsTest =
(
	--format "\n"; print "1_DialogEventsTest.ms.dialogEventsTest()"
	DialogTest.Events.add #open	"dialogRolloutCallback()"
	DialogTest.Events.add #close	"dialogRolloutCallback()"

	DialogTest.Events.add #MOVED	"dialogRolloutCallback()"

	DialogTest.Events.add #RESIZED	"dialogRolloutCallback()"

   --DialogTest.Events.add #docked	"dialogRolloutCallback()"
   -- DialogTest.Events.add #undocked	"dialogRolloutCallback()"

	DialogTest.Events.add #RBUTTONDOWN	"dialogRolloutCallbackParam(@#RBUTTONDOWN@)"

	DialogTest.Events.add #okToClose	"dialogRolloutCallbackParam(@#okToClose@)"

)


/** Test rollout events
 */
function rolloutEventsTest =
(
	--format "\n"; print ".rolloutEventsTest()"
	_Rollouts	 = DialogTest.Rollouts()

	_Rollout    = _Rollouts.Roll "Main Rollout" --height:256
	
	_Controls   = _Rollout.Controls group:"Rollout Controls"

	_Button      = _Controls.control #button "Rollout Btn" id:#button_3

	/* ROLLOUT EVENTS */
	_Rollout.Events.add #ROLLEDUP	"dialogRolloutCallbackParam #ROLLEDUP"
	_Rollout.Events.add #OPEN	"dialogRolloutCallbackParam #OPEN"
	_Rollout.Events.add #CLOSE	"dialogRolloutCallbackParam #CLOSE"
)

/** Test all event
  *
  */
function testAllEvents _Rollout =
(
	--format "\n"; print "1_DialogEventsTest.ms.testAllEvent()"
	event_types =
	#(
		#open, #close, #moved, #resized, #help,

		/* Mouse button events */
		#lbuttondown,
		#lbuttonup,
		#lbuttondblclk,

		#mbuttondown,
		#mbuttonup,
		#mbuttondblclk,

		#rbuttondown,
		#rbuttonup,
		#rbuttondblclk,

		/* NOT maxscript NATVIVE */
		#docked,
		#undocked
	)


	for event_type in event_types do
	(
		--_Rollout.Events.add event_type	("print(\"Custom dialog event #"+ event_type as string +"\")")
		_Rollout.Events.add event_type ("dialogRolloutCallback()")
	)

)



/*------------------------------------------------------------------------------
	SET EVENTS
--------------------------------------------------------------------------------*/


--dialogEventsTest()
rolloutEventsTest()

--testAllEvents(DialogTest)



/* CREATE DIALOG */
DialogTest.create width:256

--DialogTest.register()
