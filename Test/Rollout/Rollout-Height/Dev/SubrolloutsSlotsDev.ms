clearListener()

/* RolloutCreator : https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

*/
try( destroyDialog DialogRollout )catch()
try( destroyDialog MainRollout )catch()
try( destroyDialog SubRoll )catch()
try( destroyDialog NestedSubRollout )catch()



rci_dialog = rolloutCreator "DialogRollout" "Dialog Rollout"

rci_dialog.begin()
rci_dialog.addText ("subRollout main_rollout_slot \"slot_name\" height:800" )
rci_dialog.addControl #button #myButton "THIS BUTTON SHOWS WHERE SLOT ENDS"
rci_dialog.end()




rci_main = rolloutCreator "MainRollout" "Main Rollout"

rci_main.begin()
rci_main.addText ("subRollout sub_rollout_slot \"slot_name\" height:720" )
rci_main.addControl #button #myButton "ROOLOUT IS TALL AS SLOT AND CONTROLS IN IT"
rci_main.end()



rci_sub = rolloutCreator "SubRoll" "SubRollout"

rci_sub.begin()
rci_sub.addText ("subRollout nested_slot \"slot_name\" height:512" )
rci_sub.end()




rci_nested = rolloutCreator "NestedSubRollout" "Nested Sub Rollout"

rci_nested.begin()
-- rci_nested.addText ("subRollout nested_slot \"slot_name\" height:256" )
rci_nested.end()


CreateDialog (rci_dialog.def) width:512 height:1024


CreateDialog (rci_main.def) width:512 
-- AddSubRollout DialogRollout.main_rollout_slot	rci_main.def



CreateDialog (rci_sub.def) width:512 


try( destroyDialog SubRoll )catch()
AddSubRollout MainRollout.sub_rollout_slot	rci_sub.def



-- try( destroyDialog MainRollout )catch()
AddSubRollout DialogRollout.main_rollout_slot	rci_main.def




-- AddSubRollout MainRollout.sub_rollout_slot	rci_sub.def
-- AddSubRollout SubRoll.nested_slot	rci_nested.def
