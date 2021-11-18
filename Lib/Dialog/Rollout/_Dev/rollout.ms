
try( destroyDialog rollout_main )catch()


rollout rollout_main "Game Utilities"
(
	group "Group 1"(
		--button button_1 "button 1"  across:3
		--button button_2 "button 2"
		--button button_3 "button 3"
		--
		--button button_4 "button 4"
		
	)
	group ""(
		button button_5 "button 1"  across:3
		button button_6 "button 2"
		button button_7 "button 3"
		
		button button_8 "button 4"
		
	)
)


CreateDialog rollout_main height:256 width:512
