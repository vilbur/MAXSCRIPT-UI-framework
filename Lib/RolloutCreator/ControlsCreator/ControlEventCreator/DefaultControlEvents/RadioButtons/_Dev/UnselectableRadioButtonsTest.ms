clearListener()

/**  
		create UNSELECTABLE radio buttons

	  How it works: When same value is selected then radio buttons are unselected
  */	

try( destroyDialog test_radio_buttons )catch()

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
CreateDialog test_radio_buttons