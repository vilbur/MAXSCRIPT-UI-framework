/** Slider
 */
struct Slider_v
(
	/* construct */


	/* required */


	/* properties */
	_Control,

	/* private */
	--suffix_local_var = "_changes",

	changes_var,
	changed_event_blocked,

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

		_Control.addlocal changes_var #()
		_Control.addlocal changed_event_blocked false

		--if  _Control.Events[#LEFTCLICK] != undefined then
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

		Event = Event_v type:#BUTTONDOWN

		Event.callback[#code] = changes_var + " = #( "+_Control.id+".value )" -- save current value of slider

		Event --return
	),

	/** Get changed event
	 */
	function _getChangedEvent =
	(
		--format "\n"; print "Slider_v.getChangeDEvent()"
		/* ADD LOCAL VARIABLE */
		--_Control.addlocal changes_var "XXX" -- E.G.:  #BROWSEPATH_id_prev_state = ""
		callback = ""
		--callback = "print \"************************************* CHANGE *************************************\"\n"

		Event = Event_v type:#CHANGED

		control = _Control.getFullId()

		changed_event_exist = _Control.Events[#CHANGED] != undefined


		--block_event      = changed_event_blocked+" = true"
		--else_unblock_event = "\nelse\n	"+changed_event_blocked+" = false\n"

		--callback += "	format @changed_event_blocked:%\\n@ " +changed_event_blocked + "\n\n"

		callback += "	append "+changes_var+" val\n"
		--callback += "	format @CHANGES:%\\n@ " +changes_var


		/* BLOCK CHANGED CALLBACK AFTER MANUAL SET  */
		--callback = "if not "+changed_event_blocked+" then\n(\n"	+ callback+ "\n)\n"

		--if not changed_event_exist then
			--callback += else_unblock_event

		--Event.callback[#code] += callback
		Event.callback[#code] = callback


		/* BLOCK CUSTOM CALLBACK IF CHENGED EVENT IS BLOCKED */
		--if changed_event_exist then
			--_Control.Events[#CHANGED].callback[#code]  = "if not "+changed_event_blocked+" then\n(\n\t" + _Control.Events[#CHANGED].callback[#code] + "\n\t" + block_event + "\n)"+ else_unblock_event

		Event --return
	),

	/** Get changed event
	 */
	function _getButtonUpEvent =
	(
		format "\n"; print "Slider_v.getChangeDEvent()"
		--Event = Event_v type:#BUTTONUP
		Event = Event_v type:#BUTTONUP params: "changes"

		control = _Control.getFullId()


		block_event      = changed_event_blocked+" = true"
		else_unblock_event = "\nelse\n	"+changed_event_blocked+" = false\n"

		/* TEST */
		changed_event_exist   = _Control.Events[#CHANGED] != undefined
		slide_event_exist     = _Control.Events[#SLIDE]     != undefined
		leftclick_event_exist = _Control.Events[#LEFTCLICK] != undefined

		/* SNIPPETS */
		 code_leftclick = if not leftclick_event_exist then "" else "\n#LEFTCLICK: (" + _Control.Events[#LEFTCLICK].callback[#CODE]+ ")"
		 code_slide     = if not slide_event_exist     then "" else "\n#SLIDE: (" + _Control.Events[#SLIDE].callback[#CODE]+ ")"
		 --code_change    = if not changed_event_exist   then "" else"\n#CHANGED: (" + _Control.Events[#CHANGED].callback[#CODE]+ ")"

		--case_leftclick = if not leftclick_event_exist then "" else
		--"1: #LEFTCLICK	-- buttondown > buttonup
		-- \t2: #LEFTCLICK	-- buttondown > changed > buttonup"

		--case_default = if not slide_event_exist then "\"\"" else "#SLIDE	-- buttondown > changed > changed > buttonup"

		callback = ""
		--callback = "print \"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ BUTTON UP @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\"\n"
		/* SAVE CHANGED VALUES */
		callback += "EventFired.changes = "+changes_var + "\n"

		/* MODIFY EVENT TYPE */

		--if leftclick_event_exist or slide_event_exist then
		--	callback += "EventFired.type = case "+changes_var+ ".count of
		--	(
		--		"+case_leftclick+"
		--		default: "+case_default+"
		--	)\n"

			callback += "event_type_mutated = case "+changes_var+ ".count of
		(
			1: #LEFTCLICK	-- buttondown > buttonup
			2: #LEFTCLICK	-- buttondown > changed > buttonup
			default: #SLIDE
		)\n"

			callback += "\nslide_event_exist     = "+slide_event_exist as string
			callback += "\nchanged_event_exist   = "+changed_event_exist as string
			callback += "\nleftclick_event_exist = "+leftclick_event_exist as string

			callback += "\n\nEventFired.type = case of
		(
			(slide_event_exist     and event_type_mutated == #SLIDE ):	#SLIDE
			(leftclick_event_exist and event_type_mutated == #LEFTCLICK ):	#LEFTCLICK

			default: #CHANGE
		)\n"


			callback +=  "\n	/*------ INCREMENTAL STEP BY TICK ON LEFTCLICK --fixed default behaviour ------*/\n"

		--	callback += "	if "+changes_var+ ".count == 2 then
		--(
		--	increment_direction = if "+changes_var+"[2] > "+changes_var+"[1] then 1 else -1
		--
		--	tick_step = " + control + ".range.y / (" + control + ".ticks + 1)
		--	tick_step = 1
		--
		--	"+ block_event +"
		--	print \"         SET VALUE \"\n
		--
		--
		--	"+control + ".value   =  "+changes_var+"[1] + (tick_step * increment_direction) -- increase\decrease slider value
		--
		--)\n"


			/* FIRE UP CALLBACK BY EVENT TYPE */
			if leftclick_event_exist or slide_event_exist then
				callback += "\ncase EventFired.type of
				(
					"+code_leftclick+"
					"+code_slide+"
				)\n"

			/* RESET ARRAY FOR NEXT EVENT */
			callback += changes_var + " = #()\n"



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
		changes_var = _Control.id as string + "_changes" --return

		changed_event_blocked = _Control.id as string + "_changed_event_blocked" --return
	),

	/**
	 */
	on create do
	(
		--format "\n"; print "Slider.onCreate()"
	)
)