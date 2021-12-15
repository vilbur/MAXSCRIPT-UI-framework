clearListener()

try( destroyDialog test )catch()


/*
* 1) Fist occurrence of parameter is used if multiple same attributes passed
*
* 2) No problem if non existing param is passed
*/ 
rollout test "test"
(
	button button_1 "b1" width:256 width:64 does_not_matter_that_this_param_does_not_exist:999  
)

CreateDialog test width:256