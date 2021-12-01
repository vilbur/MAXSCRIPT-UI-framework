/** AcrossParameterModifier_v
 */
struct AcrossParameterModifier_v
(
	
	fake_control_caption = "",     -- PRODUCTION
	--fake_control_caption = "FAKE", -- SHOW FAKE CONTROL IN UI FOR DEBUG
		position_in_row	= 0,
		across_previous	= undefined,

	/** 
	 */
	function _acrossParameterModify &_Controls =
	(
		format "\n"
		print ("ControlCreator_v._acrossParameterModify() "+_Controls.group as string )
		_Controls_list_copy	= #()
		next_control_start_new_row	= true
		controls_in_row	= 0
		--position_in_row	= 0
		--format "position_in_row	= % \n" position_in_row
		--format "controls_in_row	= % \n" controls_in_row
		--format "across_previous	= % \n" across_previous
		
		this._addFakeControls  (_Controls) (_Controls_list_copy) (position_in_row) (controls_in_row) (across_previous)
		
		for control_count = 1 to _Controls.list.count do
		(
			_Control =  _Controls.list[control_count]
			
			controls_in_row += 1
			
			across_current	=  _Control.Params.getVal #across
			across_previous	= this._modifyAcrossParameter (_Control) (across_current) (across_previous)

			
			position_in_row	= this._getControlPositionInRow(controls_in_row)(across_previous)
			control_is_last_in_row	= this._isControlLastInRow (position_in_row) (across_previous)
			format "position_in_row	= % \n" position_in_row
			if( next_control_start_new_row ) then
				_Control.Params.setVal #across across_previous
			
			append _Controls_list_copy _Control

			if(	(next_control_exists	= _Controls.list[control_count+1]) != undefined and
				(next_control_across_changed	= (across_current != next_control_exists.Params.getVal #across)) and
				(fake_controls_count	= this._getFakeControlsCount(position_in_row)(across_previous))	> 0 )
			then
				for i = 1 to fake_controls_count do
					append _Controls_list_copy (this._createFakeControl _Controls)
					
					
			next_control_start_new_row = if ( control_is_last_in_row ) then true else false
			
			if( next_control_start_new_row ) then 
				controls_in_row = 0
		)
		_Controls.list = _Controls_list_copy

		_Controls --return 
	),

	
	private
	
	/** _add fake controls
	 */
	function _addFakeControls _Controls &_Controls_list_copy position_in_row controls_in_row across_previous =
	(
		--print "AcrossParameterModifier_v._addFakeControls()"
		
		if( position_in_row != controls_in_row and across_previous != undefined  ) then
			for i = 1 to (this._getFakeControlsCount(position_in_row)(across_previous)) do
				append _Controls_list_copy (this._createFakeControl _Controls)
	),
	
	
	/** Delete across_current parameter if Control has same as previous
	  * or set new across_current value if control has new value
	 */
	function _modifyAcrossParameter _Control across_current across_previous =
	(
		print "AcrossParameterModifier_v._getControlPositionInRow()"
		format "across_current	= % \n" across_current
		if( across_current != across_previous ) then 
			across_previous = across_current
		else
			_Control.Params.delete #across
		
		across_previous --return
	),
	
	/** _get control position in row
	 */
	function _getControlPositionInRow control_count across_previous =
	(
		print "AcrossParameterModifier_v._getControlPositionInRow()"
		format "control_count	= % \nacross_previous	= % \n" control_count across_previous
		control_count / across_previous as float
	),
	
	/** _is control last in row
	 */
	function _isControlLastInRow position_in_row across_previous =
	(
		(floor position_in_row == position_in_row ) -- test if control is last control in row
	),
	
	/** _get fake controls count
	 */
	function _getFakeControlsCount position_in_row across_previous =
	(
		((ceil position_in_row - position_in_row) * across_previous) as integer
	),
	
	/** _create fake control
	 */
	function _createFakeControl _Controls =
	(
		_Controls.control #label fake_control_caption id:("label"+ (random 1 99999 ) as string ) add_to_controls:false --return	
	),
	
	
	
	/**  
	 */
	on create do
	(
	)	
)