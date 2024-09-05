/*


	1) Parmas MIN_SIZE: and MAX_SIZE: of RegisterDialogBar() DOES NOT WORK

	2) MINIMAL SIZE OF REGISTERED DIALOG IS ITS SIZE ON CREATION

		E.g.: CreateDialog rollout_id width:164 height:164 -- minimal width and height is 164


*/


try( DestroyDialog rollout_id )catch()

rollout rollout_id "MAX BUG TEST"

CreateDialog rollout_id width:164 height:164

cui.RegisterDialogBar rollout_id MIN_SIZE:[128, 128] MAX_SIZE:[256, 128]