 clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../KeyPress.ms" )


try(DestroyDialog test)catch()

rollout test "Detect Key Release" width:214
(
	--timer clock_pressed  "clock_pressed"		interval:100
	timer clock_pressed  "clock_pressed"		interval:3000
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
		clearListener()
		
		for i = 1 to keys_state_setups.count do 
		(
			mod_keys_current_state = modKeysCurrentState()
			
			keys_state_setup = keys_state_setups[i]
			
			mod_key_pressed = false
			hot_key_pressed = false

			is_mod_key_defined = (for state in keys_state_setup[1] where state collect state).count != 0
			is_hot_key_defined = keys_state_setup[2] != undefined 
			
			format "\n\n"
			format "keys_state_setup       = % \n" keys_state_setup
			format "mod_keys_current_state =   % \n" mod_keys_current_state

			format "is_mod_key_defined	= % \n" is_mod_key_defined
			format "is_hot_key_defined	= % \n" is_hot_key_defined

			any_mod_key_pressed = (for state in mod_keys_current_state where state collect state).count != 0

			
			/* TEST MODIFIER KEYS */ 
			if ( mod_keys_current_state as string ) == keys_state_setup[1] as string  then
				mod_key_pressed = true
				--(
				--	keys_pressed = keys_state_setups[i]
				--	
				--	clock_released.active = true
				--)
			
			if is_hot_key_defined then 
				hot_key_pressed = ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ keys_state_setup[2] as string ))
				
			--if mod_key_pressed then
			--	format "keys_state_setup[1]	= % \n" keys_state_setup[1]
			--if hot_key_pressed then
			--	format "keys_state_setup[2]	= % \n" keys_state_setup[2]
			
			format "mod_key_pressed	= % \n" mod_key_pressed
			format "hot_key_pressed	= % \n" hot_key_pressed
			
			if is_hot_key_defined and is_mod_key_defined and mod_key_pressed and hot_key_pressed then
			(
				format "ONLY MOD + HOT KEY PRESSED %\n\n" keys_state_setup
				exit
			)
			else if hot_key_pressed and not is_mod_key_defined and not any_mod_key_pressed then
				format "ONLY HOT KEY PRESSED %\n\n" keys_state_setup

			else if mod_key_pressed and not is_hot_key_defined and not hot_key_pressed then
				format "ONLY MOD KEYS PRESSED %\n\n" keys_state_setup
				
			
			
		)
		
		
		
		
	)
	
 	function keyRelease = 
	(
		--if (for state in (modKeysCurrentState()) where state collect state).count == 0 then -- test if all keys are released
		--(
		--	clock_released.active = false
		--	print ("KEY "+keys_pressed[2] as string +" RELESEAD")
		--)
	)
	

	
	
	on clock_pressed tick do keyPress()		
	
	on clock_released tick do keyRelease()
)

CreateDialog test