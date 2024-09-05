/** Slider
 */
struct Slider_v
(
	/* construct */


	/* required */


	/* properties */
	_Control,

	/* private */
	suffix_local_var = "_changes",

	var_name,

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
		prev_value_variable = (_Control.id as string + suffix_local_var)
		--
		--_Control.type = #editText
		--
		--_Control.addlocal ( prev_value_variable as name ) #() -- E.G.:  #BROWSEPATH_id_prev_state = ""

		--------history_path = getINISetting (GetMAXIniFile()) (this._getParam #historyCategory) "History_00"

		_Control --return
	),

	/**
	  *
	  * Add local variable in rollout to store buttons state E.G.: BTN_id_last_state
	  */
	function getEvent _Control event_type =
	(
		--format "\n"; print "Slider_v.getCallback()"
		this._Control = _Control

		this._setVarName()

		if  _Control.Events[#LEFTCLICK] != undefined then
		(
			case event_type of
			(
				#BUTTONDOWN:	 this._getButtonDownEvent()
				#CHANGED:	 this._getChangedEvent()
				#BUTTONUP:	 this._getButtonUpEvent()
			)
		)
	),


	private

	/** Get button down event
	 */
	function _getButtonDownEvent =
	(
		--format "\n"; print "Slider_v._getButtonDownEvent()"
		_Control.addlocal var_name #() -- E.G.:  #BROWSEPATH_id_prev_state = ""

		Event = Event_v type:#BUTTONDOWN

		Event.callback[#code] = var_name + " = #( "+_Control.id+".value )" -- save current value of slider

		Event --return
	),

	/** Get changed event
	 */
	function _getChangedEvent =
	(
		format "\n"; print "Slider_v.getChangeDEvent()"
		/* ADD LOCAL VARIABLE */
		--_Control.addlocal var_name "XXX" -- E.G.:  #BROWSEPATH_id_prev_state = ""
		control = _Control.getFullId()

		--if ( Event =  _Control.Events[#CHANGED] ) == undefined then
			Event = Event_v type:#CHANGED

		--callback =  var_name +"+= val as string"
		callback = ""

		--callback = "print " + var_name + " as string"
		--callback =  ";print val as string;"
		callback = "append "+var_name+" val\n"
		--callback += ";print " + var_name + " as string"
		--callback += control + ".value   = val + 1 \n"

		callback +=  "/*------ INCREMENTAL STEP BY TICK ON LEFTCLICK --fixed default behaviour ------*/\n"
		callback += "if "+var_name+".count == 2 then
		(
			increment_direction = if "+var_name+"[2] > "+var_name+"[1] then 1 else -1

			tick_step = " + control + ".range.y / (" + control + ".ticks + 1)
			tick_step = 1
			
			format @tick_step:%@ tick_step

		    "+control + ".value   = "+var_name+"[1] + (tick_step * increment_direction)

		)\n"


		--Event.callback[#code] += callback
		Event.callback[#code] = callback

		Event --return
		--undefined  --return
	),

	/** Get changed event
	 */
	function _getButtonUpEvent =
	(
		format "\n"; print "Slider_v.getChangeDEvent()"
		--Event = Event_v type:#BUTTONUP
		Event = Event_v type:#BUTTONUP params: "changes"

		control = _Control.getFullId()

		/* TEST */
		leftclick_exist = _Control.Events[#LEFTCLICK] != undefined
		slide_exist     = _Control.Events[#SLIDE]     != undefined

		/* SNIPPETS */
		code_leftclick = if not leftclick_exist then "\"\"" else _Control.Events[#LEFTCLICK].callback[#CODE]
		code_slide     = if not slide_exist     then "\"\"" else _Control.Events[#SLIDE].callback[#CODE]

		case_leftclick = if not leftclick_exist then "" else
		"1: #LEFTCLICK	-- buttondown > buttonup
		 \t2: #LEFTCLICK	-- buttondown > changed > buttonup"

		case_default = if not slide_exist then "\"\"" else "#SLIDE	-- buttondown > changed > changed > buttonup"

		/* SAVE CHANGED VALUES */
		callback = "EventFired.changes = "+var_name + "\n"

		/* MODIFY EVENT TYPE */
		callback += "EventFired.type = case "+var_name+ ".count of
		(
			"+case_leftclick+"
			default: "+case_default+"
		)\n"

		/* CALL CALLBACK BY EVENT TYPE */
		callback += "case EventFired.type of
		(
			#LEFTCLICK: "+code_leftclick+"
			#SLIDE:     "+code_slide+"
		)\n"

		/* RESET ARRAY FOR NEXT EVENT */
		callback += var_name + " = #()\n"

		--callback += "increment_direction = if EventFired.changes.count == 2 and EventFired.changes[2] > EventFired.changes[1] then 1 else -1\n"

		--callback += "tick_step = " + control + ".range.y / (" + control + ".ticks + 1)\n"

		--callback += "format @tick_step:%@ tick_step\n"
		--callback += control + ".value   = EventFired.changes[1] + (tick_step * increment_direction) \n"
		callback += control + ".tooltip = "+control + ".value as string \n"


		/* SET CALLBACK TO EVENT */
		Event.callback[#code] = callback

		Event --return

	),

	/** Get var name
	 */
	function _setVarName =
	(
		var_name = _Control.id as string + suffix_local_var --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "Slider.onCreate()"
	)
)