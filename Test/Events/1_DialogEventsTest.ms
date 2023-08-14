clearListener(); print("Cleared in:"+getSourceFileName())


filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

--try( destroyDialog ROLLOUT_test )catch()
/* SET DIALOG */
global DialogTest 	= Dialog_v title:"Test"

/** Test all event
  *
  */
function testAllEvents =
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
		DialogTest.Events.add event_type	("print(\"Custom dialog event #"+ event_type as string +"\")")
	)

)


/** Test each event
  *
  */
function testEachEvent =
(
	--format "\n"; print "1_DialogEventsTest.ms.testEachEvent()"
	DialogTest.Events.add #open	"print(\"Custom dialog event #open\")"
	DialogTest.Events.add #close	"print(\"Custom dialog event #close\")"

	DialogTest.Events.add #moved	"print(\"#Custom dialog event moved\")" -- DOES NOT WORK ON REGISTRED DIALOG

	DialogTest.Events.add #resized	"print(\"Custom dialog event #resized\")"

	DialogTest.Events.add #docked	"print(\"Custom dialog event #docked\")"
	DialogTest.Events.add #undocked	"print(\"Custom dialog event #undocked\")"

	 /* !!! IMPORTANT - #oktoclose MUST RETURN BOOLEAN */
	 DialogTest.Events.add #okToClose	"print(\"Custom dialog event #okToClose\"); true"

)





/*------------------------------------------------------------------------------
	SET EVENTS
--------------------------------------------------------------------------------*/

----testAllEvents()
testEachEvent()




/* CREATE DIALOG */
DialogTest.create width:256

DialogTest.register()
