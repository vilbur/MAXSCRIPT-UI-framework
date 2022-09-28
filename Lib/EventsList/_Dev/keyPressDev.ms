try(DestroyDialog test)catch()

rollout test "Detect Key Press" width:214
(
	timer clock "testClock" interval:100 -- 10 times a second
 
	local isKeyDown = (dotNetClass "managedservices.keyboard").isKeyDown
	local keys = dotNetClass "system.windows.forms.keys"
 
	checkButton esc	"Esc"	--width:40 --pos:[4,4] across:4
	checkButton ctrl	"Ctrl"	--width:40 --pos:[4,4] across:4
	checkButton shift	"Shift"	--width:40 --pos:[46,4]
	checkButton alt	"Alt"	--width:40 --pos:[88,4]
	checkButton space	"Spacebar"	--width:80 --pos:[130,4]
 
 
	fn CheckKeys = 
	(		
		-- for alt, ctrl, shift & esc we can use these		
		if esc.checked != keyboard.escPressed do esc.checked = keyboard.escPressed
		if alt.checked != keyboard.altPressed do alt.checked = keyboard.altPressed
		if ctrl.checked != keyboard.controlPressed do ctrl.checked = keyboard.controlPressed
		if shift.checked != keyboard.shiftPressed do shift.checked = keyboard.shiftPressed
 
		-- for any other keys
		local space_down = isKeyDown keys.Space
 
		if space.checked != space_down do space.checked = space_down
 
	)
	on clock tick do
	(
		CheckKeys()		
		format "tick...\n"
	)
)

CreateDialog test

