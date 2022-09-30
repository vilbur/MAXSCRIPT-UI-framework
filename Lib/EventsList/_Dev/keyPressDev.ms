clearListener()


try(DestroyDialog test)catch()

rollout test "Detect Key Press" width:214
(
	timer clock "testClock" interval:100 -- 10 times a second
 
	local isKeyDown	= ( dotNetClass "managedservices.keyboard" ).isKeyDown

	local keys	= ( dotNetClass "system.windows.forms.keys") -- https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.keys?view=windowsdesktop-6.0
 
	checkbutton esc	"Esc"
	checkbutton ctrl	"Ctrl"
	checkbutton shift	"Shift"
	checkbutton alt	"Alt"
	checkbutton space	"Spacebar"
	
	checkbutton test_label "R key Pressed"	--width:80 --pos:[130,4]
	
	label key_pressed ""
 
	fn CheckKeys = 
	(
		
		-- for alt, ctrl, shift & esc we can use these

		if esc.checked	!= keyboard.escPressed	do esc.checked	= keyboard.escPressed
		if alt.checked	!= keyboard.altPressed	do alt.checked	= keyboard.altPressed
		if ctrl.checked	!= keyboard.controlPressed	do ctrl.checked	= keyboard.controlPressed
		if shift.checked	!= keyboard.shiftPressed	do shift.checked	= keyboard.shiftPressed

		 
		-- for any other keys
		local space_down = isKeyDown keys.Space
 
		if space.checked != space_down do space.checked = space_down

		local key_down = isKeyDown keys.R
		if test_label.checked != key_down do test_label.checked = key_down
 
	)
	on clock tick do
	(
		CheckKeys()		
		--format "tick...\n"
	)
)

CreateDialog test

