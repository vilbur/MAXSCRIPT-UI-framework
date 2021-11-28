/** Control value
 */
struct ControlValue_v
(
	/* properties */
	ini_path,
	
	/** Each control has different property where value is stored
	  * E.G.: EditText.text|Checkbox.checked|Spinner.range 
	  *	
	  */
	names_of_value_param = #(
		#( #selection,	#listbox,	#multilistbox,	#dropdownlist ),
		#( #checked,	#checkbox,	#checkbutton,	#dropdownlist ),
		#( #range,  	#spinner ),
		#( #text,  	#edittext )
	),
	
	/** Get value from ini
	  *
	  * @return	#( #parma_name, "value" )|undefined 
	 */
	function getValueFromIni _Control rollout_id =
	(
		--print "CotrolValue_v.getValueFromIni()"
		if( ini_path == undefined ) then
			return undefined

		if( (name_of_param = this._getNameOfValueParameter(_Control.type)) == undefined ) then
			return undefined
		
		if( (val_ini = getINISetting ini_path rollout_id _Control.id) != "" ) then
			#(name_of_param, this._convertDatatype(val_ini))
	),
	
	/** _get name of value parameter
	 */
	function _getNameOfValueParameter control_type =
	(
		--print "ControlValue_v._getNameOfValueParameter()"
		name_of_param = for param_name_array in names_of_value_param where findItem param_name_array control_type > 0 collect param_name_array[1]
		
		if( name_of_param.count > 0 ) then
			name_of_param[1] --return
	),
	
	/** Format string value to valid datatype
	 */
	function _convertDatatype val =
	(		
		if( (for pattern in #( "true", "false", "color*", "[*,*]" ) where matchPattern val pattern:pattern collect pattern).count > 0 ) then 
			execute val

		else if( ( val_as_number = val as number) != undefined ) then 
			val_as_number --return
			
		else
			val --return
	),
	
	/**  
	 */
	on create do
	(
		--print("CotrolValue_v.onCreate()")
	)
)