
try( destroyDialog rollout_main )catch()


/** MAX 2022
  
 	rollout rollout_main "rollout_main" height:200 autoLayoutOnResize:true scrollBar:#asNeeded
 */

rollout rollout_main "rollout_main" height:200 
(
  subRollout slot_1 "slot"
  subRollout slot_2 "slot"
)


rollout subrollout_id_1 "subrollout_id_1"
(
)
rollout subrollout_id_2 "subrollout_id_1"
(
)

CreateDialog rollout_main


AddSubRollout rollout_main.slot_1 subrollout_id_1
AddSubRollout rollout_main.slot_2 subrollout_id_2


rollout_main.slot_1.height += 100

rollout_main.slot_2.height += 50
rollout_main.slot_2.pos += [0,100]