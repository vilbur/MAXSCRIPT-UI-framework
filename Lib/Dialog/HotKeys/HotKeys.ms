/** Hot keys
 */
struct HotKeys_v
(
	/* construct */
	/* properties */
	keys_state_setups = #(),
	
	/* dependency */
	/* reference */
	/* inhered */
	
	/** Key press
	 */
	function add hot_keys callback =
	(
		--format "\n"; print "HotKeys_v.HotKey()"

		indexes	= #( #ctrl, #shift, #alt, #esc )
		
		hotkeys_setup = #( substituteString callback "'" "\\\"" , #( false, false, false, false) )
		
		if hot_keys.count > 0 then
		(
			for hot_key in hot_keys do
				if (index = findItem indexes hot_key ) > 0  then 
					hotkeys_setup[2][index] = true -- assign modifier key
				else
					append hotkeys_setup hot_key -- add hotkey
			
			append keys_state_setups hotkeys_setup
		)
	),
	
	/** Add key press
	  *
	  * Currently supports only escape key for close dialog, works only for unregistered dialog
	 */
	function addKeyPressEvents RolloutMain =
	(
		--format "\n"; print "HotKeys_v._addKeyPressEvents()"
		--format "HotKeys.keys_state_setups	= % \n" HotKeys.keys_state_setups
		
		if this.keys_state_setups.count == 0 then
			return false
		
		RolloutMain.addlocal (#keys_state_setups) this.keys_state_setups
		
		RolloutMain.addlocal (#waiting_for_release) (undefined)
		
		_Controls   = RolloutMain.Controls group:#hotkeys_timers
		
		Clock_pressed	= _Controls.control #timer "clock_pressed" params:#(#interval, 100)
		Clock_released	= _Controls.control #timer "clock_released" params:#(#interval, 100,  #active,false)
		
		Clock_pressed.Events.add   #tick  ( "(HotKeys_v()).keyPress(\""  + RolloutMain.id as string +"\")"  )
		Clock_released.Events.add  #tick  ( "(HotKeys_v()).keyRelease(\""+ RolloutMain.id as string +"\")"  )
	),
	
	/* Get state of modifier keys: Ctrl, Shift, Alt, Esc
	*/ 
	function modKeysCurrentState = #( keyboard.controlPressed, keyboard.shiftPressed, keyboard.altPressed, keyboard.escPressed ),
	
	/** Test if Dialog is active
	 */
	function dialogIsActive dialog =
	(
		--format "\n"; print ".dialogIsActive()"
		function getForegroundWindow =
		(
			local source  = "using System;
					using System.Runtime.InteropServices;
					public class Window
					{
						[DllImport(\"user32.dll\")]
						public static extern IntPtr GetForegroundWindow();
					}"
			
			local CsharpProvider = dotNetObject "Microsoft.CSharp.CSharpCodeProvider"
			local CompilerParams = dotNetObject "System.CodeDom.Compiler.CompilerParameters"
			
			CompilerParams.GenerateInMemory = true
			CompilerParams.ReferencedAssemblies.Add "System.dll"
			
			local CompilerResults = CsharpProvider.CompileAssemblyFromSource CompilerParams #(source)
			
			
			CompilerResults.CompiledAssembly.CreateInstance "Window"
		)
		
		if not isKindOf ::dialogWindow dotNetObject do dialogWindow = getForegroundWindow()
	
		 dialog.hwnd == ( dialogWindow.getForegroundWindow() )  --return
	),
	
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
		
		local waiting_for_release
		
		for i = 1 to dialog.keys_state_setups.count do 
		(
			keys_state_setup =  dialog.keys_state_setups[i]
			
			modkey_pressed = false
			hotkey_pressed = false
			combo_pressed  = false
	
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
				waiting_for_release =  dialog.keys_state_setups[i]
	
			if combo_pressed then 
				exit
		)
		
		--format "waiting_for_release	= % \n" waiting_for_release
		
		if waiting_for_release != undefined then
		(
			--format "waiting_for_release	= % \n" waiting_for_release
			--format "dialog.waiting_for_release	= % \n" dialog.waiting_for_release
			dialog.waiting_for_release = waiting_for_release
			
			dialog.clock_released.active = true
		)
		
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
		--format "\n"; print "HotKeys.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop ) 
	)
	
)
