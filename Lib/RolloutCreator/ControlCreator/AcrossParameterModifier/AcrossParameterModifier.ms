/* *	Make across parameter works as columns
  *
  * REASON:	Across parameter ignores new value unless it completes his row
  * WHAT IS DONE:	Fake controls are generated to complete and fill row of previous across
  *
 */
struct AcrossParameterModifier_v
(

	fake_control_caption = "",     -- PRODUCTION
	--fake_control_caption = "--------", -- SHOW FAKE CONTROL IN UI FOR DEBUG

	--_Controls,
	_across_last,
	_across_left,

	/** 
	 */
	function _acrossParameterModify &_Controls =
	(
		--print ("ControlCreator_v._acrossParameterModify() "+_Controls.group as string )
		
		_Controls_list_copy	= #()
		
		for control_count = 1 to _Controls.list.count do
		(
			--format "\n"
			_Control =  _Controls.list[control_count]
			--print ("_Control.id = " + _Control.id)
			across_current	=  _Control.Params.getVal #across
			--format "across_current = % \n" across_current
			--format "_across_last	= % \n" _across_last
			--format "_across_left	= % \n" _across_left

			if( new_row_start = (_across_left == 0) ) then 
				_across_left = across_current
			
			if( _across_left == undefined ) then -- buttons works
				_across_left = across_current
			
			if( _across_last == undefined ) then
				_across_last = across_current
			
			if( across_has_changed = (across_current != _across_last) ) then
			(
				--format "new_row_start	= % \n" new_row_start
				--format "across_has_changed	= % \n" across_has_changed
				--format "_across_left	= % \n" _across_left

				if( new_row_start == false ) then
			
					this._addFakeControls (_Controls) (_Controls_list_copy) (_across_left) --fake_control_caption:("next: "+_Control.caption)
									
					
					
				_across_last = _across_left = across_current
				
			)
			else if ( control_is_not_first = (_across_left != across_current)  ) then 
				 _Control.Params.delete #across
			
			if( _across_left != undefined ) then
				_across_left -= 1

			/* ADD CONTROL TO NEW LIST */ 
			append _Controls_list_copy _Control

		)
		
		/* ADD FAKE CONTROLS TO OF PREVIOUS GROUP TO FILL ROW */
		if( _across_left != undefined ) then
			this._addFakeControls  (_Controls) (_Controls_list_copy) (_across_left) --fake_control_caption:("group end" )
		
		_across_left	= undefined -- allow set for new group
		
		
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
				_RolloutCreator.addControl "label" ("label"+ (random 1 99999 ) as string ) fake_control_caption
		
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
		_Controls.control #label fake_control_caption id:("label"+ (random 1 99999 ) as string ) add_to_controls:false --return	
	),

	/**  
	 */
	on create do
	(
		--print "AcrossParameterModifier_v.on create do()"

	)	
)