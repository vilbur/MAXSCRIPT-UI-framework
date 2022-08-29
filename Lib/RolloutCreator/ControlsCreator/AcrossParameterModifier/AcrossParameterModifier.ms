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
	_Controls,

	List_new = #(),

	index,
	across_current,
	across_last	= 0,
	position_in_row	= 0,
	
	--DEBUG = true,
	--DEBUG = false,
	
	/** Fill end of row with fake controls to keep layout
	 */
	function addFakeControls &_Controls =
	(
		----format "\n\n\n"; print ("AcrossParameterModifier_v.addFakeControls()" )		
		this._Controls = _Controls
	
		--controls_count = _Controls.list.count
		
		for i = 1 to _Controls.list.count do
		(
			--format "\n--------------------------------------\n\n_CONTROL: % \n\n" _Controls.list[i].caption
			index = i
			
			this._setAcrossOfCurrentControl(_Controls.list[i])
			--format "index	= % \n" index
			--format "across_current	= % \n" across_current
			--format "across_last	= % \n" across_last
			
			controls_left	= across_last - position_in_row
			
			this._setPositionInRow()
			--format "position_in_row	= % \n" position_in_row
								 
			this._fillEndOfRowBeforeControl(controls_left)

			across_last = across_current
			
			append List_new _Controls.list[i]
			
			if this._isLastControl() then
				this._fillEndOfGroup()
		)
		
		_Controls.List = List_new
		
		_Controls --return 
	),
	

	private
	
	
	/** Get current across
	 */
	function _setAcrossOfCurrentControl _Control =
	(
		----format "\n"; print "AcrossParameterModifier_v._setAcrossOfCurrentControl()"
		across_current = if( (across_param = _Control.Params.getVal #across) != undefined ) then across_param else across_last --return 
	),
	
	/** Fill end of row
	 */
	function _fillEndOfRowBeforeControl controls_left =
	(
		--format "\n"; print "AcrossParameterModifier_v._fillEndOfRowBeforeControl()"
		across_changed = this._acrossChanged()
		
		if( across_changed and controls_left > 0 ) then
			this._addFakeControl( controls_left  ) fake_control_caption:(if DEBUG then "ROW END left: "+ (controls_left) as string else "")
	),
	
	/** If control is last in group, then add fake controls to fill group
	  * Then next group will start where it should
	 */
	function _fillEndOfGroup =
	(
		--format "\n"; print "AcrossParameterModifier_v._fillEndOfGroup()"
		this._addFakeControl(across_current - position_in_row ) fake_control_caption:(if DEBUG then "GROUP END left: "+ (across_current - position_in_row) as string else "")
	),

	/** Find out if control is last in list
	 */
	function _isLastControl =
	(
		--format "\n"; print "AcrossParameterModifier_v._isLastControl()"
		--format "controls_count	= % \n"  _Controls.list.count
		--format "index	= % \n" index
		--format "_isLastControl	= % \n" ( _Controls.list.count == index)
		 _Controls.list.count == index  --return
	),
	
	/** Get position in row
	 */
	function _setPositionInRow =
	(
		----format "\n"; print "AcrossParameterModifier_v._setPositionInRow()"
		----format "across_current != across_last	= % \n" (across_current != across_last)
		----format "position_in_row >= across_current	= % \n" (position_in_row >= across_current)
		position_in_row = if across_current != across_last or position_in_row >= across_current then 1 else position_in_row+1
	),
	
	/** _across changed
	 */
	function _acrossChanged =
	(
		--format "\n"; print "AcrossParameterModifier_v._acrossChanged()"
		if across_last != 0  then -- IF CONTROL IS FIRST AND SECOND CONTROL SHOULD BE IN NEXT ROW
			across_current != across_last --return
		
		else
			false --return
	),
	
	/** _add fake controls
	*/
	function _addFakeControl fake_controls_count fake_control_caption:"" =
	(
		--print "AcrossParameterModifier_v._addFakeControl()"
		--format "fake_controls_count	= % \n" fake_controls_count
		--format "fake_control_caption	= % \n" fake_control_caption
		for i = 1 to fake_controls_count do
			append List_new (this._createFakeControl(fake_control_caption))
			--insertItem (this._createFakeControl(fake_control_caption)) _Controls.list (index) 
	),
	
	
	/** _create fake control
	 */
	function _createFakeControl fake_control_caption =
	(
		--print "AcrossParameterModifier_v._createFakeControl()"
		_Controls.control #label fake_control_caption id:(this._generateId()) add_to_controls:false --return
	),
	
	/** _get fake control id
	 */
	function _generateId =
	(
		"fake" + (random 1 999999999 )  as string 
	),
	
	/**  
	 */
	on create do
	(
	)	
)