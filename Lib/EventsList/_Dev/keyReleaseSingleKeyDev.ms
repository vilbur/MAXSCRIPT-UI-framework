clearListener()


try(DestroyDialog test)catch()

rollout test "Detect Key Press" width:214
(
	timer clock_pressed  "clock_pressed"	interval:100
	timer clock_released "clock_released"	interval:100 active:false

 	fn keyPress state = 
	(
		if keyboard.controlPressed == state do
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