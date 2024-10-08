/** Control value
 */
struct ControlValue_v
(
	/* properties */
	Ini,
	_Control,

	/** Each control has different property where value is stored
	  *
	  * E.G.: EditText.text|Checkbox.checked|Spinner.range
	  *
	  * Used for pass value: parameter on Control creation as well
	  */
	names_of_value_param = #(
		#( #SELECTION,	#Listbox,	#Multilistbox,	#Dropdownlist, #Combobox	),
		#( #CHECKED,	#Checkbox,	#Checkbutton		),
		#( #RANGE,  	#Spinner,	#Slider,	#Angle	),
		#( #TEXT,  	#Edittext,	#BrowsePath		),
		#( #DEFAULT,  	#RadioButtons			),
		#( #MATERIAL,  	#Materialbutton			),
		#( #COLOR,  	#ColorPicker			),
		#( #BITMAP,  	#Bitmap			),
		#( #ADDRESS,  	#hyperlink			)
	),

	/** Add value parameter
	  *
	  * Priority of value definition
	  * 	1) value from ini file - if control`s parameter ini: is not false
	  * 	2) user defined value
	 */
	function setControlValue _Control rollout_id =
	(
		--print "ControlCreator_v._setControlValue()"
		this._Control = _Control

		/* if control type has value E.G.: #label or #groupbox HAS NOT VALUE */
		if (value_param_name = this._getNameOfValueParameter() ) == undefined  then
			return false

		--ini_allowed = _Control.Params.getVal (#ini)
		ini_allowed = if ( ini_val = _Control.Params.getVal (#ini) ) != undefined then ini_val else true

		 if ini_allowed and ( ini_value = this._getIniValue (rollout_id)) != undefined then
			this._setValue (value_param_name) (ini_value)

		else if( _value = this._getValueParameter (value_param_name) ) != undefined then
			this._setValue(value_param_name)(_value)

		_Control.Params.delete (#value)
		_Control.Params.delete (#ini)
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
	function _getNameOfValueParameter =
	(
		--print "ControlValue_v._getNameOfValueParameter()"
		name_of_param = for param_name_array in names_of_value_param where findItem param_name_array _Control.type > 0 collect param_name_array[1]

		if( name_of_param.count > 0 ) then
			name_of_param[1] --return
	),


	/** Get value from ini file
	 */
	function _getIniValue rollout_id =
	(
		--format "\n"; print "ControlValue_v._getIniValue()"
		if Ini.isDefined() and (ini_value = Ini.load(rollout_id)(_Control.id)) != undefined then
			ini_value --return
		--(
		--	format "INI_VALUE	= % \n" ini_value
		--	format "classOf ini_value	= % \n" (classOf ini_value)
		--)
	),


	/** Get value parameter
	 */
	function _getValueParameter value_param_name =
	(
		--format "\n"; print "ControlValue_v.getValueParameter()"

		if( ( _value = _Control.Params.getVal (#value) ) == undefined ) then --try get parameter #value  e.g.: params:#(#value, true)
			_value = _Control.Params.getVal (value_param_name)	            --try get parameter by name e.g.: params:#(#checked, true)

		_value --return
	),

	/** Set parameter of value with correct name for control type
	  * 	then remove #value paramater
	  *
 	  * E.G.: set #checked parameter and delete #value
	  *
	 */
	function _setValue value_param_name _value =
	(
		_value = this._setValueToDatatype(value_param_name)(_value)

		_Control.Params.setVal (value_param_name) (_value)
	),

	/** Set value  correctto datatype
	  *
	  * Cover special cases as Range datatype, or number in text field, which is treaded as number, but IT MSUT be string for edit text for example
	  *
	  * Ini_v is converting string to datatype, but in some caseses error can occured, E.G.: 0 >>> "0"
	  *
	  */
	function _setValueToDatatype value_param_name _value  =
	(
		--format "\n"; print "ControlValue_v._setValueToDatatype()"

		/** Format string value to valid datatype
		  *
		  * @return	point3
		 */
		function setValueIntoRange _value =
		(
			--format "\n"; print "ControlValue_v._setValueIntoRange()"

			if classOf _value != point3  then
			(
				_range = _Control.Params.getval #range

				_range.z = _value

				_range --return
			)
			else
				_value --return
		)

		case value_param_name of
		(
			#RANGE:	setValueIntoRange (_value)
			#TEXT:	_value as string
			#COLOR:	_value as point3
			default:	_value

			/* BELOW ANOTHER CONTROLS DATATYPES */
			--#SELECTION:
			--#DEFAULT:
			--#MATERIAL:
			--#BITMAP:
			--#ADDRESS:
		)
	),


	/**
	 */
	on create do
	(
		--print("CotrolValue_v.onCreate()")
	)
)