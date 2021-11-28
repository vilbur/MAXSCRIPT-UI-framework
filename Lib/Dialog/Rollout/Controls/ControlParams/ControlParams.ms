filein( getFilenamePath(getSourceFileName()) + "/ControlValue/ControlValue.ms" )
/** Control Params http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_EA37E7DB_1E74_4377_B3D8_EDAE19CE27E7_htm
  * 
  * ControlParams_v set parameters of control
  * 
 */
struct ControlParams_v
(
	/* properties */
	defaults = "", -- defaults parameters for controls
	
	/* dependency */
	ControlValue 	= ControlValue_v(),
	
	/** Get params for control
	 */
	function getParams _Control rollout_id =
	(
		--print "ControlCreator_v._getParams()"
		params = _Control._params

		if( params == undefined ) then
			params = ""
		
		if ( classOf params == Array ) then
			params = this._joinParamsInArray params
		
		val_ini = ControlValue.getValueFromIni(_Control)(rollout_id)

		(this._getValueParam(_Control)(val_ini)) +" "+  params +" "+ defaults -- first occurrence of parameter is used
	),
	
	/** Convert value for control type
	  *
	  * @return	string E.G.: "checked:true"	
	 */
	function _getValueParam _Control val_array =
	(
		if( val_array == undefined ) then
			return ""
		
		if( _Control.type == #spinner ) then
			val_array[2] = this._getSpinnerRange (_Control.params)(val_array[2])

		val_array[1] as string +":"+ this._formatToString(val_array[2])
	),
	
	/** Get spinner value
	  *
	  * @return	point3 as string	
	 */
	function _getSpinnerRange params val =
	(
		range = if( (index = findItem params #range ) > 0 ) then params[index+1] else [0,100,0] -- get defined range or default
		
		range[3] = val -- assign value from array E.G.: #(#range, "3")
		
		range
	),
	
	/** Set defaults params used for each controlfilein( getFilenamePath(getSourceFileName()) + "/ControlValue/ControlValue.ms" )
	 */
	function setDefaults ControlDefaults =
	(
		defaults = this.join ControlDefaults.keys ControlDefaults.values
	),
	
	/** _join params in array
	  *
	  * @property	Array	key_value_array	#( #key1, "value1", #key2, "value2" )
	  *
	  * @return	string	E.G.: '#key1:"value1" #key2:"value2"'
	 */
	function _joinParamsInArray key_value_array =
	(
		--print "ControlParams_v._joinParamsInArray()"
		keys_values = this._convertArrayToMatrix key_value_array

		this.join keys_values[1] keys_values[2] --return 
	),
	
	/** 
	 * @property	Array	key_value_array	#( #key1, "value1", #key2, "value2" )
	 *  
	 *  @return	matrix	#( keys, values )
	 */
	function _convertArrayToMatrix key_value_array =
	(
		--print "ControlCreator_v._convertArrayToMatrix()"
		--format "params	= % \n" params
		keys_values = #(#(),#())
		
		for i = 1 to key_value_array.count  by 2  do
		(
			append keys_values[1] key_value_array[i]
			append keys_values[2] key_value_array[i+1]
		)
		
		--format "params_string	= % \n" params_string
		keys_values --return
	),
	
	/** Join array
	 */
	function join keys values =
	(
		--print "\nHOTFIX Params_v.join()"
		_params = ""
		
		for k=1 to keys.count do
			_params += keys[k] as string +":"+ this._formatToString values[k] + " "
			
		trimRight _params  --return
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
	
	/** Filter unsupplied parameters
	  * Return only supplied parameters
	  *
	  * @param	array keys array of keys
	  * @param	array keys array of values
	  *
	  * @return	matrix #( #(parameter_names), #(parameter_values ))		
	  *
	  * @example
	  *		param_name_and_value = this._filterUnsuppliedParameters #(#param_1, #param_2) #(unsupplied, "value_2") 
	  *		-- return #( #(#param_2), #("value_2") )
     */
    function _filterUnsuppliedParameters keys values =
    (
		keys_values = List_v()
		
		for i = 1 to values.count  where not ( values[i] == unsupplied ) do
			keys_values.setVal keys[i] values[i]

		keys_values --return
    ),

	on create do
	(
	)
)