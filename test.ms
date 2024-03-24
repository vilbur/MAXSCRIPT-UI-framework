


rollout rollout_id "Title"
(

	spinner spinner_test "caption" range:[0,10,0] type:#float scale:0.001

	on spinner_test changed val  do

		format "val	= % \n" val

	on spinner_test entered inSpin_arg inCancel_arg  do
	(
	format "\n"

		format "inSpin_arg	= % \n" inSpin_arg
		format "inCancel_arg	= % \n" inCancel_arg
	)

)

CreateDialog rollout_id
