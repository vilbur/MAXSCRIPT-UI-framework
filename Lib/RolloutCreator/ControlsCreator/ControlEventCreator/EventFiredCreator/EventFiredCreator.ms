/** Each control event fires global variable EventFired
  *
  * Properties of EventFired
  * 	Type:	name of event
  * 	Control:	control which has fired this event
  * 	Control:	control which has fired this event
  * 	[val]:	value of control

  * 	[inspin, ...]: Any additional parameter fired with event specific for type of control
  *
  *
  *
  * @return	string E.G.: execute ("struct EventFired_v(Type,Control)"); global EventFired = EventFired_v type:#buttonDown Control:#SPINNER_Test_spinner
 */
struct EventFiredCreator_v
(
	/* required */
	_RolloutClass,	-- Rollout of control
	_RolloutControl,	-- Control itself

	/* properties */
	params,

	/** Get event
	 */
	function getEventFired Event =
	(
		--print "EventFiredCreator_v.getEventFired()"
		--format "RolloutControl	= % \n" RolloutControl
		this.params = filterString Event.params " "

	    EventFired_string = (this._defineStruct()) + "\n\t global EventFired = EventFired_v Type:#"+Event.type+" Roll:"+ _RolloutClass +" Control:"+ _RolloutControl +" "+(this._getParams())
		--format "\n";format "EventFired_string:	% \n" EventFired_string

		EventFired_string --return
	),


	private

	/** _define struct
	 */
	function _defineStruct =
	(
		struct_def = "struct EventFired_v(Type,Roll,Control"+(this._getProperties())+")"

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
		--format "_RolloutClass:	% \n" _RolloutClass
	)
)

global EventFired_v = undefined -- here is casted generated struct
global EventFired   = undefined -- here is stored instance of EventFired_v