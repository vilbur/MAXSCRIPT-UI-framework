filein( getFilenamePath(getSourceFileName()) + "/DialogHotkeys/DialogHotkeys.ms" )

/** Hot keys
  * 
  * HOTKEY LIST: https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.keys?view=windowsdesktop-6.0#fields
  
  IMPROVMENT? https://forums.cgsociety.org/t/is-while-keyboard-button-pressed-held-do-possible/1482952/18
  
 */
struct HotKeys_v
(
	/* construct */
	/* properties */
	private
	
	dialogs = #(),	-- keys:	titles of dialogs
	DialogHoteys = #(),	-- values:	arary of DialogHotkeys_v
	
	_timer = dotNetObject "System.Windows.Forms.Timer",
	
	waiting_for_release = #(),

	/* dependency */
	/* reference */
	/* inhered */
	
	public
	
	/** Add dialog
	 */
	function addDialog title =
	(
		format "\n"; print "HotKeys_v.addDialog()"
		if appendIfUnique dialogs title then
			DialogHoteys[findItem dialogs title] = DialogHotkeys_v()
		
		DialogHoteys[findItem dialogs title] --return
	),
	
	/** Test dialog
	 */
	function testActiveDialog =
	(
		format "\n"; print "HotKeys_v.testActiveDialog()"
		if (index = findItem dialogs (this.getActiveWindowTitle()) ) > 0 then
			--format "DialogHoteys[index]	= % \n" DialogHoteys[index]
			this.checkKeys(DialogHoteys[index])
		(
			
			--_DialogHoteys = DialogHoteys[index]
			
		)
	),
	
	/** Remove modifier keys
	  *
	  * @param	array	hot_keys	dotNet hotkeys E.G.:  #(#ControlKey, #LControlKey, #Q) 
	  *
	  * @return	array	E.G.: #(#Q) 
	 */
	function _removeModifierKeys hot_keys =
	(
		--format "\n"; print "HotKeys_v._removeModifierKeys()"
		mod_keys	= #(#ControlKey, #LControlKey, #RControlKey, #ShiftKey, #LShiftKey, #RShiftKey, #Alt )

		for hot_key in hot_keys where findItem mod_keys hot_key == 0 collect hot_key
	),
	
	/** Key press
	 */
	function add hot_keys callback =
	(
		format "\n"; print "HotKeys_v.HotKey()"
		--format "hot_keys	= % \n" hot_keys
		
		hot_keys = ( sort hot_keys ) as string
		
		appendIfUnique _shortcuts hot_keys
		
		callback_escaped = substituteString callback "'" "\\\""
		
		_callbacks[(findItem _shortcuts hot_keys)] = #( callback_escaped )
	),

	/** Start tmer
	 */
	function startTmer =
	(
		--format "\n"; print "HotKeys_v.startTmer()"
		dotNet.addEventHandler _timer "tick" this.testActiveDialog
		
		_timer.interval = 1000

		_timer.start()
	),
	
	/** Stop timer
	  
	  TODO: REMOVE HANDLER ON DIALOG CLOSE: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-9BE82D70-1869-46D7-9501-E5453E25AC68
	 */
	function stopTimer =
	(
		format "\n"; print "HotKeys_v.stopTimer()"
		_timer.stop()
	),

	/** Test if Dialog is active
	 */
	function getActiveWindowTitle =
	(
		--format "\n"; print "HotKeys_v.getActiveWindowTitle()"
		function getForegroundWindow =
		(
			source  = "using System;
					using System.Runtime.InteropServices;
					public class Window
					{
						[DllImport(\"user32.dll\")]
						public static extern IntPtr GetForegroundWindow();
					}"
	
			CsharpProvider = dotNetObject "Microsoft.CSharp.CSharpCodeProvider"
			CompilerParams = dotNetObject "System.CodeDom.Compiler.CompilerParameters"
	
			CompilerParams.GenerateInMemory = true
			CompilerParams.ReferencedAssemblies.Add "System.dll"
	
			CompilerResults = CsharpProvider.CompileAssemblyFromSource CompilerParams #(source)
	
			CompilerResults.CompiledAssembly.CreateInstance "Window"
		)
	
		if not isKindOf ::dialogWindow dotNetObject do dialogWindow = getForegroundWindow()
	
		--dialog.hwnd == ( dialogWindow.getForegroundWindow() )  --return
		active_hwnd = dialogWindow.getForegroundWindow() --return		
		
		UIAccessor.getWindowText active_hwnd
	),
	
	/** Check keys
	 */
	function checkKeys DialogHotkeys =
	(
		format "\n"; print "HotKeys_v.checkKeys()"
		--format "DialogHotkeys	= % \n" DialogHotkeys
		--active_dialog = getActiveWindowTitle()
		
		--format "active_dialog	= % \n" active_dialog
		----dialog = execute(dialog_id as string )
		--format "dialog	= % \n" dialog
		--if not this.dialogIsActive(dialog) then
		--	return false
				
		local waiting_for_release

		modkeys	= #(#Alt, #Control, #Shift)
		modkeys_test	= #( keyboard.altPressed, keyboard.controlPressed, keyboard.shiftPressed )
		
		modkeys_pressed = for i = 1 to modkeys_test.count where modkeys_test[i] collect modkeys[i] 		
		
		
		hotkeys_pressed = for key in (getPropNames ( dotNetClass "system.windows.forms.keys")) where  ( dotNetClass "managedservices.keyboard").isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ key as string ))  collect key
		
		waiting_for_release = modkeys_pressed + (this._removeModifierKeys(hotkeys_pressed))
		
		format "waiting_for_release	= % \n" waiting_for_release
	),
	




	/** Add key press
	  *
	  * Currently supports only escape key for close dialog, works only for unregistered dialog
	 */
	function addKeyPressEvents RolloutMain =
	(
		format "\n"; print "HotKeys_v._addKeyPressEvents()"
		

		
		
		--format "HotKeys.keys_state_setups	= % \n" HotKeys.keys_state_setups

		--if this.keys_state_setups.count == 0 then
		--	return false
		--
		--RolloutMain.addlocal (#keys_state_setups) this.keys_state_setups
		--
		--RolloutMain.addlocal (#waiting_for_release) (undefined)
		--
		--_Controls   = RolloutMain.Controls group:#hotkeys_timers

		--Clock_pressed	= _Controls.control #timer "clock_pressed" params:#(#interval, 100)
		--Clock_released	= _Controls.control #timer "clock_released" params:#(#interval, 100,  #active,false)

		--Clock_pressed.Events.add   #tick  ( "(HotKeys_v()).keyPress(\""  + RolloutMain.id as string +"\")"  )
		--Clock_released.Events.add  #tick  ( "(HotKeys_v()).keyRelease(\""+ RolloutMain.id as string +"\")"  )
	),

	/* Get state of modifier keys: Ctrl, Shift, Alt
	*/ 
	function modKeysCurrentState = #( keyboard.altPressed, keyboard.controlPressed, keyboard.shift ),

	/** test if combination of has been pressed
	 */
	function keyPress dialog_id = 
	(
		--format "\n"; print "HotKeys_v.keyPress()"
		dialog = execute(dialog_id as string )
		--format "dialog	= % \n" dialog
		if not this.dialogIsActive(dialog) then
			return false

		--print "dialogIsActive"

		--local waiting_for_release
		--
		--local hotkey_pressed =#()
		--
		--isKeyDown = ( dotNetClass "managedservices.keyboard").isKeyDown
		--keys = dotNetClass "system.windows.forms.keys"
		--
		--for key in (getPropNames keys) do 		
		--(
		--	if isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ key as string )) then
		--		append hotkey_pressed key
		--	
		--	--format "key	= % \nhotkey_pressed	= % \n\n" key hotkey_pressed
		--)
		--
		--format "hotkey_pressed	= % \n" hotkey_pressed
		
		
		--for i = 1 to dialog.keys_state_setups.count do 
		--(
		--	keys_state_setup =  dialog.keys_state_setups[i]
		--
		--	modkey_pressed = false
		--	hotkey_pressed = false
		--	combo_pressed  = false
		--
		--	is_modkey_defined = (for state in keys_state_setup[2] where state collect state).count != 0
		--	is_hotkey_defined = keys_state_setup[3] != undefined
		--
		--	modkeys_current_state = modKeysCurrentState()
		--
		--	any_modkey_pressed = (for state in modkeys_current_state where state collect state).count != 0
		--
		--	/* TEST MODIFIER KEYS */ 
		--	if ( modkeys_current_state as string ) == keys_state_setup[2] as string  then
		--		modkey_pressed = true
		--
		--	if is_hotkey_defined then 
		--		----hotkey_pressed = ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ keys_state_setup[3] as string ))
		--
		--	combo_pressed = is_hotkey_defined	and	is_modkey_defined	and	modkey_pressed and hotkey_pressed
		--
		--	if (	combo_pressed ) or				-- MOD + HOT KEY PRESSED
		--	  (	hotkey_pressed and not	is_modkey_defined	and not	any_modkey_pressed ) or	-- ONLY HOT KEY PRESSED
		--	  (	modkey_pressed and not	is_hotkey_defined	and not	hotkey_pressed  )	-- ONLY MOD KEY PRESSED
		--	then
		--		waiting_for_release =  dialog.keys_state_setups[i]
		--
		--	if combo_pressed then 
		--		exit
		--)
		--
		----format "waiting_for_release	= % \n" waiting_for_release[2]
		--
		--if waiting_for_release != undefined then
		--(
		--	dialog.waiting_for_release = waiting_for_release
		--
		--	dialog.clock_released.active = true
		--)

	),

	/* Test if keys has been released
	 * Then fire callback
	*/ 
	function keyRelease dialog_id = 
	(
		--format "\n"; print "HotKeys_v.keyRelease()"
		dialog = execute(dialog_id as string )

		--if test_dialog.hwnd == ( dialogWindow.getForegroundWindow() ) then
		if not this.dialogIsActive(dialog) then
			return false

		any_modkey_pressed = (for state in (modKeysCurrentState()) where state collect state).count != 0;
		any_hotkey_pressed = dialog.waiting_for_release[3] != undefined and ( dotNetClass "managedservices.keyboard" ).isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ dialog.waiting_for_release[3] as string ))

		if not any_modkey_pressed and not any_hotkey_pressed then -- test if all keys are released
		(
			execute ( dialog.waiting_for_release[1] )

			dialog.clock_released.active = false
			dialog.waiting_for_release = undefined
		)

	),

	private

	/**  
	 */
	on create do
	(
		format "\n"; print "HotKeys.onCreate()"
		
		this.startTmer()
	)
)