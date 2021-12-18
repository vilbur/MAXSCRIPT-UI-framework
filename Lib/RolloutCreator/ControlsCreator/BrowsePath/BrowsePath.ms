/** Browse path is edittext control with default event which browse path
  * 
  * Event is fired if edit text field is empty and space is writen in it
  * 
  *  Fired with keys SPACE|BACKSPACE
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
	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	function getEvents _Control =
	(
		--print "BrowsePath_v.getControl()"
		this._Control = _Control
		
		Events	= #()
		
		prev_value_variable_name = (_Control.id + "_prev_state")
		
		this._setDefaultParams()

		/* Get existing event or create new */
		for event_type in #( #changed, #entered ) do 
		(
			--Event = if( (Event = _Control.Events.get event_type) != undefined ) then Event else (Event_v type:event_type )
			Event =  Event_v type:event_type

			/**  
			  *	TODO: function valueIsEmpty should be placed in rollout, but there is no problem with it
			  */
			Event.code = "\n\tfunction valueIsEmpty _string =
				(
					(( dotNetClass @System.Text.RegularExpressions.RegEx@).matches _string @^\s+$|^$@ ).count == 1
				)
				
				if( val != "+prev_value_variable_name+" and valueIsEmpty(val) and valueIsEmpty("+prev_value_variable_name+") ) then
				(
					if( (browsed_path = "+ this._getPathDialog() +") != undefined ) then
					(
						"+_Control.id+".text    = browsed_path as string 
						"+_Control.id+".tooltip = browsed_path as string 
					
						val = EventFired.val    = substituteString browsed_path @\\\\@ @\\\\\\\\@
					)
					else
						"+prev_value_variable_name+" = val 
				)
				else
					(
						"+prev_value_variable_name+" = "+_Control.id+".text
						"+_Control.id+".tooltip = browsed_path as string 
					)"
	
			append Events Event
		)
		
		Events --return
	),
	
	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	function mutateControl &_Control =
	(
		--print "BrowsePath_v.mutateControl()"
		this._Control = _Control
		
		prev_value_variable_name = (_Control.id + "_prev_state")

		_Control.type = #editText
		
		_Control.addlocal ( prev_value_variable_name as name ) "\"\"" -- E.G.:  #BROWSEPATH_id_prev_state = ""

		--history_path = getINISetting (GetMAXIniFile()) (this._getParam #historyCategory) "History_00"

		_Control --return
	),
	
	/** _set default params
	 */
	function _setDefaultParams =
	(
		--print "BrowsePath_v._setDefaultParams()"
		
		for param in browse_params do
			this._Control.Params.setVal(param)(
				case param of
				(
					#mode:	#getSavePath
					--#caption:	this._Control.caption
					#historyCategory:	this._getParam #historyCategory
					#initialDir:	"C:/"
					#types:	"All files|*.*|"
					default: undefined
				)
				
			)  unique:true
		
		this._Control.Params.filter undefined  test:true
	),
	
	/** Get dialog getSaveFileName|getOpenFileName  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C
	  * 
	  * @return	string joined parameters for dialog	e.g.: "getSavePath caption:"my title""
	 */
	function _getPathDialog =
	(
		--print "BrowsePath_v._getPathDialog()"
		--if( path_dialog = this._getParam #mode ) == undefined  then 
		path_dialog = (this._getParam #mode) as string
		--path_dialog = "getSavePath"
			
		for param in browse_params where (val = this._getParam param ) != undefined and param != #mode do
			path_dialog += " " + param as string +":@"+ val as string +"@"
		--format "path_dialog = % \n" path_dialog
		path_dialog --return	
	),
	
	/** _getParam
	 */
	function _getParam key =
	(
		--print "BrowsePath_v._getParam()"
		(_Control.Params.getVal key )--return
	),
	
	/**  
	 */
	on create do
	(

	)
)