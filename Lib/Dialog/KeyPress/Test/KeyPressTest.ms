clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../KeyPress.ms" )

try(DestroyDialog test)catch()

/*
*/ 
function modKeysCurrentState = #( keyboard.controlPressed, keyboard.shiftPressed, keyboard.altPressed, keyboard.escPressed )

/** test if combination of has been pressed
 */
function keyPress keys_state_setups = 
(
	--print "keyPress()"
	
	local waiting_for_release

	for i = 1 to keys_state_setups.count do 
	(
		keys_state_setup = keys_state_setups[i]
		
		modkey_pressed = false
		hotkey_pressed = false
		combo_pressed   = false

		is_modkey_defined = (for state in keys_state_setup[2] where state collect state).count != 0
		is_hotkey_defined = keys_state_setup[3] != undefined

		modkeys_current_state = modKeysCurrentState()

		any_modkey_pressed = (for state in modkeys_current_state where state collect state).count != 0

		/* TEST MODIFIER KEYS */ 
		if ( modkeys_current_state as string ) == keys_state_setup[2] as string  then
			modkey_pressed = true

		if is_hotkey_defined then 
			hotkey_pressed = ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ keys_state_setup[3] as string ))

		combo_pressed = is_hotkey_defined	and	is_modkey_defined	and	modkey_pressed and hotkey_pressed

		if (	combo_pressed ) or				-- MOD + HOT KEY PRESSED
		  (	hotkey_pressed and not	is_modkey_defined	and not	any_modkey_pressed ) or	-- ONLY HOT KEY PRESSED
		  (	modkey_pressed and not	is_hotkey_defined	and not	hotkey_pressed  )	-- ONLY MOD KEY PRESSED
		then
			waiting_for_release = keys_state_setups[i]

		if combo_pressed then 
			exit
	)

	waiting_for_release --return
)

/*
*/ 
function keyRelease waiting_for_release = 
(
	
	any_modkey_pressed = (for state in (modKeysCurrentState()) where state collect state).count != 0;
	any_hotkey_pressed = waiting_for_release[3] != undefined and ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ waiting_for_release[3] as string ))

	if not any_modkey_pressed and not any_hotkey_pressed then -- test if all keys are released
	(
		execute ( waiting_for_release[1] )
		
		true --return
	)
	else
		false --return
)


/*
*/ 
rollout test "Detect Key Release" width:214
(
	timer clock_pressed  "clock_pressed"  interval:100
	timer clock_released "clock_released" interval:100 active:false

	local IsKeyDown	= ( dotNetClass "managedservices.keyboard" ).isKeyDown

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

	local waiting_for_release

	on clock_pressed tick do 
	(
		if (waiting_for_release_test = keyPress(keys_state_setups)) != undefined then
		(
			waiting_for_release = waiting_for_release_test
			clock_released.active = true
		)
	)

	on clock_released tick do
	(
		if keyRelease(waiting_for_release) then
		(
			clock_released.active = false
			waiting_for_release = undefined
			
		)
	)

)

CreateDialog test