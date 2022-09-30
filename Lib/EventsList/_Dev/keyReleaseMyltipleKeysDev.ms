clearListener()


try(DestroyDialog test)catch()

rollout test "Detect Key Press" width:214
(

	timer clock_pressed  "clock_pressed"		interval:100
	timer clock_released "clock_released"	interval:100 active:false
	
	fn mod_keys         = #( keyboard.controlPressed, 	keyboard.shiftPressed,	keyboard.altPressed,	keyboard.escPressed )
	local mod_keys_state = #( true,		true,	false,						false ) -- TEST IF CONTROL + SHIFT is released

 	fn keyPress state = 
	(
		--if (  ( mod_keys() as string ) == (mod_keys_state as string )) == state do
		
		test = ( mod_keys() as string ) == (mod_keys_state as string )
		
		if test == state do
		(
			clock_released.active = state
			
			if state == false then
				print "KEY RELESEAD"
		)
	)

	on clock_pressed tick do keyPress(true)		
	
	
	on clock_released tick do keyPress(false)
)

CreateDialog test

 