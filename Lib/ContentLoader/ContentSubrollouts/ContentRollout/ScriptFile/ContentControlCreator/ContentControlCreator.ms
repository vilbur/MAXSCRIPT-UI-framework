/** Generate Controls from ".mcr" files
 */
struct ContentControlCreator_v
(
	
	/* required */
	_Rollout,
	_Controls,
	Macro,

	ControlEventBinder = ControlEventBinder_v _Rollout:_Rollout,
	/** Create Control in Controls
	  * 
	 */
	function createControl =
	(
		--format "\n"
		--print "ContentControlCreator_v.createControl()"
		
		_Control = _Controls.control (Macro.getType()) Macro.buttontext params:(Macro.getParamsArray()) add_to_controls:false
		--_Control = _Controls.control (Macro.getType()) Macro.buttontext  id:(Macro.getControlId()) add_to_controls:false
		--format "_Control	= % \n" _Control
		if( (_Control_Exist = _Controls.get(_Control.id)) != undefined ) then
			_Control = _Control_Exist -- update existing control
		
		_Control = this._setControlEvent _Control _Control_Exist
		
		if ( _Control != _Control_Exist ) then -- add only new control
			_Controls.add _Control
	),

	/** Get controls
	 */
	function getControls =
	(
		_Controls --return
	),
	
	private
	
	/** Set control event
	  *
	  * @return	#event_type	E.G.: #pressed|#righclick|#selected
	 */
	function _setControlEvent _Control _Control_Exist =
	(
		--print "ContentControlCreator_v._setControlEvent()"
		if( (event_type = this._getEventType (_Control)) != undefined ) then
			this._setEventCallMacro (event_type) (_Control) 
		
		_Control --return
	),
	
	/** Get type of event by occurence of macro in ".mcr" file
	  *
	  * Event types are ordered by arrays in ControlEventBinder.event_types
	  *
	  * @return	#type_of_event	
	 */
	function _getEventType _Control =
	(
		--print "ContentControlCreator_v._getEventType()"
		--format "_Control.type	= % \n" _Control.type
		control_type_for_events = case _Control.type of
		(
			#browsePath:	#edittext
			default:	_Control.type
		)
		
		if( (event_type = Macro.getParam "event") == undefined ) then
			event_type = (ControlEventBinder.EventTypes.getEventTypesOfControl (_Control.type))[ _Control.Events.list.count+1]

			
		if( event_type != undefined ) then
			event_type as name --return	
			
	),
	
	/** Set events which call macro
	 */
	function _setEventCallMacro event_type _Control =
	(
		--format "ContentControlCreator_v._setEventCallMacro event_type	= % \n" event_type
		callback = "(macros.run \""+Macro.category+"\" \""+Macro.macro_name+"\")"
		--format "event_type	= % \n" event_type
		--format "CALLBACK	= % \n" callback
		--callback = "print \"TEST\";"

		_Control.Event event_type callback tooltip:Macro.toolTip
	),
	
	/**  
	 */
	on create do
	(
		this.createControl()
	)
	
)


