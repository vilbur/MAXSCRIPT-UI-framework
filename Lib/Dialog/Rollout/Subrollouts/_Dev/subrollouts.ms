clearListener()


try( destroyDialog rollout_main )catch()


/** MAX 2022
  
 	rollout rollout_main "rollout_main" height:200 autoLayoutOnResize:true scrollBar:#asNeeded
 */

rollout rollout_main "rollout_main" height:200 
(
  subRollout slot_1 "slot"
  --subRollout slot_2 "slot"
	
	on rollout_main help do
	(
	   print ("Help rollout_main")
	)
	on rollout_main oktoclose do
	(
	   print ("oktoclose !")
	)
)

rollout subrollout_1 "Subrollout 1"
(
	subRollout nested_slot_1 "slot"
	
	on subrollout_1 rolledUp val do
	(
	   print ("Rolledup " + val as string )
	)
	
	on subrollout_1 help do
	(
	   print ("Help subrollout_1")
	)
)

rollout subrollout_nested "Subrollout nested"
(
)

CreateDialog rollout_main


AddSubRollout rollout_main.slot_1	subrollout_1

AddSubRollout subrollout_1.nested_slot_1	subrollout_nested



rollout_main.slot_1.height           += 100
subrollout_1.height               += 100
subrollout_1.nested_slot_1.height += 100


