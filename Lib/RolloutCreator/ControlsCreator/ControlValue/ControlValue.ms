/** Control value
 */
struct ControlValue_v
(
	/* properties */
	Ini,

	default_range = [0,100,0],
	
	/** Each control has different property where value is stored
	  * E.G.: EditText.text|Checkbox.checked|Spinner.range 
	  *	
	  */
	names_of_value_param = #(
		#( #SELECTION,	#Listbox,	#Multilistbox,	#Dropdownlist, #Combobox	),
		#( #CHECKED,	#Checkbox,	#Checkbutton		),
		#( #RANGE,  	#Spinner,	#Slider,	#Angle	),	
		#( #TEXT,  	#Edittext,	#BrowsePath		),
		#( #DEFAULT,  	#RadioButtons			)
	),

	/** Add value parameter
	  * 
	  * Priority of value definition
	  * 	1) value from ini file
	  * 	2) user defined value
	  * 	3) default value
	 */
	function setControlValue _Control rollout_id = 
	(
		print "ControlCreator_v._setControlValue()"

		/* if control type has value E.G.: #label or #groupbox HAS NOT VALUE */ 
		if (value_param_name = this._getNameOfValueParameter( _Control.type ) ) == undefined  then 
			return false		
		
		/* Get value from ini */ 
		if Ini.isDefined() and (ini_value = Ini.load(rollout_id)(_Control.id)) != undefined then
			--_Control.Params.setVal value_param_name (this._convertDatatype(_Control)(ini_value))
			this._setValueByIni _Control value_param_name ini_value
			
		else
			this._setValueByParameter (_Control)(value_param_name)
	),
	
	/** Each control type has different name of parameter for default value
	  * 
	  * E.G.: 
	  * 	#checkbox	checked:true
	  * 	#listbox	selection:3
	  * 	#radiobuttons	default:3
	  * 
	  *  @return	name of parameter
	 */
	function _getNameOfValueParameter control_type =
	(
		--print "ControlValue_v._getNameOfValueParameter()"
		name_of_param = for param_name_array in names_of_value_param where findItem param_name_array control_type > 0 collect param_name_array[1]

		if( name_of_param.count > 0 ) then
			name_of_param[1] --return
	),

	/** Set value by ini
	 */
	function _setValueByIni _Control value_param_name _value =
	(
		--format "\n"; print "ControlValue_v._setValueByIni()"
		if (this._isRangeControlType(_Control.type)) then
			_value = this._setValueIntoRange (_Control) (_value)
			
		_Control.Params.setVal value_param_name _value
	),

	/** Set parameter of value with correct name for control type
	  * 	then remove #value paramater
	  *
 	  * E.G.: set #checked parameter and delete #value
	  *
	 */
	function _setValueByParameter _Control value_param_name =
	(
		format "\n"; print "ControlValue_v._setValueByParameter()"

		if( ( _value = _Control.Params.getVal (#value) ) == undefined ) then --try get parameter #value  e.g.: params:#(#value, true)
			_value = _Control.Params.getVal (value_param_name)	            --try get parameter by name e.g.: params:#(#checked, true)
			format "_VALUE	= % \n" _value

		if( _value != undefined ) then
		(
			if (this._isRangeControlType(_Control.type)) then
				_value = this._setValueIntoRange (_Control) (_value)
			format "_VALUE	= % \n" _value
			_Control.Params.delete (#value)
			_Control.Params.delete (value_param_name)
			
			_Control.Params.setVal (value_param_name) (_value)
		)
	),
	
	/** Format string value to valid datatype
	  * 
	  * @return	point3	
	 */
	function _setValueIntoRange _Control _value =
	(
		format "\n"; print "ControlValue_v._setValueIntoRange()"
		format "_value	= % \n" _value
		if classOf _value != point3  then
		(
			 _range = if( ( range_param = _Control.Params.getval #range ) != undefined ) then range_param else default_range
			format "_range	= % \n" _range
			_range.z = _value
			
			_range --return
		)
		else
			_value --return 
	),
	
	/** Is range control type
	 */
	function _isRangeControlType control_type =
	(
		--format "\n"; print "ControlValue_v._isRangeControlType()"
		findItem names_of_value_param[3] control_type > 0
	),
	
	/**  
	 */
	on create do
	(
		--print("CotrolValue_v.onCreate()")
	)
)