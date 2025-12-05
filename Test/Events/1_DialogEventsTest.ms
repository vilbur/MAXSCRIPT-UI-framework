clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

/* SET DIALOG */
--global DialogTest 	= Dialog_v title:"Test"
global DialogTest 	= Dialog_v title:"Test" ini:(getSourceFileName())


/** Dialog rollout callback
 */
function dialogRolloutCallback =
(
	format "\n"; print "dialogRolloutCallback()"
	--format "EventFired: %\n" EventFired
)

/** Dialog rollout callback
 */
function dialogRolloutCallbackParam val =
(
	--format "\n"; print "dialogRolloutCallbackParam()"
	format "val: %\n" val
)

/** Test each event
  *
  */
function dialogEventsTest =
(
	format "\n"; print "1_DialogEventsTest.ms.dialogEventsTest()"

    DialogTest.Event #OPEN	"dialogRolloutCallbackParam(@#OPEN@)"
    DialogTest.Event #CLOSE	"dialogRolloutCallbackParam(@#CLOSE@)"

	DialogTest.Event #RESIZED	"dialogRolloutCallbackParam(\"RESIZED\")"
  
    DialogTest.Event #DOCKED	"dialogRolloutCallbackParam(@#DOCKED@)"
    DialogTest.Event #UNDOCKED	"dialogRolloutCallbackParam(@#UNDOCKED@)"

	DialogTest.Event #RBUTTONDOWN	"dialogRolloutCallbackParam(@#RBUTTONDOWN@)"

    DialogTest.Event #okToClose	"dialogRolloutCallbackParam(@#okToClose@)"

	
    /* EVENT #MOVED DOE NOT WORK ON REGISTRED DIALOG*/ 	
    DialogTest.Event #MOVED "dialogRolloutCallbackParam(@#MOVED@)"
)


/** Test rollout events
 */
function rolloutEventsTest =
(
	--format "\n"; print ".rolloutEventsTest()"
	_Rollouts = DialogTest.Rollouts()

	_Rollout  = _Rollouts.Roll "Main Rollout" --height:256

	_Controls = _Rollout.Controls group:"Rollout Controls"

	_Button   = _Controls.control #button "Rollout Btn" id:#button_3

	/* ROLLOUT EVENTS */
	_Rollout.Event #ROLLEDUP	"dialogRolloutCallbackParam #ROLLEDUP"
	_Rollout.Event #OPEN	"dialogRolloutCallbackParam #OPEN"
	_Rollout.Event #CLOSE	"dialogRolloutCallbackParam #CLOSE"
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
		--_Rollout.Event event_type	("print(\"Custom dialog event #"+ event_type as string +"\")")
		
		_Rollout.Event event_type ("dialogRolloutCallback()")
	)

)




/** Multiple events test
 */
function multipleEventsTest =
(
	--format "\n"; print ".multipleEventsTest()"
	
    DialogTest.Event #OPEN	"dialogRolloutCallbackParam(@EVENT 1@)"
    DialogTest.Event #OPEN	"dialogRolloutCallbackParam(@EVENT 2@)"

)

/*------------------------------------------------------------------------------
	
	TEST EVENTS
	
--------------------------------------------------------------------------------*/

/* DIALOG */ 
--dialogEventsTest()

/* ROLLOUT */ 
--rolloutEventsTest()

/* ALL TYPES OF EVENTS */ 
--testAllEvents(DialogTest)

multipleEventsTest()



/* CREATE DIALOG */
DialogTest.create width:256 height:256

/*------------------------------------------------------------------------------
	
	IMPORTANT:
		SOME EVENT TYPES DOESN'T WORK ON REGISDTRED DIALOG and vice versa
	
--------------------------------------------------------------------------------*/

DialogTest.register()
