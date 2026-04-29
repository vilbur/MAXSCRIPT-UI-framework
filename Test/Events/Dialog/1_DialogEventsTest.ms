clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )	--"./../../../Lib/Dialog/Dialog.ms"


/* SET DIALOG */
--global DialogTest 	= Dialog_v title:"Test"
global DialogTest 	= Dialog_v title:"Test" ini:(getSourceFileName()) DEBUG:true

--/** Add subrollouts
-- */
--function addSubrollouts =
--(
--	format "\n"; print ".addSubrollouts()"
--	_Rollouts = DialogTest.Rollouts()
--	
--	_Rollout  = _Rollouts.Roll "Main Rollout" --height:256
--	
--	_Controls = _Rollout.Controls group:"Rollout Controls"
--	
--	_Button   = _Controls.control #button "Rollout Btn" id:#button_3
--)

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


/** Open help
 */
function openHelp =
(
	format "\n"; print ".openHelp()"
	--shellLaunch "https://github.com/vilbur/MAXSCRIPT-vilTools3" ""
)

/*------------------------------------------------------------------------------------------------------------------------------------

	DIALOG EVENTS https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-816D257C-CD2D-4753-A792-6E7AEFAFA6A7

--------------------------------------------------------------------------------------------------------------------------------------*/
function dialogEventsTest DialogTest =
(
    format "\n"; print "1_DialogEventsTest.ms.dialogEventsTest()"
	 
    --DialogTest.Event #HELP	"https://github.com/vilbur/MAXSCRIPT-vilTools3"
    DialogTest.Event #HELP	"openHelp()"
    --DialogTest.Event #HELP	"dialogRolloutCallbackParam(@!!!!!! DIALOG HELP !!!!!@)"

--    DialogTest.Event #CLOSE	"dialogRolloutCallbackParam(@#CLOSE@)"
--
--    DialogTest.Event #RESIZED	"dialogRolloutCallbackParam(@#RESIZED@)"
--	--DialogTest.Event #RESIZED	"dialogRolloutCallbackParam(\"RESIZED\")"
--  
--    DialogTest.Event #DOCKED	"dialogRolloutCallbackParam(@#DOCKED@)"
--    DialogTest.Event #UNDOCKED	"dialogRolloutCallbackParam(@#UNDOCKED@)"
--
--	DialogTest.Event #RBUTTONDOWN	"dialogRolloutCallbackParam(@#RBUTTONDOWN@)"
--
--    DialogTest.Event #okToClose	"dialogRolloutCallbackParam(@#okToClose@)"
--
--	
--    /* EVENT #MOVED DOES NOT WORK ON REGISTRED DIALOG*/ 	
--    DialogTest.Event #MOVED "dialogRolloutCallbackParam(@#MOVED@)"


)

/*------------------------------------------------------------------------------------------------------------------------------------

	ROLLOUT EVENTS Events https://help.autodesk.com/view/MAXDEV/2022/ENU/?guid=GUID-DC435555-362D-4A03-BCF2-21179C5442F2

--------------------------------------------------------------------------------------------------------------------------------------*/
function rolloutEventsTest DialogTest =
(
	--format "\n"; print ".rolloutEventsTest()"
	_Rollouts = DialogTest.Rollouts()

	_Rollout  = _Rollouts.Roll "Main Rollout" --height:256

	_Controls = _Rollout.Controls group:"Rollout Controls"

    _Button   = _Controls.control #button "Rollout Btn" id:#button_3

	--_Rollout.Event #ROLLEDUP	"dialogRolloutCallbackParam #ROLLEDUP"

	/* OPEN \ CLOSE EVENTS */
	--_Rollout.Event #OPEN	"dialogRolloutCallbackParam #OPEN"
	--_Rollout.Event #CLOSE	"dialogRolloutCallbackParam #CLOSE"
)

/** MASS TEST ALL EVENT
  *
  */
function massTestAllEvents _Rollout =
(
	--format "\n"; print "1_DialogEventsTest.ms.testAllEvent()"
	event_types =
	#(
		--#moved,  -- WORKS ONLY ON UNREGISTRED DIALOG

		/* MOUSE EVENTS - DOES NOT WORK INSIDE SUBROLLOUTS SLOT */
		#lbuttondown,
		--#lbuttonup,
		--#lbuttondblclk,
		--
		--#mbuttondown,
		--#mbuttonup,
		--#mbuttondblclk,
		--
		#rbuttondown,
		#rbuttonup,
		--#rbuttondblclk,
		--
		--/* NOT maxscript NATVIVE */
		--#docked,
		--#undocked,
		--
		--/* NATIVE EVENTS */ 
		--#open,
		--#close,
		--#resized,
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

/** Test offset position of registred dialog
 */
function testOffsetPositionOfRegistredDialog =
(
	for i = 1 to 10 do
	(
		DialogTest.unregister()
		DialogTest.register()
	)
)



/*==============================================================================
	CONFIGURE
================================================================================*/

--addSubrollouts()

/*==============================================================================

	RUN TESTS

================================================================================*/
/* DIALOG */ 
dialogEventsTest(DialogTest)

/* ROLLOUT */ 
rolloutEventsTest(DialogTest)

/* ALL TYPES OF EVENTS */ 
--massTestAllEvents(DialogTest)

/* MULTIPLE CALLBACKS PER EVENT */ 
--multipleCallbacksOnEventTest()



/* CREATE DIALOG */
DialogTest.create width:256 height:256 lockHeight:false cache:false

DialogTest.register()


/*------------------------------------------------------------------------------
	ADDITION TO TESTS
--------------------------------------------------------------------------------*/

/* REGISTRED and UNREGISTRED dialog has different position to but must be visible on same place  */ 
--testOffsetPositionOfRegistredDialog()


--DialogTest.ini.open()
