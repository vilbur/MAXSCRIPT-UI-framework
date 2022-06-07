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
	Controls_in_row,
	across_left,

	fake_control_caption = "",
	--fake_control_caption = "FAKE", -- DEV
	
	/** Fill end of row with fake controls to keep layout
	 */
	function createRows &_Controls =
	(
		--format "\n"; print ("AcrossParameterModifier_v.addFakeControls()" )
		
		Controls_in_row = _Controls.list
		
		_Controls.list	= #()

		local across_last = 0

		local across_left = 0

		local position_in_row = 0
		
		for i = 1 to Controls_in_row.count do
		(
			_Control = Controls_in_row[i]

			across_current	=  if( (across_param = _Control.Params.getVal #across) != undefined ) then across_param else across_last
			--format "ACROSS_CURRENT	= % \n" ACROSS_CURRENT
			if (ACROSS_CHANGED = across_current != across_last) then
				this._addFakeControls (_Controls)(across_last - position_in_row  ) -- fake_control_caption:("Row End left: "+across_left as string ) -- DEBUG PARAM
			
			position_in_row = if ACROSS_CHANGED or position_in_row >= across_current then 1 else position_in_row+1
			
			--_Control.caption = position_in_row as string + "  of " + across_current as string + " " + ACROSS_CHANGED as string + " " + _Control.caption -- DEBUG
			append _Controls.list _Control
			
			if (CONTROL_IS_LAST_IN_GROUP = Controls_in_row.count == i and across_current > 1) then
				this._addFakeControls (_Controls)(across_last - position_in_row )
			
			across_last = across_current
		)
		
		_Controls --return 
	),
	

	private
	

	/** _add fake controls
	*/
	function _addFakeControls _Controls fake_count fake_control_caption:fake_control_caption =
	(
		--print "AcrossParameterModifier_v._addFakeControls()"
		for i = 1 to fake_count do
			this._createFakeControl (_Controls) (fake_control_caption)
	),
	   
	/** _create fake control
	 */
	function _createFakeControl _Controls fake_control_caption =
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