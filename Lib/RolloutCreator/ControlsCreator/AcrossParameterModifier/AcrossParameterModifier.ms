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

	--fake_control_caption = "",
	fake_control_caption = "FAKE", -- DEV
	
	/** Fill end of row with fake controls to keep layout
	 */
	function createRows &_Controls =
	(
		format "\n"; print ("AcrossParameterModifier_v.addFakeControls()" )
		
		Controls_in_row = _Controls.list
		
		_Controls.list	= #()
		local across_last

		/** get count of controlsin row
		 */
		function getCountOfControlsinRow across_current =
		(
			format "\n"; print "AcrossParameterModifier_v.getCountOfControlsinRow()"
			if( controls_in_row == undefined ) then
				controls_in_row = across_current
			
			controls_in_row --return
		)

		/** _add fake controls
		*/
	   function _addFakeControls _Controls fake_count fake_control_caption:fake_control_caption across: =
	   (
			print "AcrossParameterModifier_v._addFakeControls()"
			for i = 1 to fake_count do
				this._createFakeControl (_Controls) (fake_control_caption) across
	   )
	   
		--NEW_ROW_START = true
		across_left = 0

		position_in_row = 0
		
		for i = 1 to Controls_in_row.count do
		(
			_Control = Controls_in_row[i]
			--format "\n"
			--format "_Control.id      = % \n" _Control.id
			across_current	=  if( (across_param = _Control.Params.getVal #across) != undefined ) then across_param else across_last
			
			 
			ACROSS_CHANGED = across_last != undefined and (across_current != across_last)

			if ACROSS_CHANGED then
			(
				across_left = across_last - position_in_row 

				_addFakeControls _Controls(across_left ) across:across_last
				--_addFakeControls _Controls(across_left ) across:across_last fake_control_caption:("Row End left: "+across_left as string )
			)
			

			position_in_row = if ACROSS_CHANGED or position_in_row >= across_current then 1 else position_in_row+1

			--_Control.caption = position_in_row as string + "  of " + across_current as string + " " + ACROSS_CHANGED as string + " " + _Control.caption -- DEBUG


			append _Controls.list _Control
			
			
			if Controls_in_row.count == i and across_current > 1 then
			(
				across_left = across_last - position_in_row 

				--_addFakeControls _Controls(across_left) across:across_left fake_control_caption:("Group End last: "+across_last as string )
				_addFakeControls _Controls(across_left) across:across_left
			)
			
			
			across_last = across_current
		)
		

		across_left	= 0 -- allow set for new group
		position_in_row	= 0 -- allow set for new group
		
		_Controls --return 
	),
	
	/** Fill end of row with fake controls to keep layout
	 */
	function addFakeControlsBAK &_Controls =
	(
		--format "\n"; print ("AcrossParameterModifier_v.addFakeControls()" )
		_Controls_list_copy	= #()

		local across_last

		--format " _Controls.list = % \n"  _Controls.list
	
		for control_count = 1 to _Controls.list.count do
		(
			_Control =  _Controls.list[control_count]
			format "\n_Control.id	= % \n" _Control.id

			--if( (control_is_not_in_group_box = _Control.Params.getVal #GroupBox) == undefined ) then
			--(
			
				across_current	=  _Control.Params.getVal #across
				format "across_current	= % \n" across_current
				
				--if( across_current == "row" ) then -- get across of previous control, so only first control in row must have across parameter defined
				--(
				--	across_current = undefined
				--	_Control.Params.delete #across
				--	
				--)
				
				--if( across_current == undefined and across_last != undefined  ) then -- get across of previous control, so only first control in row must have across parameter defined
				if( across_current == undefined ) then -- get across of previous control, so only first control in row must have across parameter defined
					across_current = across_last
				
				
				/*
					
				  
				*/
				
				
				
				
				
				if( NEW_ROW_START = (across_left == 0) ) then 
					across_left = across_current
					
					
	
				if( across_left == undefined ) then
					across_left = across_current
					
	
	
				if( count_in_row == undefined ) then
					count_in_row = across_current
	
	
	
				if( ACROSS_HAS_CHANGED = (across_current != count_in_row) ) then
				(
					if( NEW_ROW_START == false ) then
						this._addFakeControls (_Controls) (_Controls_list_copy) (across_left) --fake_control_caption:("next: "+across_left as string )
	
					count_in_row = across_left = across_current
	
				)
				else if ( CONTROL_IS_NOT_FIRST = (across_left != across_current)  ) then 
					 _Control.Params.delete #across
	
	
	
				if( across_left != undefined ) then
					across_left -= 1
				
			--)
			
			
			across_last = across_current
			
			/* ADD CONTROL TO NEW LIST */ 
			append _Controls_list_copy _Control
		)
		--format "_Controls_list_copy.count	= % \n" _Controls_list_copy.count
		/* ADD FAKE CONTROLS TO END OF GROUPBOX TO FILL ROW
		
				LOOP
		*/
		if( END_OF_GROUP = across_left != undefined ) then
			this._addFakeControls  (_Controls) (_Controls_list_copy) (across_left) --fake_control_caption:("group end" )

		across_left	= undefined -- allow set for new group
		count_in_row	= undefined -- allow set for new group
		_Controls.list = _Controls_list_copy

		_Controls --return 
	),


	private


	/** _create fake control
	 */
	function _createFakeControl _Controls fake_control_caption across =
	(
		print "AcrossParameterModifier_v._createFakeControl()"
		format "across	= % \n" across
		--_Control = _Controls.control #label fake_control_caption id:(this._generateId()) --add_to_controls:false --return
		_Control = _Controls.control #label fake_control_caption id:(this._generateId()) --add_to_controls:false --return
		
		--_Control.Params.setVal #across across

		--format "FakeControl	= % \n" _Control.id	
		--format "this._generateId()	= % \n" (this._generateId())
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