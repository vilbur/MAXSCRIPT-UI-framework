/** Events default
 */
struct DefaultControlEvents_v
(
	/* properties */
	Events = #(),
	
	/** Add default event for Control
	  *
	 */
	function getEvents control_type =
	(
		print ("@@@@@@@@@@@@@ DefaultControlEvents_v.getEvents() "+control_type)

		if( control_type == #browsePath ) then
			--append Events ( Event_v type:#changed	code:("print \"DEFAULT EVENT\"") )
			append Events ( Event_v type:#changed	code:("print \"DEFAULT EVENT\"")  params:"val"  )
			
		Events --return
	),
	
	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	function getBrowsePath =
	(
		--print "DefaultControlEvents_v.getBrowsePath()"
		local_variable_name = (_Control.id + "_prev_state")

		_Control.type = #editText
		
		_Control.addlocal ( local_variable_name as name ) "\"\"" -- E.G.:  #BROWSEPATH_id_prev_state = ""

		--history_path = getINISetting (GetMAXIniFile()) (this._param #historyCategory) "History_00"
		
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
					);"
	
	
			_Control.Events.replace Event
		)

		_Control --return
	),
	
	/**  
	 */
	on create do
	(
		--print("EventsDefault_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
