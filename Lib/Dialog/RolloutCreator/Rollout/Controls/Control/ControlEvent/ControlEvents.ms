/** Control event
 */
struct ControlEvents_v
(
	--__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	

	/** Set event by type
	  * 
	  * @property	#name	type	of callback #pressed|#rightclick|#changed|#entered|#buttondown|#buttonup 
	  * @param	string	callback	code executed on event
	  * @param	string	tooltip	tooltip for control
	  * @property	string	params	for callback
	  * 
	  * @return	object Control	
	 */
	function add type callback tooltip params:"" =
	(
		--print ( "ControlEvent_v.setEvent()" )

		--format "type:% callback:\"%\" tooltip:\"%\" params:%\n" type callback tooltip params
		--format "Events.event_types	= % \n" Events.event_types
		
		if not( this.Events._isEventExists(type) ) then 
			this._exception(type)
		
		this.Events._setCallbackParamters &params type
		this.Events._addFunctionBrackets  &callback params
		--format "callback	= % \n" callback
		--format "params	= % \n" params

		_EventFired = this.Events.getEventFired type:type id:(Parent_Control.getId())
		  
		this.Events.add (Event_v type:type code:(_EventFired + callback) tooltip:tooltip params:params)
		
		--this._addToStartupEvents type callback -- IMPORTANT FIX THIS !!!!!! 
		
		Parent_Control --return
	),
	
	private
	
	/**  
	 */
	on create do
	(
		print("ControlEvent_v.onCreate()")
	)
)