/** Browse path is edittext control with default event which browse path
  * 
  * Event is fired if edit text field is empty
  * 
  *  Fired with keys ENTER|SPACE|TAB
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
	function getEvents _Control =
	(
		--print "BrowsePath_v.getControl()"
		this._Control = _Control
		
		Events	= #()
		
		local_variable_name = (_Control.id + "_prev_state")
		
		
		/* Get existing event or create new */
		for event_type in #( #changed, #entered ) do 
		(
			Event = if( (Event = _Control.Events.get event_type) != undefined ) then Event else (Event_v type:event_type )
			--format "Event.code	= % \n" Event.code
			Event.code = "\n\tfunction valueIsEmpty _string =
				(
					(( dotNetClass @System.Text.RegularExpressions.RegEx@).matches _string @^\s+$|^$@ ).count == 1
				)
				
				if( valueIsEmpty(val) and valueIsEmpty("+local_variable_name+") ) then
					if( (browsed_path = "+ this._getPathDialog() +") != undefined ) do
					(
						"+_Control.id+".text    = browsed_path
						"+_Control.id+".tooltip = browsed_path
					
						val = EventFired.val    = substituteString browsed_path @\\\\@ @\\\\\\\\@
					
						"+ Event.code +"        -- Fire custom event with browsed variable
					)
				else
					(
						"+local_variable_name+" = "+_Control.id+".text
						"+_Control.id+".tooltip = browsed_path
					)"
	
			append Events Event
			--_Control.Events.replace Event
		)

		Events --return
	),
	
	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	function mutateControl &_Control =
	(
		print "BrowsePath_v.mutateControl()"
		this._Control = _Control
		this._setDefaultParams()

		local_variable_name = (_Control.id + "_prev_state")

		_Control.type = #editText
		
		_Control.addlocal ( local_variable_name as name ) "\"\"" -- E.G.:  #BROWSEPATH_id_prev_state = ""

		--history_path = getINISetting (GetMAXIniFile()) (this._param #historyCategory) "History_00"

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
					--#caption:	_Control.caption
					#historyCategory:	this._param #mode
					#initialDir:	"C:/"
					#types:	"All files|*.*|"
					default: ""
				)
				
			) replace:false
	),
	

	
	/** Get dialog getSaveFileName|getOpenFileName  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C
	  * 
	  * @return	string joined parameters for dialog	e.g.: "getSavePath caption:"my title""
	 */
	function _getPathDialog =
	(
		--print "BrowsePath_v._getPathDialog()"
		path_dialog = this._param #mode 
			
		for param in browse_params where (val = this._param param ) != "" and param != #mode do
			path_dialog += " " + param as string +":@"+ val +"@"
		--format "path_dialog = % \n" path_dialog
		path_dialog --return	
	),
	
	/** _param
	 */
	function _param key =
	(
		--print "BrowsePath_v._param()"
		(_Control.Params.getVal key ) as string --return
	),
	
	/**  
	 */
	on create do
	(

	)
)