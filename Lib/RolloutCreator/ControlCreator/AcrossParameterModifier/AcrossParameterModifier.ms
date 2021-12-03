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

	_columns_in_row	= undefined,
	_columns_empty	= undefined,

	/** 
	 */
	function _acrossParameterModify &_Controls =
	(
		print ("ControlCreator_v._acrossParameterModify() "+_Controls.group as string )
		format "_columns_in_row	= % \n" _columns_in_row
		format "_columns_empty	= % \n" _columns_empty
		_Controls_list_copy	= #()
		--this_start_new_row	= true

		/* ADD FAKE CONTROLS TO OF PREVIOUS GROUP TO FILL ROW */
		if( _columns_in_row != undefined  and _columns_empty != undefined ) then
		(
			print "NEW GROUP"
			
			this._addFakeControls  (_Controls) (_Controls_list_copy) (_columns_empty)   --print "ADD FAKE CONTROLS TO OF PREVIOUS GROUP TO FILL ROW"
			_columns_in_row	= undefined
			_columns_empty	= undefined
		)

		for control_count = 1 to _Controls.list.count do
		(

			_Control =  _Controls.list[control_count]
			--format "\n"
			format "\n"
			--format "_Control.id	= % \n" _Control.id
			print ("_Control.id = " + _Control.id)
			--format "_Control.Params	= % \n" _Control.Params
			across_current	=  _Control.Params.getVal #across
			format "across_current = % \n" across_current 
			
			--_columns_in_row	= this._setColumnsInRow (_Control) (across_current) (_columns_in_row)
			if( _columns_in_row == undefined ) then
				_columns_in_row = across_current
			format "_columns_in_row = % \n" _columns_in_row

			--_position	= this._getNewPositionInRow(_position)
			if( _columns_empty == undefined or _columns_empty <= 0 ) then
				_columns_empty = _columns_in_row
			format "_columns_empty  = % \n" _columns_empty


			columns_width	= _columns_in_row / across_current
			format "columns_width  = % \n" columns_width

			--if( this_start_new_row ) then
				--_Control.Params.setVal #across _columns_in_row

			is_control_fit_to_row	= columns_width <= _columns_empty 
			format "is_control_fit_to_row = % \n" is_control_fit_to_row

			if not( is_control_fit_to_row ) then
			(
				this._addFakeControls (_Controls) (_Controls_list_copy) (_columns_empty)
				_columns_in_row = undefined 	
			)
		
			/* ADD MODIFICATED CONTROL */ 
			append _Controls_list_copy _Control

			_columns_empty -= columns_width


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
		--format "_columns_empty = % \n" _columns_empty
		--format "_columns_in_row   = % \n" _columns_in_row
		--if( _columns_empty != _columns_empty ) then
			--for i = 1 to (fake_count = this._getFakeControlsCount(_columns_empty)(_columns_in_row)) do
			for i = 1 to fake_count do
				append _Controls_list_copy (this._createFakeControl _Controls)

		_columns_empty --return
	),

	/** Delete across_current parameter if Control has same as previous
	  * or set new across_current value if control has new value
	 */
	function _setColumnsInRow _Control across_current _columns_in_row =
	(
		--print "AcrossParameterModifier_v._setColumnsInRow()"
		--format "across_current	= % \nacross_previous	= % \n" across_current _columns_in_row
		if( across_current != _columns_in_row ) then
			--format "!!! TEsT	= % \n" (across_current != _columns_in_row) 			
			_columns_in_row = across_current

		else 
			_Control.Params.delete #across

		--format "RESULT _columns_in_row= % \n" _columns_in_row
		_columns_in_row --return
	),

	/** _get control position in row
	 */
	function _getNewPositionInRow _columns_empty =
	(
		print "AcrossParameterModifier_v._getNewPositionInRow()"
		format "!_columns_empty	= % \n!_columns_in_row	= % \n" _columns_position _columns_in_row

		if( _columns_position == undefined ) then
			1 -- return

		--one_column = 1 / _columns_in_row as float
		--
		----if( _columns_position == undefined  or _columns_in_row == undefined ) then
		--if( _columns_position == undefined ) then
		--	one_column
		--	
		--else
		--	one_column += one_column
		--else
	),

	/** _is control last in row
	 */
	function _isControlLastInRow _columns_position =
	(
		(floor _columns_position == _columns_position ) -- test if control is last control in row
	),

	/** _get fake controls count
	 */
	function _getFakeControlsCount _columns_position _columns_in_row =
	(
		print "AcrossParameterModifier_v._getFakeControlsCount()"
		fake_count =  ((ceil _columns_position - _columns_position) * _columns_in_row) --return
		format "fake_count	= % \n" fake_count

		fake_count --return
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
		print "AcrossParameterModifier_v.on create do()"

	)	
)