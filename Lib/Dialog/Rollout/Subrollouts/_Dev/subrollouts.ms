
try( destroyDialog rollout_main )catch()


/** MAX 2022
  
 	rollout rollout_main "rollout_main" height:200 autoLayoutOnResize:true scrollBar:#asNeeded
 */

rollout rollout_main "rollout_main" height:200 
(
  subRollout slot_1 "slot"
  --subRollout slot_2 "slot"
)

rollout subrollout_id_1 "subrollout_id_1"
(
	subRollout nested_slot_1 "slot"
)

rollout subrollout_nested "subrollout_id_1"
(
)

CreateDialog rollout_main


AddSubRollout rollout_main.slot_1	subrollout_id_1

AddSubRollout subrollout_id_1.nested_slot_1	subrollout_nested



rollout_main.slot_1.height           += 100
subrollout_id_1.height               += 100
subrollout_id_1.nested_slot_1.height += 100

