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
	ControlPath = "",	-- E.G.: "DIALOG_test.CBTN_checkbutton"
	control_type,
	--ControlClass,	-- Control object

	/* properties */
	params,

	/** Get event
	 */
	function getStructDefinition event_type params =
	(
		--format "\n"; print "EventFiredCreator_v.getStructDefinition()"
		
		/* GET PARAMS ARERAY */ 
		this.params = filterString params " "

		
		/* STRUCT DEFINITION  */ 
		note_def	= "\n/*--- EventFired struct definition ---*/\n\n"
		struct_def	= "execute \"struct EventFired_v( Type, Roll,\n	Control"+(this._getPropertyDefinition())+ ",\n" + (this._getMethods())+" on create do() )\""

		
		/* GET INSTANVE OF STRUCT */ 
		note_set_global	= "\n/*--- CAST INSTANCE TO GLOBAL VARIABLE ---*/\n\n"
		set_global	= "global EventFired = EventFired_v Type:#"+event_type+" Roll:"+ _RolloutClass +" Control:"+ ControlPath +" "+(this._getConstructPropsAndValues())

		
		/* CONCAT CODE */ 
		note_def + struct_def + "\n" + note_set_global + set_global
	),

	private

	/** Get struct property names
	 */
	function _getPropertyDefinition =
	(
		--format "\n"; print "EventFiredCreator_v._getPropertyDefinition()"
		properties = ""

		
		for param in this.params do
			properties += ",	\n" + param
		
		/* EXCEPTION FOR CONTROL TYPES */ 
		this._getPropsForControlType (&properties)

		properties --return
	),

	/** Get names and values of struct properties
	  
		@return string E.G.: "val:val foo:#BAR"
	 */
	function _getConstructPropsAndValues =
	(
		--print "EventFiredCreator_v._getConstructPropsAndValues()"
		
		params_join = ""

		for param in this.params do
			params_join += param +":" + param +" "
			
		params_join --return
	),

	/** Get specific props for each control type
	 */
	function _getPropsForControlType &properties =
	(
		--format "\n"; print "getStructDefinition._getPropsForControlType()"
		if ( props_by_type = this._getPropsByControlType() ) != undefined then 
			for prop_name in props_by_type.keys do
				properties += ",\n" + prop_name as string + " = " + props_by_type[prop_name]
		
		properties --return
	),
	
	/** Get props by control type
	  
		@return Dictionary KEY:#prop_name VALUE:"prop value"
	 */
	function _getPropsByControlType =
	(
		/* GET STRINGS OF SELECTED ITEMS */
		if control_type == #multiListBox then
			Dictionary #( #selection, "for i in Control.selection collect Control.items[i]"  ) --return
	),
	
	/** Get  Test if EventFired has property, if yes, the retur n value, else return false
	 */
	function _getMethods =
	(
		-- " function test val = ( print val  )"
		--print "EventFiredCreator_v._getConstructPropsAndValues()"
		"function get prop = ( if hasProperty this ( prop as name ) then getProperty this ( prop as name ) else false  ),\n"
	),

	on create do
	(
		--format "_RolloutClass:	% \n" _RolloutClass
	)
)
