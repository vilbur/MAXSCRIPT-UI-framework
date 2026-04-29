clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	--"./../../Lib/Dialog/Dialog.ms"


/* SET DIALOG */
--DEBUG = false
DEBUG = true

global DialogTest 	= Dialog_v title:"Test" ini:(getSourceFileName()) DEBUG:DEBUG


/** Open help
 */
function openHelpCallback =
(
	format "\n"; print ".openHelpCallback()"
)


/*==============================================================================

	RUN TESTS

================================================================================*/

/* DIALOG EVENTS */ 
--DialogTest.Event #HELP	"openHelpCallback()"

DialogTest.Event #HELP	"https://github.com/vilbur"



/* ROLLOUT EVENTS */ 
--_Rollout.Event event_type	("print(\"CUSTOM DIALOG EVENT #"+ event_type as string +"\")")



/*------------------------------------------------------------------------------
	
	ERROR KNOWING ISSUE
	
	shellLaunch cannot be executed directly from event because of security reasons
	
--------------------------------------------------------------------------------*/
--DialogTest.Event #HELP	"shellLaunch \"https://github.com/vilbur\" \"\""


/*------------------------------------------------------------------------------
	 CREATE DIALOG
--------------------------------------------------------------------------------*/

--DialogTest.create width:256 height:256 lockHeight:false cache:false
DialogTest.create()

--DialogTest.register()
 