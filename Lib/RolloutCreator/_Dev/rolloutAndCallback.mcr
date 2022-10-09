
--global test_rollout_A

/** Callback rollout test
 */
function callbackRolloutTest =
(
	format "\n"; print ".callbackRolloutTest()"
	format "test_rollout_A	= % \n" test_rollout_A
);
/**  
 *	
 */
macroscript	test_rollout_callback_test
category:	"_test"
buttontext:	"rollout_callback_test"
toolTip:	"rollout_callback_test"
--icon:	"#(path, index)"
(

		
	try( destroyDialog test_rollout_A )catch()
	
	rollout test_rollout_A "Testing Buttons"
	(
		function callbackRolloutTest =
		(
			format "\n"; print ".callbackRolloutTest()"
			format "test_rollout_A	= % \n" test_rollout_A
		)
		
		
	  button theButton "Test"

	  on theButton pressed do
		callbackRolloutTest()
	)
	
	CreateDialog test_rollout_A 150 60
	
	execute("global test_rollout_A" )

)

