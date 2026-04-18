clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/** 
	If CTRL key is pressed on ROLLUP EVENT, then close other subrollouts and left opened one rollout

	AUROLLUP EVENT:
		BIND EVENTS:  RolloutDefaultEvents_v._getAutoRollUpRolloutEvent()
		IN FILE: "./../../Lib/RolloutCreator/RolloutEventBinder/RolloutDefaultEvents/RolloutDefaultEvents.ms"
  
  */



/** Add rollouts
 */
function addRollouts _Rollouts title rollouts_in_slot: slot:slot =
(
	_Rollouts_new = #()

	for i = 1 to rollouts_in_slot do
		append _Rollouts_new (_Rollouts.Roll ( title + i as string ))

	_Rollouts_new --return
)

/** Add item controls
 */
function addControls _Rollout title: count:1 =
(
	Controls = _Rollout.Controls()
	
	if title == unsupplied then
		title =  _Rollout.id as string
	
	for i = 1 to count do 
		Controls.control #BUTTON ( title + i as string ) across:1
)


/* DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:540 --DEBUG:true


/* ADD SLOTS */
slot_A = Dialog.Rollouts slot:#rollouts_A height:256 autorollup:true
slot_B = Dialog.Rollouts slot:#rollouts_B height:256 
--slot_C = Dialog.Rollouts slot:#rollouts_C height:256


/* ADD ROLLOUTS */
--_Rollouts_A = addRollouts ( slot_A )	("DEFAULT ROLLUP BEHAVIOUR ") rollouts_in_slot:3
_Rollouts_A = addRollouts ( slot_A )	("Autorollup TRUE ")	rollouts_in_slot:3
_Rollouts_B = addRollouts ( slot_B )	("Autorollup FALSE ")	rollouts_in_slot:3

/* ADD CONTROLS for better view of roooluts */ 
for _rollouts in #( _Rollouts_A, _Rollouts_B, _Rollouts_C  ) where _rollouts != undefined do 
	for _rollout in _rollouts do
		addControls _rollout title:"Btn"


/* CREATE DIALOG */
Dialog.create()