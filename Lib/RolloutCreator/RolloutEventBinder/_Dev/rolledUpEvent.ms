--clearListener()


try(cui.UnRegisterDialogBar MainRollout)catch() --try to unregister if already registered
try(DestroyDialog           MainRollout)catch() --try to unregister if already registered

rollout MainRollout "Main Rollout" width:325 height:200
(
    subrollout subrollouts_slot "subrollout_test" height:256

	on MainRollout okToClose do
	(
		--print "-------- ROLLEDUP -------"
		format "okToClose EVENT: %\n" val
	)
)

rollout subrollout_test "subrollout_test"
(
	button btn_test "Button"

	on subrollout_test rolledUp val do
	(
		--print "-------- ROLLEDUP -------"
		format "ROLLEDUP EVENT: %\n" val
	)

)


Dialog = CreateDialog MainRollout

AddSubRollout MainRollout.subrollouts_slot subrollout_test

try(DestroyDialog           MainRollout)catch() --try to unregister if already registered
