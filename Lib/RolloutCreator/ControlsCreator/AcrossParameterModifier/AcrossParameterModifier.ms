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
	Controls_in_group,

	
	across_current,
	across_last = 0,
	position_in_row = 0,

	--fake_control_caption = "",
	fake_control_caption = "FAKE", -- DEV
	
	/** Fill end of row with fake controls to keep layout
	 */
	function addFakeControls &_Controls =
	(
		format "\n\n\n"; print ("AcrossParameterModifier_v.addFakeControls()" )
		format "_CONTROLS.GROUP	= % \n" _Controls.group
		
		this._Controls = _Controls
		
		Controls_in_group = _Controls.list
		
		_Controls.list	= #()

		
		for i = 1 to Controls_in_group.count do
		(
			format "\n"; format "_Control	= % \n" Controls_in_group[i].caption
			
			this._setAcrossOfCurrentControl(Controls_in_group[i])
			
			this._fillEndOfRow(position_in_row)
			
			this._setPositionInRow()

			append _Controls.list Controls_in_group[i]
			
			if Controls_in_group.count == i and across_current > 1 then
				this._fillEndOfGroup()

			across_last = across_current
		)
		
		--this._addFakeControls (_Controls)(3) fake_control_caption:"test"
		across_current	= undefined
		across_last	= 0
		position_in_row	= 0
		
		_Controls --return 
	),
	

	private
	
	/** Get current across
	 */
	function _setAcrossOfCurrentControl _Control =
	(
		--format "\n"; print "AcrossParameterModifier_v._setAcrossOfCurrentControl()"
		across_current = if( (across_param = _Control.Params.getVal #across) != undefined ) then across_param else across_last --return 
	),
	
	/** Fill end of row
	 */
	function _fillEndOfRow position_in_row =
	(
		--format "\n"; print "AcrossParameterModifier_v._fillEndOfRow()"
		if (across_current != across_last) then -- if across parameter has changed
			--this._addFakeControls(across_last - position_in_row  ) -- fake_control_caption:("ROW END left: "+ (across_last - position_in_row) as string ) -- DEBUG PARAM
			this._addFakeControls(across_last - position_in_row  ) fake_control_caption:("ROW END left: "+ (across_last - position_in_row) as string ) -- DEBUG PARAM
		
	),
	
	/** If control is last in group, then add fake controls to fill group
	 */
	function _fillEndOfGroup =
	(
		--format "\n"; print "AcrossParameterModifier_v._fillEndOfGroup()"
		--this._addFakeControls(across_last - position_in_row ) -- fake_control_caption:("GROUP END left: "+ (across_last - position_in_row) as string ) -- DEBUG PARAM
		this._addFakeControls(across_last - position_in_row ) fake_control_caption:("GROUP END left: "+ (across_last - position_in_row) as string ) -- DEBUG PARAM
	),

	
	
	/** Get position in row
	 */
	function _setPositionInRow =
	(
		--format "\n"; print "AcrossParameterModifier_v._getPositionInRow()"
		position_in_row = if across_current != across_last or position_in_row >= across_current then 1 else position_in_row+1
	),
	
	/** _add fake controls
	*/
	function _addFakeControls fake_controls_count fake_control_caption:fake_control_caption =
	(
		print "AcrossParameterModifier_v._addFakeControls()"
		format "fake_controls_count	= % \n" fake_controls_count
		--fake_controls_count = 2
		for i = 1 to fake_controls_count do
			this._createFakeControl(fake_control_caption)
	),
	   
	/** _create fake control
	 */
	function _createFakeControl fake_control_caption =
	(
		--print "AcrossParameterModifier_v._createFakeControl()"
		_Control = _Controls.control #label fake_control_caption id:(this._generateId()) --add_to_controls:false --return
		
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