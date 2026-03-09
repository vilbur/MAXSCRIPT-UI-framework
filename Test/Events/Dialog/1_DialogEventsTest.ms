clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )	--"./../../../Lib/Dialog/Dialog.ms"


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

    DialogTest.Event #RESIZED	"dialogRolloutCallbackParam(@#RESIZED@)"
	--DialogTest.Event #RESIZED	"dialogRolloutCallbackParam(\"RESIZED\")"
  
    DialogTest.Event #DOCKED	"dialogRolloutCallbackParam(@#DOCKED@)"
    DialogTest.Event #UNDOCKED	"dialogRolloutCallbackParam(@#UNDOCKED@)"

	DialogTest.Event #RBUTTONDOWN	"dialogRolloutCallbackParam(@#RBUTTONDOWN@)"

    DialogTest.Event #okToClose	"dialogRolloutCallbackParam(@#okToClose@)"

	
    /* EVENT #MOVED DOES NOT WORK ON REGISTRED DIALOG*/ 	
    DialogTest.Event #MOVED "dialogRolloutCallbackParam(@#MOVED@)"
)

/** Test rollout events
 */
function rolloutEventsTest DialogTest =
(
	--format "\n"; print ".rolloutEventsTest()"
	_Rollouts = DialogTest.Rollouts()

	_Rollout  = _Rollouts.Roll "Main Rollout" --height:256

	_Controls = _Rollout.Controls group:"Rollout Controls"

	_Button   = _Controls.control #button "Rollout Btn" id:#button_3

	/* ROLLOUT EVENTS */
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
		--#moved,  -- WORKS ONLY ON UNREGISTRED DIALOG

		/* MOUSE EVENTS */
		--#lbuttondown,
		--#lbuttonup,
		--#lbuttondblclk,
		--
		--#mbuttondown,
		--#mbuttonup,
		--#mbuttondblclk,
		--
		--#rbuttondown,
		--#rbuttonup,
		--#rbuttondblclk,
		--
		--/* NOT maxscript NATVIVE */
		--#docked,
		--#undocked,
		--
		--/* NATIVE EVENTS */ 
		--#open,
		--#close,
		#resized,
		#help
	)


	for event_type in event_types do
		_Rollout.Event event_type	("print(\"CUSTOM DIALOG EVENT #"+ event_type as string +"\")")
		--_Rollout.Event event_type ("dialogRolloutCallback()")

)




/** Multiple events test
 */
function multipleCallbacksOnEventTest =
(
	--format "\n"; print ".multipleCallbacksOnEventTest()"
    DialogTest.Event #OPEN	"dialogRolloutCallbackParam(@CALLBACK OF EVENT 1@)"
	
    DialogTest.Event #OPEN	"dialogRolloutCallbackParam(@CALLBACK OF EVENT 2@)"
)

/*------------------------------------------------------------------------------
	
	TEST EVENTS
	
--------------------------------------------------------------------------------*/

/* DIALOG */ 
--dialogEventsTest()

/* ROLLOUT */ 
--rolloutEventsTest(DialogTest)

/* ALL TYPES OF EVENTS */ 
testAllEvents(DialogTest)

/* MULTIPLE CALLBACKS */ 
--multipleCallbacksOnEventTest()





/* CREATE DIALOG */
DialogTest.create width:256 height:256 lockHeight:false

DialogTest.register()

--DialogTest.ini.open()
