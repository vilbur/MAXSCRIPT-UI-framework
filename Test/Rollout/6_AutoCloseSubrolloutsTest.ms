clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/**
	TEST OF AUTO ROLL UP OF OTHER SUBROLLOUTS
  
  
  
	Function of CTRL key on OPEN\CLOSE rollout:
		A) If CTRL key is PRESSED, then OTHER SUBROLLOUTS IN SAME SLOT ARE CLOSED
		B) If autorollup == true,  then CTRL key LET OTHER SUBROLLOUTS KEEP OPEN
		
		( Ctrl INVERTS BEHAVIOUR OF AUTOROLL  )
	

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
		append _Rollouts_new (_Rollouts.Roll ( title + i as string ) height:128 rolledup:true  )

	_Rollouts_new --return
)

/** Add item controls
 */
function addControls Controls title: count:1 =
(
	for i = 1 to count do 
		Controls.control #LABEL "[X]" across:1 height:32
)


/* DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:640 --DEBUG:true


/*------------------------------------------------------------------------------
	ADD SLOTS
--------------------------------------------------------------------------------*/

--(Dialog.Controls()).control #LABEL "OTHER ROLLOUTS AUTOMATICALY CLOSE" across:1 height:32

(Dialog.Controls()).control #LABEL "\n\n! ! !   T O   I N V E R T   B E H A V I O U R\n\n Press CTRL on OPEN \ CLOSE subrollouts\n\n      " across:1 height:96

slot_A = Dialog.Rollouts slot:#rollouts_A autorollup:true


slot_B = Dialog.Rollouts slot:#rollouts_B 


/*------------------------------------------------------------------------------
	ADD ROLLOUTS
--------------------------------------------------------------------------------*/
_Rollouts_A = addRollouts ( slot_A )	("Autorollup = TRUE ")	rollouts_in_slot:3


_Rollouts_B = addRollouts ( slot_B )	("Autorollup = FALSE ")	rollouts_in_slot:3


/* ADD CONTROLS for better view of opened rolluts */ 
for _Rollouts in #( _Rollouts_A, _Rollouts_B  ) where _Rollouts != undefined do 
	for _Rollout in _Rollouts do
		addControls (_Rollout.Controls()) title:"Btn"


/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/
Dialog.create()