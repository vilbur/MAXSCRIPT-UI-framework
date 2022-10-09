filein( getFilenamePath(getSourceFileName()) + "/DialogHotkeys/DialogHotkeys.ms" )

/** Hot keys
  * 
  * HOTKEY LIST: https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.keys?view=windowsdesktop-6.0#fields
  
  IMPROVMENT? https://forums.cgsociety.org/t/is-while-keyboard-button-pressed-held-do-possible/1482952/18
  
  ADDING KEYBOARD SHORTCUT: https://forums.cgsociety.org/t/assign-action-to-keyboard-shortcut-through-script/1395733/31
 */ 
struct HotKeys_v
(
	/* construct */
	/* properties */
	private
	
	--HotKeysList 	= HotKeysList_v(),
	
	dialogs = #(),	-- keys:	titles of dialogs
	DialogHotkeys = #(),	-- values:	arary of DialogHotkeys_v
	
	--_timer = dotNetObject "System.Windows.Forms.Timer",
	
	waiting_for_release = #(),

	/* dependency */
	/* reference */
	/* inhered */
	
	public
	
	/** Add dialog
	 */
	function addDialog title =
	(
		--format "\n"; print "HotKeys_v.addDialog()"
		--format "title	= % \n" title
		if appendIfUnique dialogs title then
			DialogHotkeys[findItem dialogs title] = DialogHotkeys_v()
		
		--format "dialogs	= % \n" dialogs
		--format "DialogHotkeys	= % \n" DialogHotkeys
		DialogHotkeys[findItem dialogs title] --return
	),
	
	/** Check keys
	  * 
	  * @
	 */
	function checkKeys title =
	(
		--format "\n"; print "HotKeys_v._checkKeys()"
		--format "title	= % \n" title
		modkeys	= #(#Alt, #Control, #Shift)
		modkeys	= #(#Alt, #Control, #Esc, #Shift)
		mod_keys_filter	= #(#ControlKey, #LControlKey, #RControlKey, #ShiftKey, #LShiftKey, #RShiftKey, #Alt, #Escape )

		modkeys_test	= #( keyboard.altPressed, keyboard.controlPressed, keyboard.escPressed, keyboard.shiftPressed )
		
		modkeys_pressed = for i = 1 to modkeys_test.count where modkeys_test[i] collect modkeys[i] 		
		
		keys = for key in (getPropNames ( dotNetClass "system.windows.forms.keys")) where findItem mod_keys_filter key == 0 collect key
		
		
		hotkeys_pressed = for key in keys where  ( dotNetClass "managedservices.keyboard").isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ key as string ))  collect key
		
		--format "modkeys_pressed	= % \n" modkeys_pressed
		--format "hotkeys_pressed	= % \n" hotkeys_pressed
		
		if modkeys_pressed.count > 0 or hotkeys_pressed.count > 0 then
			--waiting_for_release = modkeys_pressed + (this._removeModifierKeys(hotkeys_pressed))
			waiting_for_release = modkeys_pressed + hotkeys_pressed
		
		--format "waiting_for_release	= % \n" waiting_for_release
		if hotkeys_pressed.count == 0 and waiting_for_release.count > 0 then
		(
			DialogHotkeys[findItem dialogs title].fireCallback(waiting_for_release)
			
			waiting_for_release = #()
		)
	),
	

	
	private
	
	
	/** Test dialog
	 */
	function _testActiveDialog =
	(
		--format "\n"; print "HotKeys_v._testActiveDialog()"
		if (index = findItem dialogs (this._getActiveWindowTitle()) ) > 0 then
			this._checkKeys(DialogHotkeys[index])
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
		mod_keys	= #(#ControlKey, #LControlKey, #RControlKey, #ShiftKey, #LShiftKey, #RShiftKey, #Alt, #Escape )

		for hot_key in hot_keys where findItem mod_keys hot_key == 0 collect hot_key
	),

	/** Start tmer
	 */
	function _startTmer =
	(
		--format "\n"; print "HotKeys_v._startTmer()"
		dotNet.addEventHandler _timer "tick" this._testActiveDialog
		
		_timer.interval = 100

		_timer.start()
	),

	/** Test if Dialog is active
	 */
	function _getActiveWindowTitle =
	(
		--format "\n"; print "HotKeys_v._getActiveWindowTitle()"
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
	

	/**  
	 */
	on create do
	(
		--format "\n"; print "HotKeys.onCreate()"
		--this._startTmer()
	)
)