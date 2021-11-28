/** Control custom type
 */
struct BrowsePath_v
(	
	/* required */
	_Control,
	
	/* properties */
	browse_params = #( #mode, #caption, #initialDir, #types, #filename, #historyCategory ), -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C
	
	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	function getControl =
	(
		--print "ControlCustomType_v.browsePath()"
		_Control.type = #editText
		
		_Control.addlocal #edit_text_prev_state "\"\""
		--format "_Control.Params	= % \n" _Control.Params

		--history_path = getINISetting (GetMAXIniFile()) (this._param #historyCategory) "History_00"
		
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
					if( (val = "+ this._getPathDialog() +") != undefined ) do
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
	
	/** _set default params
	 */
	function _setDefaultParams =
	(
		--print "BrowsePath_v._setDefaultParams()"
		for param in browse_params do
			_Control.Params.setVal(param)(
				case param of
				(
					#mode:	#getSavePath
					#caption:	_Control.caption
					#historyCategory:	this._param #mode
					#initialDir:	"C:/"
					#types:	"All files|*.*|"
					default: ""
				)
				
			) replace:false
	),
	
	/** _param
	 */
	function _param key =
	(
		--print "BrowsePath_v._param()"
		(_Control.Params.getVal key ) as string --return
	),
	
	/** Get dialog getSaveFileName|getOpenFileName  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C
	  * 
	  * @return	string joined parameters for dialog	e.g.: "getSavePath caption:"my title""
	 */
	function _getPathDialog =
	(
		--print "BrowsePath_v._getPathDialog()"
		path_dialog = this._param #mode --
			
		for param in browse_params where (val = this._param param ) != "" and param != #mode do
			path_dialog += " " + param as string +":@"+ val +"@"
		--format "path_dialog = % \n" path_dialog
		path_dialog --return	
	),
	
	/**  
	 */
	on create do
	(
		this._setDefaultParams()
	)
)