clearListener(); print("Cleared in:\n"+getSourceFileName())
filein( getFilenamePath(getSourceFileName()) + "/../autoRollUpRolloutCallback.ms" )	--"./../autoRollUpRolloutCallback.ms"

try( destroyDialog roll_main )catch()


/** MAX 2022
  
 	rollout roll_main "roll_main" height:200 autoLayoutOnResize:true scrollBar:#asNeeded
 */

rollout roll_main "roll_main" height:200 
(
	subRollout slot_rollouts "Dictionary #(#auto_roll_up, 1)" height:480

	button Btn_roll_2 "BTN rollout 2"
)

rollout roll_1 "Rollout 1"
(
	subRollout slot_subrollouts "slot" height:320
	 
	on roll_1 rolledUp val do
		if val then autoRollUpRolloutCallback #roll_main #slot_rollouts #roll_1
)

rollout roll_2 "Rollout 2"
(
	button Btn_Subroll_2 "BTN Subrollout 2"
	
	on roll_2 rolledUp val do
		if val then autoRollUpRolloutCallback #roll_main #slot_rollouts #roll_2
)

rollout subroll_1 "Subrollout 1"
(
	on subroll_1 rolledUp val do
		if val then autoRollUpRolloutCallback #roll_1 #slot_rollouts #subroll_1
)

rollout subroll_2 "Subrollout 2"
(
	on subroll_2 rolledUp val do
		if val then autoRollUpRolloutCallback #roll_1 #slot_subrollouts #subroll_2

)


CreateDialog roll_main height:512


AddSubRollout roll_main.slot_rollouts	roll_1
AddSubRollout roll_main.slot_rollouts	roll_2

AddSubRollout roll_1.slot_subrollouts	subroll_1
AddSubRollout roll_1.slot_subrollouts	subroll_2