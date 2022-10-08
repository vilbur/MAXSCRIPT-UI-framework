/** Hot keys
  * 
  * HOTKEY LIST: https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.keys?view=windowsdesktop-6.0#fields
  
  IMPROVMENT? https://forums.cgsociety.org/t/is-while-keyboard-button-pressed-held-do-possible/1482952/18
  
 */
struct DialogHotkeys_v
(
	/* construct */
	/* properties */
	
	hot_keys = #(),
	_callbacks = #(),
	

	/* dependency */
	/* reference */
	/* inhered */
	
	
	/** Key press
	 */
	function add hot_keys callback =
	(
		format "\n"; print "DialogHotkeys_v.add()"
		--format "hot_keys	= % \n" hot_keys
		
		hot_keys = ( sort hot_keys ) as string
		
		appendIfUnique this.hot_keys hot_keys
		
		callback_escaped = substituteString callback "'" "\\\""
		
		_callbacks[(findItem this.hot_keys hot_keys)] = callback_escaped
	),
	
	/** Fire callback
	 */
	function fireCallback hot_keys_pressed =
	(
		format "\n"; print "DialogHotkeys_v.fireCallback()"
		
		if ( callback = this._getCallback(hot_keys_pressed) ) != undefined then
			execute (callback)
	),

	
	private

	
	/** Get callback
	 */
	function _getCallback hot_keys_pressed =
	(
		--format "\n"; print "DialogHotkeys_v._getCallback()"
		
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