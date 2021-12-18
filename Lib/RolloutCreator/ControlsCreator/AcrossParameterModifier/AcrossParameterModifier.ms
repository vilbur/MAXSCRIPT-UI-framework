/* *	Make across parameter works as columns
  *
  * REASON:	Across parameter ignores new value unless it completes his row
  * WHAT IS DONE:	Fake controls are generated to complete and fill row of previous across
  *
  * IMPORTANT: Controls in groupboxes are IGNORED
  *
 */
struct AcrossParameterModifier_v
(
	_controls_in_row,
	_across_left,

	/** 
	 */
	function addFakeControls &_Controls =
	(
		--format "\n"; print ("AcrossParameterModifier_v._acrossParameterModify()" )
		--format "_Controls	= % \n" _Controls.List.count
		
		--for __control__ in _Controls.List do 
			--format "__control__	= % \n" __control__
		--return false -- DEBUG
		
		_Controls_list_copy	= #()

	
		for control_count = 1 to _Controls.list.count do
		(
			_Control =  _Controls.list[control_count]
			
			if( (control_is_not_in_group_box = _Control.Params.getVal #GroupBox) == undefined ) then
			(
				across_current	=  _Control.Params.getVal #across
	
				if( new_row_start = (_across_left == 0) ) then 
					_across_left = across_current
	
				if( _across_left == undefined ) then
					_across_left = across_current
	
				if( _controls_in_row == undefined ) then
					_controls_in_row = across_current
	
				--format "_controls_in_row	= % \n" _controls_in_row
	
				if( across_has_changed = (across_current != _controls_in_row) ) then
				(
					if( new_row_start == false ) then
						this._addFakeControls (_Controls) (_Controls_list_copy) (_across_left) --fake_control_caption:("next: "+_across_left as string )
	
					_controls_in_row = _across_left = across_current
	
				)
				else if ( control_is_not_first = (_across_left != across_current)  ) then 
					 _Control.Params.delete #across
	
				if( _across_left != undefined ) then
					_across_left -= 1
					--format "_across_left	= % \n" _across_left
				
			)

			/* ADD CONTROL TO NEW LIST */ 
			append _Controls_list_copy _Control
		)
		--format "_Controls_list_copy	= % \n" _Controls_list_copy
		/* ADD FAKE CONTROLS TO END OF GROUP TO FILL ROW */
		if( end_of_group = _across_left != undefined ) then
			this._addFakeControls  (_Controls) (_Controls_list_copy) (_across_left) --fake_control_caption:("group end" )

		_across_left	= undefined -- allow set for new group
		_controls_in_row	= undefined -- allow set for new group

		_Controls.list = _Controls_list_copy

		_Controls --return 
	),

	/** Starts new rollout
	 */
	function fakeControlsOnEndofGroup _RolloutCreator fake_control_caption:"" =
	(
		--print "AcrossParameterModifier_v.fakeControlsOnEndofGroup()"
		if( _across_left != undefined ) then
			for i = 1 to _across_left do
				--_RolloutCreator.addControl "label" ("label"+ (random 1 999999999 ) as string ) fake_control_caption
				_RolloutCreator.addControl "label" ("label"+ (timeStamp() ) as string ) fake_control_caption

		_across_left = 0
	),

	private

	/** _add fake controls
	 */
	function _addFakeControls _Controls &_Controls_list_copy fake_count fake_control_caption:"" =
	(
		for i = 1 to fake_count do
			append _Controls_list_copy (this._createFakeControl (_Controls) (fake_control_caption))
	),

	/** _create fake control
	 */
	function _createFakeControl _Controls fake_control_caption =
	(
		--print "AcrossParameterModifier_v._createFakeControl()"
		_Controls.control #label fake_control_caption id:("label"+ (random 1 999999999 ) as string ) --add_to_controls:false --return	
	),

	/**  
	 */
	on create do
	(
		--print "AcrossParameterModifier_v.on create do()"

	)	
)