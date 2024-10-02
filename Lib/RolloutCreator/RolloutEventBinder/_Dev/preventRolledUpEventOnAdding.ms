

try(DestroyDialog MainRollout)catch()

/*
	PROBLEM: "AddSubRollout" is fireing "rolledUp" event

	SOLUTION: set rolledup_initilazied variable to block event

*/

rollout MainRollout "Main Rollout" width:325 height:200
(

    subrollout subrollouts_slot "subrollout_test" height:256
)

rollout subrollout_test "subrollout_test"
(
	button btn_test "Button"

	local rolledup_initilazied = false

	on subrollout_test rolledUp val do
	(
		--format "subrollout_test: %\n" subrollout_test
		if rolledup_initilazied then
			format "ROLLEDUP CALLBACK: %\n" val
		else
			rolledup_initilazied = true
	)

)


Dialog = CreateDialog MainRollout

AddSubRollout MainRollout.subrollouts_slot subrollout_test