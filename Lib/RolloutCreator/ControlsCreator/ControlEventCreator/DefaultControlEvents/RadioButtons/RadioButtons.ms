/** CHANGE DEFAULT BEHAVIOUR OF RADIOBUTTONS

	1) Buttons are set to row in default

	2) Buttons are UNSELECTABLE, choose same button again and buttons will be unselected if parameter #unselect == true E.G.: params:#( #UNSELECT,true )

	3) Parameter #offset can be set only as single Point2 value, not necessary define it for each column E.G.:  params:#(#OFFSETS, [8, 16] )

 */
struct RadioButtons_v
(

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	_Control,

	/** Convert custom controls to native maxscript controls
	  *
	  * CALLED IN:  "ControlCreator_v._customizeControlTypes()"
	 */
	function setParams _Control =
	(
		--format "\n"; print "RadioButtons_v.setParams()"
		this._Control = _Control

		this._setLabels()

		this._setButtonsToRow()

		this._setOffsets()

		this._makeUnselectAble()
	),

	/** Make radiobuttons unselectable
	  *
	  * Add local variable in rollout to store buttons state E.G.: BTN_id_last_state
	  */
	function getEvent _Control event_type =
	(
		--format "\n"; print "ControlEventCreator_v.getCallback()"

		/* MAKE UNSELECTABLE if param #UNSELECTABLE == true  */
		if event_type == #CHANGED and ( unselectable = _Control.Params[#UNSELECT] ) != undefined and unselectable == true then
		(
			Event = Event_v type:event_type

			callback = ""

			save_state_var = this._getSaveStateVariableName(_Control.id)

			/* ADD LOCAL VARIABLE */
			_Control.addlocal ( save_state_var as name ) ""

			/* GET CALLBACK CODE STRING */
			--callback += "format( @"+save_state_var+":%\\n@ ) "+save_state_var+" -- DEBUG\n\n"
			callback += "if val == "+save_state_var+" then    -- if checked radiobutton is clicked again"
			callback += "\n	"+(_Control.id as string) +".state = val = 0          -- then unselect buttons"

			callback += "\n\n"+save_state_var+" = val             -- store value"

			callback += "\n\nEventFired.val = val\n"
			--format "CALLBACK: %\n" CALLBACK
			Event.callback = callback

			Event --return
		)
	),

	private

	/** 1) Move parameter #items to parameter #labels
	  * 2) Delete parameter #items
	 */
	function _setLabels =
	(
		--format "\n"; print "RadioButtons_v.setLabels()"
		if _Control.Params[#labels] == undefined then
		(
			_Control.Params[#labels] = (_Control.Params[#items] )

			RemoveDictValue _Control.Params #items
			--_Control.Params.delete #items
		)
	),

	/**  Set #columns parameter same count as labels
	  */
	function _setButtonsToRow =
	(
		labels	= _Control.Params[#labels] 

		if _Control.Params[#columns] == undefined then
			_Control.Params[#columns] = labels.count
	),

	/** Set offsets for each button
	 */
	function _setOffsets =
	(
		--format "\n"; print "RadioButtons_v.setOffsets()"
		--format "_Control	= % \n" _Control.caption

		labels  = _Control.Params[#labels] 
		columns = _Control.Params[#columns] 
		offsets = _Control.Params[#offsets] 

		offsets_all = #()

		controls_in_row  = 0
		row_offset       = 0

		if( offsets != undefined and classof offsets == Point2 ) then
		(
			for i = 1 to labels.count do
			(
				controls_in_row = if controls_in_row == columns then 1 else controls_in_row + 1

				row_offset = if controls_in_row == 1 then row_offset + offsets.y else row_offset

				append offsets_all [offsets.x, row_offset]
			 )

			_Control.Params[#offsets] = offsets_all
		)
	),

	/** Make unselectable radiobuttons
	  *
	  * Add variable to store previous state
	  *
	  */
	function _makeUnselectAble =
	(
		--format "\n"; print "RadioButtons_v._makeUnselectAble()"

		if( ( unselectable = _Control.Params[#UNSELECT] ) != undefined and unselectable == true ) then
		(
			default	= _Control.Params[#default] 

			init_state = if( default != undefined ) then default else 1

			_Control.addLocal( this._getSaveStateVariableName(_Control.id) as name ) init_state

			RemoveDictValue _Control.Params #unselect
			--_Control.Params.delete #unselect
		)
	),

	/** Get save state variable name
	  *
	  *
	  * @return string "{Control.id}_last_state" E.G.: BTN_id_last_state
	 */
	function _getSaveStateVariableName control_id =
	(
		--format "\n"; print "RadioButtons_v._getSaveStateVariableName()"
		--format "control_id	= % \n" control_id
		control_id as string + "_last_state" --return
	),
	/**
	 */
	on create do
	(
		--print("RadioButtons_v.onCreate()")
	)
)