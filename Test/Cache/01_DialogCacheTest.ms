clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/*==============================================================================

	HELPERS

================================================================================*/


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
function dialogEventsTest DialogTest =
(
	format "\n"; print "1_DialogEventsTest.ms.dialogEventsTest()"

    DialogTest.Event #OPEN	"dialogRolloutCallbackParam(@#OPEN@)"
    DialogTest.Event #CLOSE	"dialogRolloutCallbackParam(@#CLOSE@)"

	DialogTest.Event #RESIZED	"dialogRolloutCallbackParam(\"RESIZED\")"
  
    DialogTest.Event #DOCKED	"dialogRolloutCallbackParam(@#DOCKED@)"
    DialogTest.Event #UNDOCKED	"dialogRolloutCallbackParam(@#UNDOCKED@)"

	DialogTest.Event #RBUTTONDOWN	"dialogRolloutCallbackParam(@#RBUTTONDOWN@)"

    DialogTest.Event #okToClose	"dialogRolloutCallbackParam(@#okToClose@)"

	
    /* EVENT #MOVED DOES NOT WORK ON REGISTRED DIALOG*/ 	
    DialogTest.Event #MOVED "dialogRolloutCallbackParam(@#MOVED@)"
)

/*==============================================================================

	DEFINE TEST

================================================================================*/

/* DIALOG */

--Dialog 	= Dialog_v title:"Test"
Dialog = Dialog_v title:"Test"  ini:(getSourceFileName())

dialogEventsTest(Dialog)

/*------------------------------------------------------------------------------
	ROLLOUTS A
--------------------------------------------------------------------------------*/

_Rollouts	 = Dialog.Rollouts()

/* ROLLOUT  */
_Rollout    = _Rollouts.Roll "Main Rollout" --rolledUp:true --height:256

_Controls   = _Rollout.Controls group:"Rollout Controls"
 
--_Button      = _Controls.control #button "Rollout Btn" id:#button_3


/*------------------------------------------------------------------------------
	SUBROLLOUTS
------------------------------------------------------------------------------*/
_SubRollouts	 = _Rollout.Rollouts()

/* SUBROLLOUT  */
_SubRollout    = _SubRollouts.Roll "Sub Rollout"

_Controls   = _SubRollout.Controls group:"SubRollout Controls"

--_Button      = _Controls.control #button "Subrollout Btn" id:#button_3


/*------------------------------------------------------------------------------
	NESTED SUBROLLOUTS
------------------------------------------------------------------------------*/
_NestedSubRollouts	 = _SubRollout.Rollouts()

/* NESTED SUBROLLOUT  */
_NestedSubRollout    = _NestedSubRollouts.Roll "Nested Sub Rollout"

_Controls   = _NestedSubRollout.Controls group:"Nested SubRollout Controls"


/*------------------------------------------------------------------------------
	ROLLOUTS B
--------------------------------------------------------------------------------*/
Rollouts_B = Dialog.Rollouts slot:#Rollouts_B
Rollout_B1 = Rollouts_B.Roll "Rollout B1" height:256



/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/

/* NO CACHE */
--Dialog.create() -- create dialog without cache by default

/* USE CACHE */
use_cache = true
use_cache = false
Dialog.create cache:use_cache

Dialog.register()







