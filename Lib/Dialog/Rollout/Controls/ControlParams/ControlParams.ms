/** Control Params http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_EA37E7DB_1E74_4377_B3D8_EDAE19CE27E7_htm
  * 
  * Params_v is for store, get and set parameters of control
  * 
 */
struct ControlParams_v
(
	defaults = "",
	
	/** _get params
	 */
	function getParams params =
	(
		--format "\n"
		--print "ControlCreator_v._getParams()"
		--format "defaults	= % \n" defaults
		if( params == undefined ) then
			params = ""
		
		if ( classOf params == Array ) then
			params = this._joinParamsInArray params
		--format "getParams return % \n" (params + " " + defaults)
		params + " " + defaults
	),
	
	/** Set defaults
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
			_params += keys[k] as string +":"+ this._getFormat values[k] + " "
			
		trimRight _params  --return
	),
	
	/** Format value to string
	  *
	  * @return	string	
	 */
	function _getFormat val =
	(
		--print ("Params_v._getFormat() " + val as string)
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

	/** Check if required properties are defined
	  * Names of construct props are defined in __construct array E.g.: __construct = #( #prop_name ) 
	  * @param	construct_properties this.properties required for initialization of struct
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("Undefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	on create do
	(
		--this._checkConstctructProperties()
		--format "Params_v.onCreate()"
	)
)