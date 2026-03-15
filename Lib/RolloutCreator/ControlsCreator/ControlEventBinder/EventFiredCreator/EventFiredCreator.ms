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
	ControlString,	-- Control
	ControlClass,	-- Control object

	/* properties */
	params,

	/** Get event
	 */
	function getStructDefinition event_type params =
	(
		--print "EventFiredCreator_v.getStructDefinition()"
		
		/* GET PARAMS ARERAY */ 
		this.params = filterString params " "
		
		--ControlClass = execute ( _RolloutClass ControlString)
		--
		--format "classOf ControlClass: %\n" (  )
		--if classOf ControlClass == MultiListBoxControl then
		--	append this.params "selection"
			append this.params "TEST"
		--
		
		note_def	= "\n/*--- EventFired struct definition ---*/\n\n"
		struct_def	= "execute \"struct EventFired_v( Type, Roll, Control"+(this._getProperties())+ "," + (this._getMethods())+")\""

		note_set_global	= "\n/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/\n\n"
		set_global	= "global EventFired = EventFired_v Type:#"+event_type+" Roll:"+ _RolloutClass +" Control:"+ ControlString +" "+(this._getParams())


	   note_def + struct_def + "\n" + note_set_global + set_global

	),

	private

	/** _add properties
	 */
	function _getProperties =
	(
		print "EventFiredCreator_v._getProperties()"
		format "this.params: %\n" this.params
		properties = ""

		for param in this.params do
			properties += "," + param

		properties --return
	),

	/** Get construct properties for EventFired
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
