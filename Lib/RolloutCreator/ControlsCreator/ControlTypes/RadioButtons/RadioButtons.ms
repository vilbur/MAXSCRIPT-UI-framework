/** Changes of defaults 3Ds Max radio buttons
	
	1) Buttons are set to row in default
	
	2) Parameter #offset can be set only as single Point2 value, not necessary define it for each column E.G.:  params:#(#offsets, [8, 16] )
	
	3)
 */
struct RadioButtons_v
(
	--__construct = #( #property_name ),

	/* construct */
	/* dependency */
	/* reference */
	/* inhered */
	/* properties */
	_Control,
	
	/** Set params
	 */
	function setParams _Control =
	(
		this._Control = _Control
		
		this._setLabels()
		
		this._setButtonsToRow()

		----_Control.Params.setVal #offsets #( [0,0], [48,0], [48,32] )
		--
		----labels = _Control.Params.getVal #labels
		----offsets = _Control.Params.getVal #offsets
		----across  = _Control.Params.getVal #across
		
		this._setOffsets()
		
		--_Control.Params.setVal #labels items
		
	),

	
	private
	
	/** 1) Move parameter #items to parameter #labels
	  * 2) Delete parameter #items 
	 */
	function _setLabels =
	(
		--format "\n"; print "RadioButtons_v.setLabels()"
		if _Control.Params.getVal #labels == undefined then 
		(
			_Control.Params.setVal #labels (_Control.Params.getVal #items)

			_Control.Params.delete #items
		)
	),
	
	/**  Set columns same count as labels
	  */
	function _setButtonsToRow =
	(
		labels	= _Control.Params.getVal #labels

		if _Control.Params.getVal #columns == undefined then
			_Control.Params.setVal #columns labels.count
	),
		
	/** Set offsets
	 */
	function _setOffsets =
	(
		--format "\n"; print "RadioButtons_v.setOffsets()"
		--format "_Control	= % \n" _Control.caption

		labels  = _Control.Params.getVal #labels
		columns = _Control.Params.getVal #columns
		
		--offset = _Control.Params.getVal #offset
		offsets = _Control.Params.getVal #offsets

		offsets_all = #()
		
		controls_in_row = 1
		
		row = 0

		if( offsets != undefined and classof offsets == Point2 ) then
		(
			for i = 1 to labels.count do
			(
				is_new_row = labels.count / i as float
				
				append offsets_all [offsets.x, offsets.y]

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
