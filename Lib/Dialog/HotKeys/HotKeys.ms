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
		--format "\n"; print "HotKeys_v.testActiveDialog()"
		if (index = findItem dialogs (this.getActiveWindowTitle()) ) > 0 then
			this.checkKeys(DialogHoteys[index])
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
		
		_timer.interval = 100

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
		--format "\n"; print "HotKeys_v.checkKeys()"
		modkeys	= #(#Alt, #Control, #Shift)
		modkeys_test	= #( keyboard.altPressed, keyboard.controlPressed, keyboard.shiftPressed )
		
		modkeys_pressed = for i = 1 to modkeys_test.count where modkeys_test[i] collect modkeys[i] 		
		
		hotkeys_pressed = for key in (getPropNames ( dotNetClass "system.windows.forms.keys")) where  ( dotNetClass "managedservices.keyboard").isKeyDown (execute("( dotNetClass \"system.windows.forms.keys\")."+ key as string ))  collect key
		
		
		if hotkeys_pressed.count > 0 then
			waiting_for_release = modkeys_pressed + (this._removeModifierKeys(hotkeys_pressed))
		
		if hotkeys_pressed.count == 0 and waiting_for_release.count > 0 then
		(
			DialogHotkeys.fireCallback(waiting_for_release)
			
			waiting_for_release = #()
		)
	),
	


	/**  
	 */
	on create do
	(
		format "\n"; print "HotKeys.onCreate()"
		
		this.startTmer()
	)
)