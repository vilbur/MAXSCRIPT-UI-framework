/** Control custom type
 */
struct ControlCustomType_v
(	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	
	/** Get custom control type
	 */
	function getCustomControlType _Control =
	(
		--print "ControlCustomType_v.getCustomControlType()"
		if( _Control.type == #browsePath ) then 
			this._browsePath(_Control) --return
	),

	private
	
	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	function _browsePath _Control =
	(
		print "ControlCustomType_v.browsePath()"
		_Control.type = #editText
		
		_Control.addlocal #edit_text_prev_state "\"\""

		/* Get existing event or create new */
		for event_type in #( #changed, #entered ) do 
		(
			Event = if( (Event = _Control.Events.get event_type) != undefined ) then Event else (Event_v type:event_type )
			
			Event.code = "(
					
				function valueIsEmpty _string =
				(
					(( dotNetClass @System.Text.RegularExpressions.RegEx@).matches _string @^\s+$|^$@ ).count == 1
				)
				
				if( valueIsEmpty(val) and valueIsEmpty(edit_text_prev_state) ) then
					if( (val = getSavePath caption:@browse path@ initialDir:@$scripts@) != undefined ) do
					(
						"+_Control.id+".text = val
						"+ Event.code +" -- fire custom event with browsed variable
					)
				else
					edit_text_prev_state = "+_Control.id+".text
			)"
			
			_Control.Events.replace Event
		)

		_Control --return
	),
	
	
	/**  
	 */
	on create do
	(
	)
)