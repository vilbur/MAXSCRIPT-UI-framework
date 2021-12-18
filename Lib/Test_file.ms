clearListener()
try( destroyDialog ROLLOUT_test )catch()  


rollout ROLLOUT_test "Test"
(
	local BROWSEPATH_Test_prev_state = ""
	edittext BROWSEPATH_Test "Test" mode:#getOpenFileName initialDir:"C:/" types:"All files|*.*|"
	
	function createEventFired =
	(
		--print "createEventFired()"
		--global EventFired_v = execute "struct EventFired_v(type,Control,val)"
	)
	
	on BROWSEPATH_Test changed val do 
	(
		
		    
			
			--createEventFired()
			execute "struct EventFired_v(type,Control,val)"
			format "EventFired_v	= % \n" EventFired_v
			 
			--global EventFired = EventFired_v type:#changed Control:#BROWSEPATH_Test val:val
	   
			function valueIsEmpty _string =
			(
				(( dotNetClass "System.Text.RegularExpressions.RegEx").matches _string "^\s+$|^$" ).count == 1
			)


				format "val	= % \n" val
				format "BROWSEPATH_Test_prev_state	= % \n" BROWSEPATH_Test_prev_state
				format "valueIsEmpty(val)	= % \n" (valueIsEmpty(val))
				format "valueIsEmpty(BROWSEPATH_Test_prev_state)	= % \n" (valueIsEmpty(BROWSEPATH_Test_prev_state))
				
				if( valueIsEmpty(val) and valueIsEmpty(BROWSEPATH_Test_prev_state) ) then
					if( (browsed_path = getOpenFileName initialDir:"C:/" types:"All files|*.*|") != undefined ) do
					(
						format "browsed_path	= % \n" browsed_path
						BROWSEPATH_Test_prev_state = browsed_path
						BROWSEPATH_Test.text       = browsed_path
						--BROWSEPATH_Test.tooltip = browsed_path
					
						--val = EventFired.val    = substituteString browsed_path "\\" "\\\\"
					
						-- Fire custom event with browsed variable
					)
				else
				(
					BROWSEPATH_Test_prev_state = BROWSEPATH_Test.text
					--BROWSEPATH_Test.tooltip = browsed_path
				)
		
	)

)

CreateDialog ROLLOUT_test width:256