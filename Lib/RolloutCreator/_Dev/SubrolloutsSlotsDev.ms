clearListener()

try( destroyDialog DialogRollout )catch()
try( destroyDialog MainRollout )catch()

rci_dialog = rolloutCreator "DialogRollout" "Dialog Rollout"

rci_dialog.begin()
rci_dialog.addText ("subRollout rollouts_slot \"slot_name\" height:320" )
rci_dialog.end()



rci_roll = rolloutCreator "MainRollout" "Main Rollout"

rci_roll.begin()
rci_roll.addText ("subRollout subrollouts_slot \"slot_name\" height:128" )
rci_roll.end()


--
--rci_sub = rolloutCreator "SubRoll" "SubRollout"
--
--rci_sub.begin()
--rci_sub.addText ("subRollout nested_slot \"slot_name\" height:128" )
--rci_sub.end()
--
--
--rci_nested = rolloutCreator "NestedSubRollout" "Nested Sub Rollout"
--
--rci_nested.begin()
--rci_nested.end()
format "RCI_DIALOG:	% \n" rci_dialog

CreateDialog (rci_dialog.def) width:512 height:512
--CreateDialog (rci_roll.def) width:512 height:512


_SubRollout  = DialogRollout.controls[1]

--subrollout_slot = (filterString (_SubRollout as string) ":")[2]



 AddSubRollout _SubRollout	rci_roll.def
 --AddSubRollout DialogRollout.rollouts_slot	rci_roll.def


--AddSubRollout MainRollout.subrollouts_slot	rci_sub.def
--AddSubRollout SubRoll.nested_slot	rci_nested.def
