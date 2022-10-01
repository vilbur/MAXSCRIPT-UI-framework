 clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../KeyPress.ms" )


try(DestroyDialog test)catch()

rollout test "Detect Key Release" width:214
(
	timer clock_pressed  "clock_pressed"		interval:100
	--timer clock_pressed  "clock_pressed"		interval:3000
	timer clock_released "clock_released"	interval:100 active:false
 
	local IsKeyDown	= ( dotNetClass "managedservices.keyboard" ).isKeyDown
	
	
	local keys_state_setups = #(
		#( #(false,  false, false, false), #space ),	-- Space
		#( #(true,  false, false, false),  #space ),	-- CTRL + Space
		#( #(true,  false, false, false ) ),	-- CTRL
		#( #(false, true, false, false  ) ),	-- SHIFT
		#( #(true,  true,  false, false ) )	-- CTRL + SHIFT
	)
	
	function modKeysCurrentState = 
		mod_keys_state = #( keyboard.controlPressed, keyboard.shiftPressed, keyboard.altPressed, keyboard.escPressed )

	
	local keys_pressed
	
	/** test if combination of keys has been preesed
	  */
 	function keyPress = 
	(		
		--clearListener()
		
		for i = 1 to keys_state_setups.count do 
		(
			mod_key_pressed = false
			hot_key_pressed = false
			combo_pressed   = false
			
			keys_state_setup = keys_state_setups[i]
			
			is_mod_key_defined = (for state in keys_state_setup[1] where state collect state).count != 0
			is_hot_key_defined = keys_state_setup[2] != undefined 
			
			mod_keys_current_state = modKeysCurrentState()
			
			any_mod_key_pressed = (for state in mod_keys_current_state where state collect state).count != 0
			
			
			/* TEST MODIFIER KEYS */ 
			if ( mod_keys_current_state as string ) == keys_state_setup[1] as string  then
				mod_key_pressed = true

			
			if is_hot_key_defined then 
				hot_key_pressed = ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ keys_state_setup[2] as string ))
			
			combo_pressed = is_hot_key_defined	and	is_mod_key_defined	and	mod_key_pressed and hot_key_pressed
			
			if (	combo_pressed ) or						-- MOD + HOT KEY PRESSED
			  (	hot_key_pressed and not	is_mod_key_defined	and not	any_mod_key_pressed ) or			-- ONLY HOT KEY PRESSED
			  (	mod_key_pressed and not	is_hot_key_defined	and not	hot_key_pressed  )			-- ONLY MOD KEY PRESSED
			then
				keys_pressed = keys_state_setups[i]
			
			if combo_pressed then 
				exit
		)
		
		--format "keys_pressed	= % \n" keys_pressed
		
		if keys_pressed != undefined then 
			clock_released.active = true
	)
	
 	function keyRelease = 
	(
		--format "keys_pressed	= % \n" keys_pressed

		any_mod_key_pressed = (for state in (modKeysCurrentState()) where state collect state).count != 0;
		any_hot_key_pressed = keys_pressed[2] != undefined and ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ keys_pressed[2] as string ))
		
		
		if not any_mod_key_pressed and not any_hot_key_pressed then -- test if all keys are released
		(
			print "RELESEAD"
			format "keys_pressed	= % \n" keys_pressed
			keys_pressed = undefined 
			clock_released.active = false
			--print ("KEY "+keys_pressed[2] as string +" RELESEAD")
		)
	)
	
	on clock_pressed tick do keyPress()		
	
	on clock_released tick do keyRelease()
)

CreateDialog test