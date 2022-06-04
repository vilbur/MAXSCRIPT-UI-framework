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
	fake_control_caption = "",
	--fake_control_caption = "FAKE", -- DEV
	
	/** Fill end of row with fake controls to keep layout
	 */
	function addFakeControls &_Controls =
	(
		--format "\n"; print ("AcrossParameterModifier_v.addFakeControls()" )
		_Controls_list_copy	= #()

		local across_last

		--format " _Controls.list = % \n"  _Controls.list
	
		for control_count = 1 to _Controls.list.count do
		(
			_Control =  _Controls.list[control_count]

			--if( (control_is_not_in_group_box = _Control.Params.getVal #GroupBox) == undefined ) then
			--(
				across_current	=  _Control.Params.getVal #across
				
				if( across_current == undefined and across_last != undefined  ) then -- get across of previous control, so only first control in row must have across parameter defined
					across_current = across_last
				
				if( new_row_start = (_across_left == 0) ) then 
					_across_left = across_current
	
				if( _across_left == undefined ) then
					_across_left = across_current
	
				if( _controls_in_row == undefined ) then
					_controls_in_row = across_current
	
	
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
				
			--)
			
			across_last = across_current
			
			/* ADD CONTROL TO NEW LIST */ 
			append _Controls_list_copy _Control
		)
		--format "_Controls_list_copy.count	= % \n" _Controls_list_copy.count
		/* ADD FAKE CONTROLS TO END OF GROUP TO FILL ROW
		
				LOOP
		*/
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
				_RolloutCreator.addControl "Fake" (this._generateId()) fake_control_caption

		_across_left = 0
	),

	private

	/** _add fake controls
	 */
	function _addFakeControls _Controls &_Controls_list_copy fake_count fake_control_caption:fake_control_caption=
	(
		--print "AcrossParameterModifier_v._addFakeControls()"
		--format "fake_count	= % \n" fake_count
		for i = 1 to fake_count do
			append _Controls_list_copy (this._createFakeControl (_Controls) (fake_control_caption))
	),

	/** _create fake control
	 */
	function _createFakeControl _Controls fake_control_caption =
	(
		--print "AcrossParameterModifier_v._createFakeControl()"
		_Control = _Controls.control #label fake_control_caption id:(this._generateId()) --add_to_controls:false --return
		--format "FakeControl	= % \n" _Control.id	
		
		_Control --return
	),
	
	/** _get fake control id
	 */
	function _generateId =
	(
		--"fake"+ (timeStamp())  as string 
		"fake"+  (random 1 999999999 )  as string 
	),
	
	/**  
	 */
	on create do
	(
		--print "AcrossParameterModifier_v.on create do()"

	)	
)