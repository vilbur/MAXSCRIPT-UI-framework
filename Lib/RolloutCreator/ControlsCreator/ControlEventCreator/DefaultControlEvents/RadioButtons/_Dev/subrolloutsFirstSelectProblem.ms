clearListener()

/**  
		create UNSELECTABLE radio buttons

	  How it works: When same value is selected then radio buttons are unselected
  */	

try( destroyDialog rollout_main )catch()


rollout rollout_main "rollout_main" height:200 
(
  subRollout slot_1 "slot" height:256

)




rollout test_radio_buttons "Test RadioButtons"
(
	radiobuttons radio_buttons labels:#("First","Second") default:2 
	
	local radio_buttons_prev_state = 2 -- same as default parameter

	on radio_buttons changed val do
	(
		if val == radio_buttons_prev_state then 
			radio_buttons.state = val = 0
		
		radio_buttons_prev_state = val
	)
)
CreateDialog rollout_main width:256

AddSubRollout rollout_main.slot_1	test_radio_buttons
