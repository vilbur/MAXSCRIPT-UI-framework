/** Slider
 */
struct Slider_v
(
	/* construct */


	/* required */


	/* properties */
	_Control,

	/* private */
	/* dependency */
	/* reference */
	/* inhered */

	/** Set locals for custom events
	 */
	function setLocalsForCustomEvents &_Control =
	(
		--format "\n"; print "Slider_v.setLocalsForCustomEvents()"

		this._Control = _Control
		--
		prev_value_variable = (_Control.id as string + "_events")
		--
		--_Control.type = #editText
		--
		_Control.addlocal ( prev_value_variable as name ) "#{}" -- E.G.:  #BROWSEPATH_id_prev_state = ""

		--------history_path = getINISetting (GetMAXIniFile()) (this._getParam #historyCategory) "History_00"

		_Control --return
	),

	/**
	  *
	  * Add local variable in rollout to store buttons state E.G.: BTN_id_last_state
	  */
	function getEvent _Control event_type =
	(
		format "\n"; print "ControlEventCreator_v.getCallback()"
		--prev_value_variable = (_Control.id as string + "_prev_state")

		/* MAKE UNSELECTABLE if param #UNSELECTABLE == true  */
		if event_type == #CHANGED then
		(
			Event = Event_v type:event_type

			--save_state_var = this._getSaveStateVariableName(_Control.id)
			--format "save_state_var: %\n" save_state_var
			/* ADD LOCAL VARIABLE */
			--_Control.addlocal ( save_state_var as name ) ""

			callback = "print\"XXXX\""
			--format "CALLBACK: %\n" CALLBACK
			Event.callback[#code] = callback

			Event --return
		)
	),


	private


	/**
	 */
	on create do
	(
		--format "\n"; print "Slider.onCreate()"
		--for prop in #(  ) where getProperty this prop == undefined do -- CHECK CONSTRUCT PROPERTIES -- Array of this struct properties necessary to run
		--	throw ("\n\n\nUNDEFINED CONSTRUCT PROPERTY\n\n\nSTRUCT:\n\n"+ ((filterString( classof this as string )"(:")[2]) +"\n\n\nPROPERTY:\n\n"+ prop )
	)

)
