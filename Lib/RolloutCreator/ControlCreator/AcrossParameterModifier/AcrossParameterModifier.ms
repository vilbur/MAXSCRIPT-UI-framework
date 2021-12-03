/* *	Make across parameter works as columns
  *
  * REASON:	Across parameter ignores new value unless it completes his row
  * WHAT IS DONE:	Fake controls are generated to complete and fill row of previous across
  *
 */
struct AcrossParameterModifier_v
(

	--fake_control_caption = "",     -- PRODUCTION
	fake_control_caption = "--------", -- SHOW FAKE CONTROL IN UI FOR DEBUG

	_across_last,
	_across_left,

	/** 
	 */
	function _acrossParameterModify &_Controls =
	(
		--print ("ControlCreator_v._acrossParameterModify() "+_Controls.group as string )
		_Controls_list_copy	= #()

		/* ADD FAKE CONTROLS TO OF PREVIOUS GROUP TO FILL ROW */
		if( new_group_start = _across_left != undefined ) then
		(
			this._addFakeControls  (_Controls) (_Controls_list_copy) (_across_left)   --print "ADD FAKE CONTROLS TO OF PREVIOUS GROUP TO FILL ROW"
			
			_across_last	= undefined
			_across_left	= undefined
		)
		
		for control_count = 1 to _Controls.list.count do
		(
			--format "\n"
			--print ("_Control.id = " + _Control.id)
			_Control =  _Controls.list[control_count]
			across_current	=  _Control.Params.getVal #across
			--format "across_current = % \n" across_current
			
			if( _across_left == undefined or _across_left <= 0 ) then
				_across_left = across_current
			
			if( _across_last == undefined ) then
				_across_last = across_current
			
			if( across_has_changed = (across_current != _across_last) ) then
			(

				if( (control_is_first      = _across_left   == across_current) and
				   (control_is_full_width = across_current == 1) )
				then 
					this._addFakeControls (_Controls) (_Controls_list_copy) (_across_left)
					
				else

				
				if( (preious_control_is_not_full_width = ( _across_last > 1)) and
				   (control_is_not_first              = (_across_left != across_current)) )
				then 
					this._addFakeControls (_Controls) (_Controls_list_copy) (_across_left)
					
					
				_across_last = _across_left = across_current
			)
			else if ( control_is_not_first = (_across_left != across_current)  ) then 
				 _Control.Params.delete #across
			
			_across_left -= 1

			/* ADD MODIFICATED CONTROL */ 
			append _Controls_list_copy _Control

		)
		_Controls.list = _Controls_list_copy

		_Controls --return 
	),

	private

	/** _add fake controls
	 */
	function _addFakeControls _Controls &_Controls_list_copy fake_count =
	(
		print ("AcrossParameterModifier_v._addFakeControls("+fake_count as string +")") 
		for i = 1 to fake_count do
			append _Controls_list_copy (this._createFakeControl _Controls)
	),

	/** _create fake control
	 */
	function _createFakeControl _Controls =
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