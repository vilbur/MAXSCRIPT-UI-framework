clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../KeyPress.ms" )


KeyPress = KeyPress_v()

KeyPress.add ctrl:true shift:false

try(DestroyDialog test)catch()

rollout test "Detect Key Press" width:214
(

	timer clock_pressed  "clock_pressed"		interval:100
	timer clock_released "clock_released"	interval:100 active:false
	
	fn modKeysCurrentState         = #( keyboard.controlPressed, keyboard.shiftPressed, keyboard.altPressed, keyboard.escPressed ) 
	
	local keys_state        = #(
								  #( #(true,  false, false, false), #CTRL  ), 
								  #( #(false, true , false, false), #SHIFT ), 
								  #( #(true,  true,  false, false), #CTRL_SHIFT )
								  
	)
	
	local keys_state_last
	local true_count_last
	
	/** test if combination of keys has been preesed
	  */
 	fn keyPress = 
	(
		clock_released.active = false

		for i = 1 to keys_state.count do 
		(
			keys_state_desired = keys_state[i]
			--keys_state_desired = key_setup[2] as string
			mod_keys_current_state = modKeysCurrentState()
		
			
			if ( mod_keys_current_state as string ) == keys_state_desired[1]  as string  then 
			(
				--print "PRESSED"
				--print ("KEY "+keys_state_desired[2] as string +" PRESSED")
				
				keys_state_last = keys_state_desired
				
				true_count_last = (for state in mod_keys_current_state where state collect state)

				clock_released.active = true
			)
		)
	)
	
 	fn keyRelease = 
	(
		
		mod_keys_current_state = modKeysCurrentState()
		
		true_count = (for state in mod_keys_current_state where state collect state).count
		
		--format "state_last    = % \n" keys_state_last[1]
		--format "state_current = % \n" mod_keys_current_state
		--format "\n"
		--format "true_count_last	= % \n" true_count_last
		--format "true_count	= % \n" true_count

		--if ( mod_keys_current_state as string ) != (keys_state_last[1] as string ) and true_count as string == true_count_last as string then 
		if true_count == 0 then 
		(
			clock_released.active = false
			--format "true_count_last	= % \n" true_count_last
			--if state == false then
				print ("KEY "+keys_state_last[2] as string +" RELESEAD")
		)
		
		
	)
	
	
	on clock_pressed tick do keyPress()		
	
	on clock_released tick do keyRelease()
)

CreateDialog test
