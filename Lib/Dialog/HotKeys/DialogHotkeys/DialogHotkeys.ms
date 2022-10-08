/** Hot keys
  * 
  * HOTKEY LIST: https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.keys?view=windowsdesktop-6.0#fields
  
  IMPROVMENT? https://forums.cgsociety.org/t/is-while-keyboard-button-pressed-held-do-possible/1482952/18
  
 */
struct DialogHotkeys_v
(
	/* construct */
	/* properties */
	
	_shortcuts = #(),
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
		
		appendIfUnique _shortcuts hot_keys
		
		callback_escaped = substituteString callback "'" "\\\""
		
		_callbacks[(findItem _shortcuts hot_keys)] = #( callback_escaped )
	),

	/** Remove modifier keys
	  *
	  * @param	array	hot_keys	dotNet hotkeys E.G.:  #(#ControlKey, #LControlKey, #Q) 
	  *
	  * @return	array	E.G.: #(#Q) 
	 */
	function _removeModifierKeys hot_keys =
	(
		--format "\n"; print "DialogHotkeys_v._removeModifierKeys()"
		mod_keys	= #(#ControlKey, #LControlKey, #RControlKey, #ShiftKey, #LShiftKey, #RShiftKey, #Alt )

		for hot_key in hot_keys where findItem mod_keys hot_key == 0 collect hot_key
	),




	private

	/**  
	 */
	on create do
	(
		format "\n"; print "DialogHotkeys_v.onCreate()"

	)
)