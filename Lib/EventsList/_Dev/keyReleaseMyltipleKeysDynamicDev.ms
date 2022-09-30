clearListener()


try(DestroyDialog test)catch()

rollout test "Detect Key Press" width:214
(

	timer clock_pressed  "clock_pressed"		interval:100
	timer clock_released "clock_released"	interval:100 active:false
	
	fn modKeysState        = #(
								  #( #( keyboard.controlPressed ), #(true), #(#CTRL ) ),
								  #( #( keyboard.shiftPressed ),   #(true), #(#SHIFT ) )
								  
	)
	
	local release_test 
	
 	fn keyPress = 
	(
		for i = 1 to ( mod_keys_state = modKeysState() ).count do 
		--for _keys in (mod_keys_state()) where ((_keys[1] as string ) == (_keys[2] as string )) == true do
		(
			key_setup = mod_keys_state[i]
			
			keys_state_current = key_setup[1] as string 
			keys_state_desired = key_setup[2] as string 
		
			if keys_state_current == keys_state_desired then 
			(
				release_test = i
				
				clock_released.active = true
				
				--print "PREESED"
			)
		)
	)
	
 	fn keyRelease = 
	(
		
		release_keys = (modKeysState())[release_test]
		
		if ((release_keys[1] as string ) != (release_keys[2] as string ))  then
		(
			clock_released.active = false
			
			--if state == false then
				print ("KEY "+release_keys[3] as string +" RELESEAD")
		)
	)
	
	
	on clock_pressed tick do keyPress()		
	
	on clock_released tick do keyRelease()
)

CreateDialog test
