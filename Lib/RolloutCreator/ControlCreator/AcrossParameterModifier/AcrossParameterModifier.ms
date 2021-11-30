/** AcrossParameterModifier_v
 */
struct AcrossParameterModifier_v
(
	
	--fake_control_caption = "",     -- PRODUCTION
	fake_control_caption = "FAKE", -- SHOW FAKE CONTROL IN UI FOR DEBUG

	/** 
	 */
	function _acrossParameterModify &_Controls =
	(
		--print "ControlCreator_v._acrossParameterModify()"
		_Controls_list_copy	= deepCopy  _Controls.list
		next_control_start_new_row	= true

		for control_count = 1 to _Controls.list.count do
		(
			across_current	=  _Controls.list[control_count].Params.getVal #across
			across_previous	= this._modifyAcrossParameter (_Controls.list[control_count]) (across_current) (across_previous)
			
			position_in_row	= this._getControlPositionInRow(control_count)(across_previous)
			control_is_last_in_row	= this. _isControlLastInRow (position_in_row) (across_previous)
			
			if( next_control_start_new_row ) then
				_Controls.list[control_count].Params.setVal #across across_previous
			

			if(	(next_control_exists	= _Controls.list[control_count+1]) != undefined and
				(next_control_across_changed	= (across_current != next_control_exists.Params.getVal #across)) and
				(fake_controls_count	= this._getFakeControlsCount(position_in_row)(across_previous))	> 0 ) then
		
						for i = 1 to fake_controls_count do
							insertItem (this._createFakeControl _Controls) _Controls_list_copy (control_count+i)

			next_control_start_new_row = if ( control_is_last_in_row ) then true else false
		)

		_Controls.list = _Controls_list_copy

		_Controls --return 
	),

	
	private
	
	
	/** Delete across_current parameter if Control has same as previous
	  * or set new across_current value if control has new value
	 */
	function _modifyAcrossParameter _Control across_current across_previous =
	(
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