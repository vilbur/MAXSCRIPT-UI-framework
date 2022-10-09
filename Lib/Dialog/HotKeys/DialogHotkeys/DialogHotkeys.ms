/** Hot keys
  * 
  * HOTKEY LIST: https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.keys?view=windowsdesktop-6.0#fields
  
  IMPROVMENT? https://forums.cgsociety.org/t/is-while-keyboard-button-pressed-held-do-possible/1482952/18
  
 */
struct DialogHotkeys_v
(
	/* construct */
	/* properties */
	
	hot_keys	= #(),
	_callbacks	= #(),
	

	/* dependency */
	/* reference */
	/* inhered */
	
	
	/** Add timer to rollout
	  *
	  * Currently supports only escape key for close dialog, works only for unregistered dialog
	 */
	function addHotkeyTimer _Rollout =
	(
		--format "\n"; print "HotKeys_v.addHotkeyTimer()"
		_Rollout.RCI.addControl timer #timer_shortcuts "" paramStr:"interval:100"

		_Rollout.RCI.addHandler #timer_shortcuts #tick codeStr:("HOTKEYS_GLOBAL.checkKeys @"+_Rollout.title+"@") filter:on
	),
	
	/** Key press
	 */
	function add hot_keys callback =
	(
		--format "\n"; print "DialogHotkeys_v.add()"
		
		hot_keys = ( sort hot_keys ) as string
		
		appendIfUnique this.hot_keys hot_keys
		
		callback_escaped = substituteString callback "'" "\""
		
		_callbacks[(findItem this.hot_keys hot_keys)] = callback_escaped
	),
	
	/** Fire callback
	 */
	function fireCallback hot_keys_pressed =
	(
		--format "\n"; print "DialogHotkeys_v.fireCallback()"
		if ( callback = this._getCallback(hot_keys_pressed) ) != undefined then
			try( execute (callback) )catch( format "callback	= % \n" callback )
			--execute (callback)
	),

	
	private

	
	/** Get callback
	 */
	function _getCallback hot_keys_pressed =
	(
		--format "\n"; print "DialogHotkeys_v._getCallback()"
		--format "this.hot_keys	= % \n" this.hot_keys
		--format "hot_keys_pressed	= % \n" hot_keys_pressed
		--format "_callbacks	= % \n" _callbacks
		--test = findItem this.hot_keys ( hot_keys_pressed as string )
		--format "_callbacks[test]	= % \n" _callbacks[test]
		--format "test	= % \n" test
		
		if ( index = findItem this.hot_keys ( hot_keys_pressed as string ) ) > 0 then
			_callbacks[index] --return
	),
	
	/**  
	 */
	on create do
	(
		--format "\n"; print "DialogHotkeys_v.onCreate()"
	)
)