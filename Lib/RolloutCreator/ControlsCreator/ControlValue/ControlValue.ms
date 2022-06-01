/** Control value
 */
struct ControlValue_v
(
	/* properties */
	ini_path,
	Ini,

	/** Each control has different property where value is stored
	  * E.G.: EditText.text|Checkbox.checked|Spinner.range 
	  *	
	  */
	names_of_value_param = #(
		#( #SELECTION,	#listbox,	#multilistbox,	#dropdownlist, #combobox ),
		#( #CHECKED,	#checkbox,	#checkbutton ),
		#( #RANGE,  	#spinner ),	
		#( #DEFAULT,  	#RadioButtons ),	
		#( #TEXT,  	#edittext,	#browsePath  )
	),

	/** _add value parameter
	 */
	function setControlValue _Control rollout_id = 
	(
		print "ControlCreator_v._setControlValue()"
		--format "_Control.type	= % \n" _Control.type
		--val_ini	= ParamsCreator.ControlValue.getValueFromIni(_Control)(rollout_id)
		--format "Ini	= % \n" Ini
		value_param_name = this._getNameOfValueParameter( _Control.type )

		if value_param_name != undefined  then 
		(
			/* Get value from ini */ 
			if Ini.isDefined() then
			(

				format "value_param_name	= % \n" value_param_name

				ini_value = Ini.load(rollout_id)(_Control.id)
				format "ini_value	= % \n" ini_value

				_Control.Params.setVal value_param_name ini_value

			) else
			(

				_Control.Params.setVal value_param_name 2
			)

		)

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

		if( (val_ini = getINISetting ini_path (rollout_id as string ) (_Control.id as string )) != "" ) then
			#(name_of_param, this._convertDatatype(_Control)(val_ini))
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
	function _convertDatatype _Control val =
	(
		if classOf (val_converted = try((execute(val)))catch()) == UndefinedClass then val_converted = substituteString val "\\" "\\\\"

		if( _Control.type == #spinner ) then
		(
			_range = _Control.Params.getval #range

			_range.y = val_converted

			_range --return

		) else
			val_converted --return
	),

	/**  
	 */
	on create do
	(
		--print("CotrolValue_v.onCreate()")
	)
)