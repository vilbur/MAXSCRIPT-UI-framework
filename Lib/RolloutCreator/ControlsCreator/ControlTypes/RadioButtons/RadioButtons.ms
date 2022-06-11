/** Changes of defaults 3Ds Max radio buttons
	
	1) Buttons are set to row in default
	
	2) Buttons are UNSELECTABLE, choose same button again and buttons will be unselected if parameter #unselect == true E.G.: params:#( #UNSELECT,true )

	3) Parameter #offset can be set only as single Point2 value, not necessary define it for each column E.G.:  params:#(#OFFSETS, [8, 16] )
	
 */
struct RadioButtons_v
(
	--__construct = #( #property_name ),

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	_Control,
	
	/** Set params
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
	 */
	function getEvents _Control =
	(
		--format "\n"; print "RadioButtons_v.getEvents()"
		Events	= #()
		Event =  Event_v type: #changed
		
		save_state_var = this._getSaveStateVariableName(_Control.id)
		--format "**********************************************************"
		--format "SAVE_STATE_VAR	= % \n" SAVE_STATE_VAR
		--Event.code = "
		Event.code = " print \"CHANGED\"
			if val == "+save_state_var+" then 
				"+(_Control.id as string) +".state = val = 0
				
			"+save_state_var+" = val"
		
		append Events Event
		
		Events --return
	),
	
	private
	
	/** 1) Move parameter #items to parameter #labels
	  * 2) Delete parameter #items 
	 */
	function _setLabels =
	(
		--format "\n"; print "RadioButtons_v.setLabels()"
		if _Control.Params.getVal #labels == undefined then 
		(
			_Control.Params.setVal #labels (_Control.Params.getVal #items)

			_Control.Params.delete #items
		)
	),
	
	/**  Set columns same count as labels
	  */
	function _setButtonsToRow =
	(
		labels	= _Control.Params.getVal #labels

		if _Control.Params.getVal #columns == undefined then
			_Control.Params.setVal #columns labels.count
	),
		
	/** Set offsets for each button
	 */
	function _setOffsets =
	(
		--format "\n"; print "RadioButtons_v.setOffsets()"
		--format "_Control	= % \n" _Control.caption

		labels  = _Control.Params.getVal #labels
		columns = _Control.Params.getVal #columns
		offsets = _Control.Params.getVal #offsets

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

			_Control.Params.setVal #offsets offsets_all
		)
	),

	/** Make unselectable radiobuttons
	  * 
	  * Add variable to store previous state
	  * 
	  */
	function _makeUnselectAble =
	(
		format "\n"; print "RadioButtons_v._makeUnselectAble()"
		if( ( unselectable = _Control.Params.getVal #unselect ) != undefined and unselectable == true ) then
		(
			default	= _Control.Params.getVal #default

			init_state = if( default != undefined ) then default else 1
			format "init_state	= % \n" init_state
			_Control.addLocal( this._getSaveStateVariableName(_Control.id) as name ) init_state
			
			_Control.Params.delete #unselect
		)
	),
	
	/** Get save state variable name
	 */
	function _getSaveStateVariableName control_id =
	(
		--format "\n"; print "RadioButtons_v._getSaveStateVariableName()"
		control_id as string + "_prev_state" --return
	),
	/**  
	 */
	on create do
	(
		--print("RadioButtons_v.onCreate()")
	)
)