clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )	--"./../../../Lib/Dialog/Dialog.ms"

/** Dialog rollout callback
 */
function dialogRolloutCallbackParam val =
(
	--format "\n"; print "dialogRolloutCallbackParam()"
	format "val: %\n" val
)

/** Test rollout events
 */
function rolloutEventsTest =
(
	DialogTest = Dialog_v title:"Test" ini:(getSourceFileName())
	
	_Rollouts = DialogTest.Rollouts()

	_Rollout  = _Rollouts.Roll "Main Rollout" --height:256

	_Controls = _Rollout.Controls group:"Rollout Controls"

	_Button   = _Controls.control #button "Rollout Btn" id:#button_3

	/* ROLLOUT EVENTS */
	_Rollout.Event #ROLLEDUP	"dialogRolloutCallbackParam #ROLLEDUP"
	
	_Rollout.Event #OPEN	"dialogRolloutCallbackParam #OPEN"
	_Rollout.Event #CLOSE	"dialogRolloutCallbackParam #CLOSE"
	

	/* DIALOG CREATE */
	DialogTest.create()
)



/* GET ROLLOUT OR SUBROLLOUT SLOT and change its properties */
-- Rollouts_A	= Dialog.get (#rollouts_A) -- get slot of subrolouts
-- Rollouts_A.height = 512


--/* get rollout and change properties  */
--_Rollout_A1	= Rollouts_A.get (#rollout_a1)
--_Rollout_A1.height = 512
--_Rollout_A1.title = _Rollout_A1.title + " modified title"

--/* Get via Dialog, Rollout and Subrollouts */
--(Rollouts_A.get (#Subrollout_a1)).height = 320
--(Dialog.get (#Nested_subrollout_a1)).height = 128
--(Dialog.get (#Super_nested_subrollout_a1)).height = 128


rolloutEventsTest()
