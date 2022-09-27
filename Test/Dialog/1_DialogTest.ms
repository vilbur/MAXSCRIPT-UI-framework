clearListener()


filein( "c:\GoogleDrive\Programs\CG\3DsMax\scripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

--try( destroyDialog ROLLOUT_test )catch()

	fn CheckKeys = 
	(
		if  keyboard.escPressed then
			try( destroyDialog test )catch()
		--print "ESC PRESSED"
		--local isKeyDown = (dotNetClass "managedservices.keyboard").isKeyDown
		--local keys = dotNetClass "system.windows.forms.keys"
		--
		-- 
		---- for alt, ctrl, shift & esc we can use these		
		--if alt.checked != keyboard.altPressed do alt.checked = keyboard.altPressed
		--if ctrl.checked != keyboard.controlPressed do ctrl.checked = keyboard.controlPressed
		--if shift.checked != keyboard.shiftPressed do shift.checked = keyboard.shiftPressed
		--
		---- for any other keys
		--local space_down = isKeyDown keys.Space
		--
		--if space.checked != space_down do space.checked = space_down
 
	)

Dialog 	= Dialog_v "Test"

_Controls   = Dialog.Controls group:"Main Controls"
Clock     = _Controls.control #timer "Clock" params:#(#interval, 100)

--Clock.Events.add #tick "print \"YEs\""
--Clock.Events.add #tick "CheckKeys()"
Clock.Events.add #tick "if  keyboard.escPressed then try( destroyDialog test )catch()"

--Dialog.create()
Dialog.create bgcolor:(color 32 255 32 ) escapeEnable:false

----Dialog.register()
--
--if keyboard.escPressed do try( destroyDialog test )catch() 

--
--(
-- 
--	isKeyDown = ( dotNetClass "managedservices.keyboard" ).isKeyDown
--	keys = dotNetClass "system.windows.forms.keys"
-- 
--	show keys
-- 
--	while not keyboard.escPressed do
--	(
--		sleep 0.05
-- 
--		if isKeyDown keys.Space and isKeyDown keys.ControlKey do 
--		(
--			format "Ctrl + Spacebar is pressed\n" 
--		)	
-- 
--	)        
-- 
--)


--
--try(DestroyDialog ::test)catch()
--rollout test "Detect Key Press" width:214
--(
--	timer clock "testClock" interval:100 -- 10 times a second
-- 
--	local isKeyDown = (dotNetClass "managedservices.keyboard").isKeyDown
--	local keys = dotNetClass "system.windows.forms.keys"
-- 
--	CheckButton ctrl "Ctrl" width:40 pos:[4,4] across:4
--	CheckButton shift "Shift" width:40 pos:[46,4]
--	CheckButton alt "Alt" width:40 pos:[88,4]
--	CheckButton space "Spacebar" width:80 pos:[130,4]
-- 
-- 
--	fn CheckKeys = 
--	(		
--		-- for alt, ctrl, shift & esc we can use these		
--		if alt.checked != keyboard.altPressed do alt.checked = keyboard.altPressed
--		if ctrl.checked != keyboard.controlPressed do ctrl.checked = keyboard.controlPressed
--		if shift.checked != keyboard.shiftPressed do shift.checked = keyboard.shiftPressed
-- 
--		-- for any other keys
--		local space_down = isKeyDown keys.Space
-- 
--		if space.checked != space_down do space.checked = space_down
-- 
--	)
--	on clock tick do
--	(
--		CheckKeys()		
--		format "tick...\n"
--	)
--)
--
--CreateDialog test
--
--
