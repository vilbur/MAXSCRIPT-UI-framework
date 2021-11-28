/** Generate Controls from ".mcr" files
 */
struct ContentControlCreator_v
(
	__construct = #(  ),
	
	/* required */
	ControlBox,
	Macro,
	ControlEventsCreator = ControlEventsCreator_v(),
	/** Create Control in Controls
	  *
	  * 
	 */
	function createControl =
	(
		--format "\n"
		--print "ControlCreator_v.createControl()"
		
		params = substituteString (Macro.getParams())  "'" "\""
		
		_Control = ControlBox.control (Macro.getType()) Macro.buttontext  id:(Macro.getControlId()) add_to_controls:false
		
		if( (_Control_Exist = ControlBox.get(_Control.id)) != undefined ) then
			_Control = _Control_Exist -- update existing control
		
		_Control = this._setControlEvent _Control _Control_Exist
		
		if ( _Control != _Control_Exist ) then -- add only new control
			ControlBox.add _Control
	),

	private
	
	/** Set control event
	  *
	  * @return	#event_type	E.G.: #pressed|#righclick|#selected
	 */
	function _setControlEvent _Control _Control_Exist =
	(
		--print "ControlCreator_v._setControlEvent()"
		event_type = this._getEventType (_Control)
		
		this._setOnClickEvent (event_type) (_Control)
		
		_Control --return
	),
	
	/** Get type of event by occurence of macro in ".mcr" file
	  *
	  * Event types are ordered by arrays in ControlEventsCreator.event_types
	  *
	  * @return	#type_of_event	
	 */
	function _getEventType _Control =
	(
		--print "ContentControlCreator_v._getEventType()"
		if( (event_type = Macro.getParam "event") == undefined ) then
			event_type = (ControlEventsCreator._getEventsOfControl (_Control.type))[ _Control.Events.list.count+1]
		
		event_type as name
	),
	
	/** Set events which call macro
	 */
	function _setOnClickEvent event_type _Control =
	(
		--format "ControlCreator_v._setOnClickEvent event_type	= % \n" event_type
		callback = "macros.run \""+Macro.category+"\" \""+Macro.macro_name+"\""

		_Control.Event event_type callback tooltip:Macro.toolTip
	),
	
	/**  
	 */
	on create do
	(
		this.createControl()
	)
	
)


