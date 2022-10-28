clearListener()

try( destroyDialog myRollout )catch()

rci = rolloutCreator "myRolloutTest" "My Rollout"

rci_sub = rolloutCreator "mySubRollout" "My Sub Rollout"
rci_sub.begin()
rci_sub.end()


rci.begin()

rci.addText ("subRollout subrollouts_slot \"slot_name\" height:256" )

rci.end()



CreateDialog (rci.def)


AddSubRollout myRollout.subrollouts_slot mySubRollout
