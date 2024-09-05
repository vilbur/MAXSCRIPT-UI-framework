global EventFired_v = undefined -- here is casted generated struct
global EventFired   = undefined -- here is stored instance of EventFired_v

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
		--format "Event: %\n" Event
		--format "RolloutControl	= % \n" RolloutControl
		this.params = filterString Event.params " "

		note_def	= "\n/*--- EventFired definition ---*/\n\n"
		note_set_global	= "\n/*--- EventFired global ---*/\n\n"

		struct_def	= "execute \"struct EventFired_v(Type,Roll,Control"+(this._getProperties())+ "," + (this._getMethods())+")\""
		set_global	= "global EventFired = EventFired_v Type:#"+Event.type+" Roll:"+ _RolloutClass +" Control:"+ _RolloutControl +" "+(this._getParams())


	   note_def + struct_def + "\n" + note_set_global + set_global

	),

	private

	/** _add properties
	 */
	function _getProperties =
	(
		properties = ""

		for param in this.params do
			properties += "," + param

		properties --return
	),

	/** Get params passed to callback
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

	/** Get  Test if EventFired has property, if yes, the retur n value, else return false
	 */
	function _getMethods =
	(
		-- " function test val = ( print val  )"
		--print "EventFiredCreator_v._getParams()"
		" function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  )"
	),


	on create do
	(
		--format "_RolloutClass:	% \n" _RolloutClass
	)
)
