/** Generate struct with  properties as evenet has
  *
  * @return	string E.G.: execute ("struct EventFired_v(type,Control)"); global EventFired = EventFired_v type:#buttonDown Control:#SPINNER_Test_spinner	
  * 
 */
struct EventFiredCreator_v
(
	/* required */
	control_id,
	
	/* properties */
	params,
	
	/** Get event
	 */
	function getEventFired event_type params =
	(
		this.params = filterString params " "
		
	    (this._defineStruct()) + "; global EventFired = EventFired_v type:#"+event_type+" Control:#"+control_id as string +" "+(this._getParams())
	    --(this._defineStruct()) + "; global EventFired = EventFired_v type:#"+event_type+" Control:#"+control_id as string +" "+(this._getParams()) + ";format \"!!! EventFired	= % \n\" EventFired;"
	),
	
	
	private 
	
	/** _define struct
	 */
	function _defineStruct =
	(
		
		struct_def = "struct EventFired_v(type,Control"+(this._getProperties())+")"
		
		"execute (\""+struct_def+"\")" --return
	),
	
	/** _add properties
	 */
	function _getProperties =
	(
		properties = ""
		
		for param in params do 
			properties += "," + param
			
		properties --return
	),
	
	/** _add properties
	 */
	function _getParams =
	(
		params_join = ""
		
		for param in params do 
			params_join += param +":" + param +" "
			
		params_join --return
	),

	on create do
	(
	)
)

global EventFired = undefined