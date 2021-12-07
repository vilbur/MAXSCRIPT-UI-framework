filein( getFilenamePath(getSourceFileName()) + "/ControlValue/ControlValue.ms" )

/** Control Params http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_EA37E7DB_1E74_4377_B3D8_EDAE19CE27E7_htm
  * 
  * ControlParams_v set parameters of control
  * 
 */
struct ControlParamsCreator_v
(
	/* inherit */
	ControlDefaults, -- defaults parameters for controls
	
	/* dependency */
	ControlValue 	= ControlValue_v(),

	/* properties */ 
	MergeParamsList,
	
	/** Get params for control
	  * 
	  * 
	 */
	function mergeParams &_Control =
	(
		--format "\n"
		--print "ControlParamsCreator_v.mergeParams()"
		--format "_Control	= % \n" _Control
		MergeParamsList 	= List_v()
		/* VALUE PARAM */ 
		--if( ( value_param = this._getVaueParameter(_Control)) != undefined ) then
		--(
			
		--format "value_param	= % \n" value_param
			--MergeParamsList.setVal value_param[1] value_param[2]
		
		--)
		/* CONTROLS PARMAS */ 
		MergeParamsList.merge (_Control.Params)
		--format "_Control.Params	= % \n" MergeParamsList
		
		/* DEFAULTS PARMAS */ 
		for defautls_key in this._getDefaultKeys(_Control.type) do
		(
			
			MergeParamsList.merge (ControlDefaults.getVal(defautls_key as name ))
			--format "% = % \n" defautls_key MergeParamsList
		)

		/* MERGE Defaults.keys.#global */ 
		MergeParamsList.merge ( ControlDefaults.getVal(#global) )
		--format "MergeParamsList	= % \n" MergeParamsList
		
		
		_Control.params = MergeParamsList
		
		_Control --return
	),
	
	/** Set control defaults
	 */
	function setControlDefaults ControlDefaults =
	(
		--print "ControlParamsCreator_v.setControlDefaults()"
		this.ControlDefaults = ControlDefaults
		
		this.ControlDefaults.setDefaultsForAllTypes()
	),
	
	/** Join array
	 */
	function join List =
	(
		if( List == undefined ) then
			return ""
		
		--print "\nHOTFIX Params_v.join()"
		_params = ""
		
		for k=1 to List.keys.count do
			_params += List.keys[k] as string +":"+ this._formatToString(List.values[k]) + " "
			
		trimRight _params  --return
	),


	
	
	private
	
	/** _get vaue parameter
	 */
	function _getVaueParameter _Control =
	(
		--print "ControlParamsCreator_v._getVaueParameter()"
		value_param_name =	ControlValue._getNameOfValueParameter( _Control.type )
		
		value_param = _Control.Params.getVal(value_param_name)

		if( value_param != undefined ) then
			#( value_param_name, value_param )
		
		
	),

	/** merge all default types matchi
	  *
	  *
	  *
	  
	  * e.g: match #list|#listbox|#multilistbox   if control_type == "multilistbox"
	 */
	function _getDefaultKeys control_type =
	(
		--print "ControlParamsCreator_v._getDefaultKeys()"
		
		defautls_keys = for defautls_key in this._flipKeysByLenght(ControlDefaults.keys) where  matchPattern (control_type as string ) pattern:( "*" + (defautls_key as string ) + "*") collect defautls_key
		--format "defautls_keys	= % \n" defautls_keys
		defautls_keys --return
	),	
	
	/**  
	  *	
	  */
	function _flipKeysByLenght arr =
	(
		arr = sort (deepCopy arr)
		
		for i=arr.count to 1 by -1 collect arr[i]
	),

	/** Format value to string
	  *
	  * @return	string	
	 */
	function _formatToString val =
	(
		--print ("Params_v._formatToString() " + val as string)
		if( classOf val == name ) then
			val = "#" + val as string -- Add "#" prefix to name
		
		else if( classOf val == string ) then
			val = "\"" + val +"\"" -- Wrap string to escaped qoutes \"\"
			
		else if( classOf val == Array ) then
			val = this._stringifyArray val -- Wrap string to escaped qoutes \"\"
		
		val as string --return
	),
	
	/** Stringify array
	  *
	  * Workoraund for "as string"
	  * "as string" works only for array with max 20 items
	  * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_92B98D11_60FF_4742_A1BA_692EE135E085_htm
	  *
	  * @return	string	
	  */
	function _stringifyArray arr =
	(
		if( arr.count > 20 ) then
		(
			items_string = ""
			
			for item in arr do items_string += "\"" + item + "\","
			
			"#("+( trimRight items_string ",")+")" --return
		)
		else
			arr as string --return
	),

	on create do
	(
	)
)