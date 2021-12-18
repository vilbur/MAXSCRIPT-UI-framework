/** Generate struct with  properties as evenet has
  *
  * @return	string E.G.: execute ("struct EventFired_v(type,Control)"); global EventFired = EventFired_v type:#buttonDown Control:#SPINNER_Test_spinner	
  * 
 */
struct EventFiredCreator_v
(
	/* required */
	_Control,
	
	/* properties */
	params,
	
	/** Get event
	 */
	function getEventFired Event =
	(
		--print "EventFiredCreator_v.getEventFired()"
		this.params = filterString Event.params " "
		
	    EventFired_string = (this._defineStruct()) + "\n\t global EventFired = EventFired_v type:#"+Event.type+" Control:#"+_Control.id as string +" "+(this._getParams()) 

		EventFired_string --return
	),
	
	
	private 
	
	/** _define struct
	 */
	function _defineStruct =
	(
		struct_def = "struct EventFired_v(type,Control"+(this._getProperties())+")"
		
		"execute \""+struct_def+"\"" --return
	),
	
	/** _add properties
	 */
	function _getProperties =
	(
		properties = ""
		
		for param in this.params do 
			properties += "," + param
			
		properties --return
	),
	
	/** _add properties
	 */
	function _getParams =
	(
		--print "EventFiredCreator_v._getParams()"
		params_join = ""
		
		for param in this.params do 
			params_join += param +":" + param +" "
		--format "params_join = % \n" params_join
		params_join --return
	),

	on create do
	(
	)
)

global EventFired_v = undefined -- here is casted generated struct
global EventFired   = undefined -- here is stored instance of EventFired_v