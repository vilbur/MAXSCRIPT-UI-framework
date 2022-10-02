clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../HotKeys.ms" )


try(DestroyDialog test_dialog)catch()

/*
*/ 
rollout test_dialog "Detect Key Release" width:214
(
	timer clock_pressed  "clock_pressed"  interval:200
	timer clock_released "clock_released" interval:200 active:false

	/* 2D matrix of hotkeys setup
		#( callback, #(ctrl, shift, alt, esc), #hotkey )
	*/ 
	local keys_state_setups = #(
		#( "print \"SPACE\"",	#(false,  false, false, false), #space ),	-- Space
		#( "print \"CTRL+SPACE\"",	#(true,  false, false, false),  #space ),	-- CTRL + Space
		#( "print \"CTRL\"",	#(true,  false, false, false ) ),	-- CTRL
		#( "print \"SHIFT\"",	#(false, true, false, false  ) ),	-- SHIFT
		#( "print \"CTRL+SHIFT\"",	#(true,  true,  false, false ) )	-- CTRL + SHIFT
	)

	local  waiting_for_release
	
	on clock_pressed tick do (HotKeys_v()).keyPress(#test_dialog)
	
	on clock_released tick do (HotKeys_v()).keyRelease(#test_dialog)

)

CreateDialog test_dialog