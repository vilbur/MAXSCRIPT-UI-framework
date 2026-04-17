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


/* ROLLOUTS */
slot_A = Dialog.Rollouts slot:#rollouts_A height:164 DEBUG:true
slot_B = Dialog.Rollouts slot:#rollouts_B

slot_B.autoroll = true

_Rollouts_A = addRollouts ( slot_A )	("Rollouts") rollouts_in_slot: 1
_Rollouts_B = addRollouts ( slot_B )	("Press CTRL key to close other rollouts on open") rollouts_in_slot:3



/* CONTROLS */ 
for _rollout in _Rollouts_B do
	addControls _rollout title:"Btn"


/* SUBROLLOUTS */
_SubRollouts	= addRollouts (_Rollouts_A[1].Rollouts())("SubRollout A") rollouts_in_slot: 2


for _SubRollout in _SubRollouts do 
	addControls _SubRollout
	


/* CREATE DIALOG */
Dialog.create()