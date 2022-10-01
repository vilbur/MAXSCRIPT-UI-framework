clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../KeyPress.ms" )


try(DestroyDialog test)catch()

rollout test "Detect Key Release" width:214
(
	timer clock_pressed  "clock_pressed"		interval:100
	timer clock_released "clock_released"	interval:100 active:false
	
	fn modKeysCurrentState = #( keyboard.controlPressed, keyboard.shiftPressed, keyboard.altPressed, keyboard.escPressed ) 
	
	local keys_state        = #(
		#( #(true,  false, false, false), #CTRL  ), 
		#( #(false, true , false, false), #SHIFT ), 
		#( #(true,  true,  false, false), #CTRL_SHIFT )
	)
	
	local keys_pressed
	
	/** test if combination of keys has been preesed
	  */
 	fn keyPress = 
	(
		for i = 1 to keys_state.count do 
		(			
			if ( (modKeysCurrentState()) as string ) == keys_state[i][1]  as string  then 
			(
				keys_pressed = keys_state[i]
				
				clock_released.active = true
			)
		)
	)
	
 	fn keyRelease = 
	(
		if (for state in (modKeysCurrentState()) where state collect state).count == 0 then -- test if all keys are released
		(
			clock_released.active = false
			print ("KEY "+keys_pressed[2] as string +" RELESEAD")
		)
	)
	
	
	on clock_pressed tick do keyPress()		
	
	on clock_released tick do keyRelease()
)

CreateDialog test