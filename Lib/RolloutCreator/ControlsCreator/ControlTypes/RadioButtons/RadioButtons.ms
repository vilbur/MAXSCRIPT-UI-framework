/** Radio buttons
 */
struct RadioButtons_v
(
	--__construct = #( #property_name ),

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	/** Set params
	 */
	function setParams _Control =
	(
		--format "\n"; print "RadioButtons_v.setParams()"
		columns = _Control.Params.getVal #columns
		items = _Control.Params.getVal #items

		--_Control.Params.setVal #offsets #( [0,0], [48,0], [48,32] )

		/* Set button in row */ 
		if( columns == undefined ) then 
			_Control.Params.setVal #columns items.count

		_Control.Params.setVal #labels items

		--labels = _Control.Params.getVal #labels
		offsets = _Control.Params.getVal #offsets
		across = _Control.Params.getVal #across

		this._setOffsets(_Control)
	),

	private

	/** Set offsets
	 */
	function _setOffsets _Control =
	(
		--format "\n"; print "RadioButtons_v.setOffsets()"
		--format "_Control	= % \n" _Control.caption

		labels = _Control.Params.getVal #labels
		columns = _Control.Params.getVal #columns
		
		--offset = _Control.Params.getVal #offset
		offsets = _Control.Params.getVal #offsets

		offsets_all = #()
		
		controls_in_row = 1
		
		row = 0

		if( offsets != undefined ) then
		(
			for i = 1 to labels.count do
			(
				is_new_row = labels.count / i as float
				
				--if controls_in_row == 1 then 
				--	append offsets_all [offsets.x, 0]
				--	
				--else
					append offsets_all [offsets.x, 0]

				if controls_in_row == columns then 
					controls_in_row = 1
				
				else
					controls_in_row += 1
									
			 )
			--format "OFFSETS	= % \n" offsets_all
			_Control.Params.setVal #offsets offsets_all
		)

	),

	/**  
	 */
	on create do
	(
		--print("RadioButtons_v.onCreate()")
		--ConstructPropeties test:this
	)

)
